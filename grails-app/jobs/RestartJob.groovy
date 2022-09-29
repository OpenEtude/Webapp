
class RestartJob {
	def adminService
	def group = "appserver"
	static SECONDS = 1000
	static restart = "sudo /home/etude/restart.sh"
	static triggers = { 
	}
    def execute() {
		log.info("RESTART IN 7s")
    	Thread.sleep(7*SECONDS)
    	adminService.execShell(restart)
    }
}
