
class DbRestoreJob {
	def adminService
	def group = "appserver"
	static triggers = {}
    def execute(context) {
		def file = context.mergedJobDataMap.get('file')
		def shell = "sudo /home/etude/restore.sh ${adminService.dbFolder().absolutePath} ${file.absolutePath}"
		try {
			adminService.execShell(shell)
			adminService.backup()
			RestartJob.triggerNow()
		} catch (e){
			log.error("FAILED TO RESTORE BACKUP :\n${shell}",e)
		}
    }
}
