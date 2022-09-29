import grails.util.Environment

class AdminController {
    def index = { redirect(action:menu,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', doBparseValueackupShare:'POST',doUpdate:'POST']
	AdminService adminService

    static accessControl = {
		permission(perm: new EtudePerm("Administration", [ 'Liste' ]), action: 'menu')
		permission(perm: new EtudePerm("Administration", [ 'Modification' ]), only: [ 'maintenance', 'dst', 'status', 'reboot', 'shutdown', 'monitor', 'monitorJob', 'iplookup', 'schedule', 'unschedule', 'trigger', 'listJobs', 'update', 'upload', 'doUpload', 'doUpdate', 'download', 'backup', 'restore', 'doRestore', 'allow', 'abortJob'])
	}
	def menu = {
	}
	
    def maintenance = {
		
    	[dst:adminService.dstEnabled,currentDate:adminService.currentDate,jobs:(adminService.listJobs("userjobs").userjobs), serverStatus: [:]]
    }
    def red= {
    	flash.message= adminService.red()
    	redirect(uri:'/')
    }
    def dst = {
	def dst = adminService.enableDst(!adminService.dstEnabled)
	flash.message = "Heure d&apos;&eacute;t&eacute; ${dst.result?'a':'d&eacute;sa'}ctiv&eacute;e : ${dst.currentDate}"
	redirect(action:maintenance)
    }
    def status = {
    }
    def reboot = {
		try {
			if (FeatureUtils.isInContainer()){
				adminService.shouldRestart = true
			} else {
				"sudo /home/etude/reboot.sh".execute()
			}
			flash.message = "Red&eacute;marrage lanc&eacute;"
			redirect(action:'maintenance')
		} catch (e){
			log.error(e)
			flash.message = "Echec du red&eacute;marrage du serveur : "+e.localizedMessage
			flash.messageType = "error"
			redirect(action:'maintenance')
		}
    }
    def shutdown = {
		try {
			"sudo /home/etude/shutdown.sh".execute()
			flash.message = "Arr&ecirc;t du serveur"
			redirect(controller:'auth',action:'signOut')
		} catch (e){
			log.error(e)
			flash.message = "Echec de l'arr&ecirc;t : "+e.localizedMessage
			flash.messageType = "error"
			redirect(action:'maintenance')
		}
    }

    def monitor = {
		render "OK"
    }
    def monitorJob = {
		if (adminService.monitorJob(params.job)){response.sendError(500)} else {response.sendError(200)}
    }
    def iplookup = {
		render adminService.iplookup()
    }
    def schedule = {
		if (params.job){adminService.schedule(params.job)}
		chain(action:maintenance)
    }
    def abortJob = {
		if (params.job){adminService.interrupt(params.job)}
		chain(action:maintenance)
    }
    def unschedule = {
		if (params.job){adminService.unschedule(params.job)}
		chain(action:maintenance)
    }
    def trigger = {
		if (params.job){
			adminService.trigger(params.job)
			flash.message = "La t&acirc;che '${g.message(code:params.job)}' &agrave; &eacute;t&eacute; lanc&eacute;e"
		}
		redirect(action:maintenance)
    }
    def listJobs = {
		return [jobs:(adminService.listJobs("userjobs").userjobs)]
    }
	def update = {
	}
	def upload = {
	}
	def doUpload = {
		def f = request.getFile('backup')
		if(!f?.empty) {
			try {
				def backupFile = new File(new File(System.getProperty("user.home")+"/arkilogbackup/"),f.originalFilename)
				backupFile.parentFile.mkdirs()
				new FileOutputStream(backupFile) << f.inputStream				
				adminService.checkBackup(backupFile)
				flash.message = "${f.originalFilename} enregistr&eacute;."
				redirect(action:restore)
			} catch (e){
				log.error("Upload error :${f.originalFilename}", e)
				flash.message = "Echec d'enregistrement de la sauvegarde, merci de v&eacute;rifier que le fichier n'est pas endommag&eacute;"
				flash.messageType="warn"
				redirect(action:upload)
			}
		} else {
			flash.message = 'Le fichier est vide'
			flash.messageType="warn"
			redirect(action:upload)
		}
	}

	def doUpdate = {
		def f = request.getFile('software')
		if(!f?.empty) {
			try {
				adminService.update(f)
				flash.message = "Mise &agrave; du logiciel en cours... Veuillez patienter, ceci peut n&eacute;cessiter quelques minutes."
				redirect(action:status)
			} catch (e){
				log.error("Update error :${f.originalFilename}", e)
				flash.message = "Echec de M.A.J du logiciel, merci de v&eacute;rifier que le fichier n'est pas endommag&eacute;"
				flash.messageType="warn"
				redirect(action:update)
			}
		} else {
			flash.message = 'Le fichier est vide'
			flash.messageType="warn"
			redirect(action:update)
		}
	}

	def download = {
		def backpFolder = new File(System.getProperty("user.home")+"/arkilog${params.filetype ?: 'backup'}/")
		def fileName = params.filename
		if (fileName) {
			if (!params.fromShare) {
				adminService.download(['response':response, file: new File(backpFolder,fileName), fileName:fileName])
			}
		} else {
			flash.message = "Aucun nom de fichier n'a &eacute;t&eacute; sp&eacute;cifi&eacute;"
			flash.messageType = "warn"
			redirect(uri:'/')
		}
	}
	def backup = {
			try {
				def result = adminService.backup()
				flash.message = "Sauvegarde effectu&eacute;e pour les donn&eacute;es de la date suivante : [${etude.relativeDate(time:'true',sentence:'true',date:result.date)}]"
				redirect(action:'restore')
			} catch (e){
				log.error(e)
				flash.message = "Echec de la sauvegarde : "+e.localizedMessage
				flash.messageType = "error"
				redirect(action:'maintenance')
			}
	}
	def restore = {
		def backpFolder = new File(System.getProperty("user.home")+"/arkilogbackup/")
		def now = new Date()
		def year = params.year ?: new java.text.SimpleDateFormat('yyyy').format(now)
		def month = params.month ?: "${new Integer(new java.text.SimpleDateFormat('MM').format(now))}"
		def root = ParamUtils.root() ?: "etude"
		def prefix = "Sauvegarde-"
		if (!backpFolder.exists()){
			backpFolder.mkdirs()
		}
		if (backpFolder.directory){
			def sauvegardeList = backpFolder.listFiles([accept:{!it.directory && it ==~ /.*?\.zip/ && it.name.startsWith(prefix)}] as FileFilter).collect{try {parseBackupFile(it)} catch(e){}}.findAll{it}
			def years = sauvegardeList.collect{new Integer(it.year)}.unique().reverse()
			def months = sauvegardeList.findAll{it.year==year}.collect{new Integer(it.month)}.unique().reverse()
			if (!months.contains(new Integer(month))){
				month = months[0] ? "${months[0]}" : month
			}
			def sauvegardes = sauvegardeList.findAll{it.year==year && it.month==month}.sort{it.date}.reverse().groupBy{ParamUtils.trunc(it.date)}
			return [sauvegardes:sauvegardes,
			year:year,
			month:month,
			years:years,
			months:months
			]
		}
	}
	def doRestore = {
		def backupFile = params.backupFile
		if (!backupFile){
			flash.message = "Aucun fichier de sauvegarde n'a &eacute;t&eacute; s&eacute;lectionn&eacute;"
			redirect(action:'restore')
		} else {
			def backpFolder = new File(System.getProperty("user.home")+"/arkilogbackup/")
			def file = new File(backpFolder,backupFile)
			if (!file.exists()){
				flash.message = "Le fichier de sauvegarde introuvable"
				redirect(action:'restore')
			} else {
				adminService.shouldRestart=true
				flash.message = "La r&eacute;stitution de la sauvegarde est lanc&eacute;e... L'op&eacute;ration peut durer quelques minutes selon la taille de la BD."
				println ("${new Date()} ${session.user} ASKED TO RESTORE ${file.absolutePath}")
				DbRestoreJob.triggerNow(file:file)
				redirect(action:'maintenance')
			}
		}
	}
	
	def parseBackupFile(file){
		def result = [:]
		def split = file.name.split('-')
		result.size = (double)file.length()/(1024*1024)
		result.filename = file.name
		result.appName = split[1]
		result.type = split[0]
		result.year = split[2]
		result.size = file.length()
		result.month = "${new Integer(split[3])}"
		def prefix = "${result.type}-${result.appName}-"
		result.date = new java.text.SimpleDateFormat('yyyy-MM-dd-HHmm').parse(file.name[(prefix.size())..-4])
		return result
	}
	def allow = {
		if (Environment.current==Environment.DEVELOPMENT) {
			adminService.allow()
		}
		redirect(uri:"/")
	}	
}
