            
class JsecRoleController  {
    static accessControl = {
		permission(perm: new EtudePerm('JsecUser', [ 'Liste' ]), action: 'list')
		permission(perm: new EtudePerm('JsecUser', [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm('JsecUser', [ 'Modification' ]), only: [ 'edit', 'update' ])
        permission(perm: new EtudePerm('JsecUser', [ 'Creation' ]), only: [ 'create', 'save' ])
    }

	
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max)params.max = 20
	def roles = JsecRole.list( params )
	def users = [:]
	roles.each{users.put(it,JsecUserRoleRel.findAllByRole(it).collect{rel-> rel.user.username})}
        [ jsecRoleList: roles,users:users ]
    }

    def show = {
		def jsecRole = JsecRole.get( params.id )
		def perms = JsecRolePermissionRel.findAllByRole(jsecRole)
		def users = JsecUserRoleRel.findAllByRole(jsecRole).collect{rel->g.link(controller:'jsecUser', action:'show', id:rel.user.id){rel.user.username}}
		[ jsecRole : jsecRole, permissions: perms, users:users]
    }

    def edit = {
        def jsecRole = JsecRole.get( params.id )

        if(!jsecRole) {
                flash.message = "Role introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
		def perms = JsecRolePermissionRel.findAllByRole(jsecRole)
		def users = JsecUserRoleRel.findAllByRole(jsecRole).collect{rel->g.link(controller:'jsecUser', action:'show', id:rel.user.id){rel.user.username}}
            return [ jsecRole : jsecRole, permissions: perms,users:users]
        }
    }

    def update = {
        def jsecRole = JsecRole.get( params.id )
        if(jsecRole) {
             jsecRole.properties = params
			 Integer nbPerms = new Integer(params.nbPerms)
			 for (i in 0..(nbPerms - 1)) {
				def target = params["perm"+i]
				if (target) {
					def nbActions = EtudePerm.allowedActions.size()
					def allowed = new ArrayList()
					for (j in 0..(nbActions - 1)) {
						if (params.get("check"+i+"_"+j)){
							allowed << params["perm"+i+"_"+j]
						}
					}
					if (!allowed.contains("Aucune")) {
						allowed << "Aucune"
					}
					def allowedStr = ""
					allowed.eachWithIndex{act,x->allowedStr+=((x++>0)?",":"")+act}
					def rp = JsecRolePermissionRel.findByRoleAndTarget(jsecRole,target)
					rp.actions = allowedStr
					if (rp.save()){
						log.warn "Role ${jsecRole.name} updated : [$target : $allowedStr]"
					}
				}
			 }
            if(jsecRole.save()) {
                flash.message = "R&ocirc;le ${jsecRole.name} mis &agrave; jour."
                redirect(action:show,id:jsecRole.id)
            }
            else {
                render(view:'edit',model:[jsecRole:jsecRole])
            }
        }
        else {
            flash.message = "Role introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }


    def save = {
        def jsecRole = new JsecRole()
        jsecRole.properties = params
        if(jsecRole.save()) {
            flash.message = "Role ${jsecRole.id} cr&eacute;e dans la base."
            redirect(action:show,id:jsecRole.id)
        }
        else {
            render(view:'create',model:[jsecRole:jsecRole])
        }
    }

}
