class SecurityFilters {
  def adminService
   def filters = {
      addFlashOnRestart(controller:'*', action:'*') {
         before = {
          params.lang = "fr"
            if(adminService.shouldRestart) {
                flash.message= "Red&eacute;marrage planifi&eacute;, veuillez patienter..."
                flash.etude_restarting = true
             }
            return true
         }
      }
      redirectOnRestart(controller:'admin|auth|home', invert:true) {
         before = {
            if(adminService.shouldRestart) {
                redirect(uri:'/')
                return false
             }
            return true
         }
      }
		  def onFailed = {redirect(uri:'/')}
       before(controller:'ecriture', action:'show') {
           before = {return checkForMarked(params, onFailed)}
       }
       before(controller:'ecriture', action:'edit') {
           before = {return checkForMarked(params, onFailed)}
       }
       before(controller:'ecriture', action:'delete') {
           before = {return checkForMarked(params, onFailed)}
       }
       before(controller:'ecritureDossier', action:'show') {
           before = {return checkForMarked(params, onFailed)}
       }
       before(controller:'ecritureDossier', action:'edit') {
           before = {return checkForMarked(params, onFailed)}
       }
       before(controller:'ecritureDossier', action:'delete') {
           before = {return checkForMarked(params, onFailed)}
       }
   }
   def checkForMarked(params,closure){
	def ecr = params.id ? Ecriture.get(new Long(params.id)) : null
	if (ecr?.marked && !SecUtils.maitre()) {
		closure.call()
		return false
	}
	return true
   }
}