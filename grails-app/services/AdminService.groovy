import org.quartz.CronTrigger
import org.springframework.jdbc.core.JdbcTemplate
import java.io.FileOutputStream
import java.util.zip.ZipOutputStream
import java.util.zip.ZipEntry


class AdminService {
	def quartzScheduler
	def licService
	def cmdLineArchiveService
	def grailsApplication
	boolean transactional = true
	def conn
	def shouldRestart = false
	String status = "OK"
	def licInfo(){
		licService?.info
	}
	def uninstall(){
		licService.uninstallLic()
	}
	def install(licence){
		licService.installLic(licence)
	}
	private doForJob(name,Closure c){
		def jobName = null
		quartzScheduler.jobGroupNames.each{jobGroup->
			if (!jobName){
				jobName = quartzScheduler.getJobNames(jobGroup).find{it==name}
				if (jobName){
					c(jobGroup,jobName)
				}
			}
		}
		return jobName
	}
	def listJobs(group=null){
		def result = [:]
		def running = quartzScheduler.currentlyExecutingJobs
		quartzScheduler.jobGroupNames.findAll{group ? it == group : true}.each{jobGroup->
			result.put(jobGroup, quartzScheduler.getJobNames(jobGroup).collect{jobName->
				Date fireTime = running.find{it.jobDetail.name==jobName && 
												it.jobDetail.group==jobGroup}?.fireTime
				def trigger = quartzScheduler.getTriggersOfJob(jobName, jobGroup).collect{
					[nextFireTime:it.nextFireTime]
				}.find{it!=null}
				[name:jobName, 'running':fireTime, 'trigger':trigger] 
			}
		)
		}
		return result
	}
	def schedule(name){
		unschedule(name)
		def enabled = Setting.findByKey("${name}.enabled")
		enabled.value = "true"
		enabled.save()
		doForJob(name){jobGroup,jobName->
			def trigger = new CronTrigger(name, "trigger", jobName, jobGroup, Setting.syssetting("${name}.cron") ?: "0 0 10 ? * *")
			trigger.volatility = false
			quartzScheduler.scheduleJob(trigger)
		}
	}
	def trigger(name){
		doForJob(name){jobGroup,jobName->
			quartzScheduler.triggerJob(jobName, jobGroup) 
		}
	}
	def interrupt(name){
		doForJob(name){jobGroup,jobName->
			quartzScheduler.interrupt(jobName, jobGroup) 
		}
	}
	def monitorJob(name){
		listJobs("userjobs")?.userjobs?.find{it.name==name && it.running} != null
	}

