import org.apache.commons.codec.digest.DigestUtils
            
class JsecUserController {
	
	BootStrapService bootStrapService
    
	static accessControl = {
		permission(perm: new EtudePerm('JsecUser', [ 'Liste' ]), action: 'list')
		permission(perm: new EtudePerm('JsecUser', [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm('JsecUser', [ 'Modification' ]), only: [ 'edit', 'update' ])
        permission(perm: new EtudePerm('JsecUser', [ 'Creation' ]), only: [ 'create', 'save' ])
        permission(perm: new EtudePerm('JsecUser', [ 'Suppression' ]), only: [ 'delete'])
    }
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max)params.max = 20
		def roles = new HashMap()
		def jsecUserList = JsecUser.list( params )
		jsecUserList.each(){jsecUser->
			roles.put(jsecUser,JsecUserRoleRel.findAllByUser(jsecUser).collect(){it.role.name})
		}
        [ jsecUserList: jsecUserList, roles:roles ]
    }

    def show = {
		def id = null
		try {id= new Long(params.id)} catch(e){}
		def user = id ? JsecUser.get( params.id ) : JsecUser.findByUsername(params.id)
		if (!user) {flash.message = "Utilisateur introuvable [${params.id}]";flash.messageType="warn";redirect(action:list)}
		def roles = JsecUserRoleRel.findAllByUser(user)
        [ jsecUser : user, roles: roles]
    }

    def delete = {
        def jsecUser = JsecUser.get( params.id )
        if(jsecUser) {
			JsecUserRoleRel.findAllByUser(jsecUser).each(){it.delete()}
            jsecUser.delete()
            flash.message = "Utilisateur ${params.id} supprim&eacute;."
            redirect(action:list)
        }
        else {
            flash.message = "Utilisateur introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
		def user = JsecUser.get( params.id )
		def roles = JsecUserRoleRel.findAllByUser(user).collect{it.role.id}
		def allRoles = JsecRole.list();
		
        if(!user) {
                flash.message = "Utilisateur introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
            return [ jsecUser : user, roles: roles, allRoles: allRoles ]
        }
    }

    def update = {
        def jsecUser = JsecUser.get( params.id )
        if(jsecUser) {
             jsecUser.properties = params
            if(jsecUser.save()) {
			 Integer nbRoles = new Integer(params.nbRoles)
			 for (i in 0..(nbRoles - 1)) {
				def role = JsecRole.findById(new Integer(params["role"+i]))
				def userRoleRel = JsecUserRoleRel.findByUserAndRole(jsecUser, role)
				if (params.get("check"+i)) {
					if (!userRoleRel){
						new JsecUserRoleRel(user:jsecUser, role:role).save()
					}
				} else {
					if (userRoleRel){
						userRoleRel.delete()
					}
				}
			 }
                flash.message = "Utilisateur ${jsecUser.username} mis &agrave; jour."
                redirect(action:show,id:jsecUser.id)
            }
            else {
                render(view:'edit',model:[jsecUser:jsecUser])
            }
        }
        else {
            flash.message = "Utilisateur introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def jsecUser = new JsecUser()
        jsecUser.properties = params
		def allRoles = JsecRole.list();
        return ['jsecUser':jsecUser, allRoles: allRoles ]
    }

    def save = {
        def jsecUser = new JsecUser()
        jsecUser.properties = params
		if (!jsecUser.id || !jsecUser.passwordHash) {
			jsecUser.passwordHash= DigestUtils.shaHex(jsecUser.username)
		}
        if(jsecUser.save()) {
            if(jsecUser.save()) {
			 Integer nbRoles = new Integer(params.nbRoles)
			 for (i in 0..(nbRoles - 1)) {
				def role = JsecRole.findById(new Integer(params["role"+i]))
				def userRoleRel = JsecUserRoleRel.findByUserAndRole(jsecUser, role)
				if (params.get("check"+i)) {
					if (!userRoleRel){
						new JsecUserRoleRel(user:jsecUser, role:role).save()
					}
				} else {
					if (userRoleRel){
						userRoleRel.delete()
					}
				}
			 }
            }
			bootStrapService.populateSettingsForUsers()
            flash.message = "Utilisateur ${jsecUser.username} cr&eacute;e dans la base de donn&eacute;e."
            redirect(action:show,id:jsecUser.id)
        }
        else {
            render(view:'create',model:[jsecUser:jsecUser])
        }
    }

}
