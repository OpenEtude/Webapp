            
class JsecUserRoleRelController {
    static accessControl = {
		permission(perm: new EtudePerm('JsecUserRoleRel', [ 'Liste' ]), action: 'list')
		permission(perm: new EtudePerm('JsecUserRoleRel', [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm('JsecUserRoleRel', [ 'Modification' ]), only: [ 'edit', 'update' ])
        permission(perm: new EtudePerm('JsecUserRoleRel', [ 'Creation' ]), only: [ 'create', 'save' ])
        permission(perm: new EtudePerm('JsecUserRoleRel', [ 'Suppression' ]), only: [ 'delete'])
    }
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max)params.max = 20
        [ jsecUserRoleRelList: JsecUserRoleRel.list( params ) ]
    }

    def show = {
        [ jsecUserRoleRel : JsecUserRoleRel.get( params.id ) ]
    }

    def delete = {
        def jsecUserRoleRel = JsecUserRoleRel.get( params.id )
        if(jsecUserRoleRel) {
            jsecUserRoleRel.delete()
            flash.message = "JsecUserRoleRel ${params.id} supprim&eacute;."
            redirect(action:list)
        }
        else {
            flash.message = "JsecUserRoleRel introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def jsecUserRoleRel = JsecUserRoleRel.get( params.id )

        if(!jsecUserRoleRel) {
                flash.message = "JsecUserRoleRel introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
            return [ jsecUserRoleRel : jsecUserRoleRel ]
        }
    }

    def update = {
        def jsecUserRoleRel = JsecUserRoleRel.get( params.id )
        if(jsecUserRoleRel) {
             jsecUserRoleRel.properties = params
            if(jsecUserRoleRel.save()) {
                flash.message = "JsecUserRoleRel ${params.id} mis &agrave; jour."
                redirect(action:show,id:jsecUserRoleRel.id)
            }
            else {
                render(view:'edit',model:[jsecUserRoleRel:jsecUserRoleRel])
            }
        }
        else {
            flash.message = "JsecUserRoleRel introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def jsecUserRoleRel = new JsecUserRoleRel()
        jsecUserRoleRel.properties = params
        return ['jsecUserRoleRel':jsecUserRoleRel]
    }

    def save = {
        def jsecUserRoleRel = new JsecUserRoleRel()
        jsecUserRoleRel.properties = params
        if(jsecUserRoleRel.save()) {
            flash.message = "JsecUserRoleRel ${jsecUserRoleRel.id} cr&eacute;e dans la base de donn&eacute;e."
            redirect(action:show,id:jsecUserRoleRel.id)
        }
        else {
            render(view:'create',model:[jsecUserRoleRel:jsecUserRoleRel])
        }
    }

}