	def unschedule(name){
		def enabled = Setting.findByKey("${name}.enabled")
		enabled.value = "false"
		enabled.save()
		doForJob(name){jobGroup,jobName->
			quartzScheduler.unscheduleJob(name, "trigger") 
		}
	}
	def enableDst(enable=true){

			log.info (enable ? "Enabling DST..." : "Disabling DST...")
			def setting = Setting.findByKey("system.dst")
			setting.value = "${enable}"
			if (setting.save()){
				TimeZone.'default'=TimeZone.getTimeZone("GMT${enable ? '+01:00' : ''}")
				log.info ("Current date : "+getCurrentDate())
				try {
					execShell("sudo /home/etude/settz.sh GMT${enable ? '-01:00' : ''}")
				} catch (ex){
					log.error("DST action failed [${ex.'class'.simpleName}] : ${ex.localizedMessage}")
				}
			}
		[currentDate:getCurrentDate(),result:isDstEnabled()]
	}
	def getCurrentDate(){new java.text.SimpleDateFormat('EEEE dd/MM/yyyy HH:mm:ss z',Locale.FRENCH).format(new Date())}
	boolean isDstEnabled(){TimeZone.'default'.displayName == 'GMT+01:00'}
	def update(file){
		def webarchive
		if (file instanceof File){
			webarchive = file
		} else {
			def tstamp = new java.text.SimpleDateFormat('yyyy-MM-dd-HHmm').format(new Date())
			webarchive = new File(new File(System.getProperty("user.home")+"/arkilogsoftware/${tstamp}/"),"${ParamUtils.root() ?: "ROOT"}.war")
			webarchive.parentFile.mkdirs()
			new FileOutputStream(webarchive) << file.inputStream
		}
		if (webarchive.exists() && !webarchive.directory){
			if (!checkZipEntries(webarchive, ["WEB-INF/web.xml"])) {
				throw new IllegalStateException("Logiciel incorrect")
			}

			"/home/etude/update.sh ${ParamUtils.root() ?: "etude"} ${webarchive.canonicalPath}".execute()
		} else {
			throw new IllegalStateException("Fichier incorrect")
		}
	}
	def checkBackup(file){
		if (file.exists() && !file.directory){
			if (!cmdLineArchiveService.checkEntries(file, ["etude.sql"])) {
				file.delete()
				throw new IllegalStateException("Fichier de sauvegarde incorrect")
			}
		} else {
			throw new IllegalStateException("Fichier incorrect")
		}
	}
	boolean checkZipEntries(file, files){
		def mandatoryFiles = files.collect{String.valueOf(it)}
		def entries = new java.util.zip.ZipFile(file).entries().findAll{!it.directory}.collect{String.valueOf(it.name)}
		def result = entries.containsAll(mandatoryFiles)
		if (!result){println "Some of ${mandatoryFiles} NOT FOUND in ${file}\n->>>>>>>${entries}"}
		return result
	}
	def allow(){
		def obj = new Gasper()
		def info = licService.newRequestInfo()
		info.email = "support@apps.arkilog.ma"
		licService.installLic(obj.createLic(obj.createLicRequest(info)))
	}
	def backup(response=null){
		run("Sauvegarde en cours..."){
			boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith('win')
			def output = ""
			try {
				if (isWindows) {
					output = execShell("./docker/cli/dbbackup-win.sh")
				} else {
					output = execShell("/home/etude/dbbackup.sh")
				}
			} catch (ex){
				log.error("DB Backup action failed [${ex.'class'.simpleName}] : ${ex.localizedMessage}")
			} finally {
				log.info("SHELL OUTPUT :\n $output")
			}
			def dbFolder = new File(isWindows ? 'D:/root/arkilogbackup/current/' : '/root/arkilogbackup/current/')
			def bckpDate = new Date()
			def tstamp = new java.text.SimpleDateFormat('yyyy-MM-dd-HHmm').format(bckpDate)
			def backupFolder = new File(System.getProperty("user.home")+"/arkilogbackup/")
			def zipFile = new File(backupFolder,"Sauvegarde-${System.env.RDS_DB_NAME ?: 'etude'}-${tstamp}.zip")
			zipFile.parentFile.mkdirs()
			def exclude = ["*.lck"]
	        def srcFiles = ["etude.sql"]
	        def fos = new FileOutputStream(zipFile)
	        def zipOut = new ZipOutputStream(fos)
	        for (String srcFile : srcFiles) {
	            File fileToZip = new File(dbFolder,srcFile)
	            log.info("About to backup file : [${fileToZip.absolutePath}]")
	            FileInputStream fis = new FileInputStream(fileToZip)
	            ZipEntry zipEntry = new ZipEntry(fileToZip.getName())
	            zipOut.putNextEntry(zipEntry)
	 
	            byte[] bytes = new byte[1024]
	            int length;
	            while((length = fis.read(bytes)) >= 0) {
	                zipOut.write(bytes, 0, length);
	            }
	            fis.close();
	        }
	        zipOut.close();
	        fos.close();
			if (response) {
				response?.setHeader("Content-disposition", "attachment; filename=${zipFile.name}")
				response?.contentType = "application/x-zip-compressed"
				response?.outputStream << new FileInputStream(zipFile)
			} else {
				return [file:zipFile.absolutePath,date:bckpDate]
			}
		}
	}
	def execShell(command){
		if (System.getProperty("os.name").toLowerCase().startsWith('win')) {
			log.info("BASH COMMAND ON WINDOWS : [$command]")
			return new CmdLineArchiver().runShell(["bash", command])
		}
		if (command instanceof List){command = command.join(" ")}
		try {
			return new CmdLineArchiver().runShell(command)
		} catch (e){
			log.error("FAILED TO EXEC COMMAND : [$command]")
			log.error(">>>>>>>>>>>>>>>>>>>>>>> [${e.class.simpleName}] : ${e.localizedMessage}")
			throw new IllegalStateException(e.localizedMessage)
		}
	}
	
	def setBusy(presenceMsg) {
		updatePresence(presenceMsg, true)
	}
	
	def run(msg, Closure task){
		def oldStatus = this.status
		try {
			setStatus(msg)
			task()
		} finally {
			setStatus(oldStatus)
		}
	}
	def lastFileBackup={
		def backpFolder = new File(System.getProperty("user.home")+"/arkilogfilebackup/")
		def root = ParamUtils.root()
		def prefix = "Partage-${root}"
		if (!backpFolder.exists()){
			backpFolder.mkdirs()
		}
		if (backpFolder.directory){
			def last = backpFolder.listFiles([accept:{!it.directory && it ==~ /.*?\.(zip|7z)/ && it.name.startsWith(prefix)}] as FileFilter).findAll{it}.max{it.lastModified()}
			println "MIN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${last}"
			return last ? [(last.name):last] : null
		}
	}
	def lastBackup={
		def backpFolder = new File(System.getProperty("user.home")+"/arkilogbackup/")
		def root = ParamUtils.root()
		def prefix = "Sauvegarde-"
		if (!backpFolder.exists()){
			backpFolder.mkdirs()
		}
		if (backpFolder.directory){
			def last = backpFolder.listFiles([accept:{!it.directory && it ==~ /.*?\.(zip|7z)/ && it.name.startsWith(prefix)}] as FileFilter).findAll{it}.max{it.lastModified()}
			println "MIN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${last}"
			return last ? [(last.name):last] : null
		}
	}
	def download(args){
		def response = args.response
		def file = args.file
		def fileName = (file?.name ?: args.fileName)
		if (response) {
			response?.setHeader("Content-disposition", "attachment; filename=${fileName}")
			response?.contentType = "application/octet-stream"
			response?.outputStream << new FileInputStream(file)
		} else {
			return args
		}
	}
}
