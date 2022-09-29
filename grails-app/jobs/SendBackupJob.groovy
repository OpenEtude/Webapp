
class SendBackupJob {
	def emailerService
	def adminService
	
	def group = "userjobs"
	static triggers = {}
    def execute() {
		def attachment = adminService.lastBackup()
		def currentDate = adminService.getCurrentDate()
		def destin = Setting.syssetting('SendBackupJob.to')
		if (attachment && destin){
			emailerService.sendEmail([to:destin,subject:"[${Setting.syssetting('etude')}] Derni\u00E8re sauvegarde de BD \u00E0 la date du ${currentDate}",text:"Bonjour,<br/><br/>Veuillez trouver en PJ la derni\u00E8re sauvegarde de BD \u00E0 la date du ${currentDate}.<br/><br/>Cordialement,<br/><br/>${Setting.syssetting('etude')}.",attachments:attachment])
		} else if (!destin){
			log.error("NO DESTINATION EMAIL(s)")
		} else {
			log.error("NO DATABASE BACKUP FOUND")
		}
	}
}
