class CalendarController {
	
	static accessControl = {
		permission(perm: new EtudePerm('Calendrier', [ 'Consultation' ]), action: 'show')
	}
    def index = { redirect(action:show,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [index:'POST', show:'GET']


	void processParams(params){
        if(!params.max)params.max = 18
        if(!params.offset)params.offset = 0
		if(!params.sort){
			params.sort = "numero"
			params.order = "desc" 
		}
	}
    def show = {
    }
}
