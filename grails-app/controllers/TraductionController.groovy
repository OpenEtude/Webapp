            
class TraductionController {
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    static accessControl = {
		permission(perm: new EtudePerm("Traduction", [ 'Liste' ]), action: 'list')
		permission(perm: new EtudePerm("Traduction", [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm("Traduction", [ 'Modification' ]), only: [ 'edit', 'update'])
        permission(perm: new EtudePerm("Traduction", [ 'Creation' ]), only: [ 'create', 'save'])
        permission(perm: new EtudePerm("Traduction", [ 'Suppression' ]), only: [ 'delete'])
    }

    def list = {
        if(!params.max)params.max = 20
        [ traductionList: Traduction.list( params ) ]
    }

    def show = {
        [ traduction : Traduction.get( params.id ) ]
    }

    def delete = {
        def traduction = Traduction.get( params.id )
        if(traduction) {
            traduction.delete()
            flash.message = g.message(code:'deleted')
            redirect(action:list)
        }
        else {
            flash.message = "Traduction introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def traduction = Traduction.get( params.id )

        if(!traduction) {
                flash.message = "Traduction introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
            return [ traduction : traduction ]
        }
    }

    def update = {
        def traduction = Traduction.get( params.id )
        if(traduction) {
             traduction.properties = params
            if(traduction.save()) {
                flash.message = "Traduction ${traduction} mis a jour."
                redirect(action:show,id:traduction.id)
            }
            else {
                render(view:'edit',model:[traduction:traduction])
            }
        }
        else {
            flash.message = "Traduction introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def traduction = new Traduction()
        traduction.properties = params
        return ['traduction':traduction]
    }

    def save = {
        def traduction = new Traduction()
        traduction.properties = params
        if(traduction.save()) {
            flash.message = "Traduction ${traduction} cr&eacute;e dans la base."
            redirect(action:show,id:traduction.id)
        }
        else {
            render(view:'create',model:[traduction:traduction])
        }
    }

}