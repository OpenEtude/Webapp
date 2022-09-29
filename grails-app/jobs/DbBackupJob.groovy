
class DbBackupJob {
	def adminService
	def emailerService
	def group = "userjobs"
	static triggers = {}
    def execute() {
		def bckpDate = new Date()
		try {
			adminService.backup()
		} catch (e) {
			log.error("DB BACKUP FAILED",e)
			def destin = 'support@arkilog.ma'
			if (destin) {
				emailerService.sendEmail([to:destin,subject:"[${Setting.syssetting('etude')}] ECHEC de la derni\u00E8re sauvegarde de BD.",text:"Bonjour,<br/><br/>La sauvegarde de BD \u00E0 la date du ${bckpDate} a \u00E9chou\u00E9.<br/><br/>Motif : ${e.localizedMessage}<br/><br/>Cordialement,<br/><br/>${Setting.syssetting('etude')}."])
			}
		}
    }
}
