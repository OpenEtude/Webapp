            
class GroupementController {

    static accessControl = {
		permission(perm: new EtudePerm('Groupement', 'Liste'), only: ['list', 'search'])
		permission(perm: new EtudePerm('Groupement', [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm('Groupement', [ 'Modification' ]), only: [ 'edit', 'update' ])
        permission(perm: new EtudePerm('Groupement', [ 'Creation' ]), only: [ 'create', 'save' ])
        permission(perm: new EtudePerm('Groupement', [ 'Suppression' ]), only: [ 'delete'])
	}
	
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max)params.max = 20
        [ groupementList: Groupement.list( params ) ]
    }

    def show = {
		def groupement = Groupement.get( params.id )
		def libelles = TypeEcritureGroupementRel.createCriteria().list{
			eq("groupement", groupement)
		}.collect{it.typeEcriture}
        [ groupement : groupement, libelles:libelles, allLibelles:TypeEcriture.list() ]
    }

    def delete = {
        def groupement = Groupement.get( params.id )
        if(groupement) {
			TypeEcritureGroupementRel.executeUpdate("delete TypeEcritureGroupementRel rel where rel.groupement=:g", [g:groupement])
            groupement.delete()
            flash.message = "Groupement ${params.id} supprim&eacute;."
            redirect(action:list)
        }
        else {
            flash.message = "Groupement introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def groupement = Groupement.get( params.id )

        if(!groupement) {
                flash.message = "Groupement introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
			def libelles = TypeEcritureGroupementRel.createCriteria().list{
				eq("groupement", groupement)
			}.collect{it.typeEcriture}
			return [ groupement : groupement, libelles:libelles, allLibelles:TypeEcriture.list() ]
        }
    }

    def update = {
        def groupement = Groupement.get( params.id )
        if(groupement) {
             groupement.properties = params
            if(groupement.save()) {
				link(groupement, params)
                flash.message = "Groupement ${params.id} mis &agrave; jour."
                redirect(action:show,id:groupement.id)
            }
            else {
                render(view:'edit',model:[groupement:groupement])
            }
        }
        else {
            flash.message = "Groupement introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }


    def create = {
        def groupement = new Groupement()
        groupement.properties = params
        return [ groupement : groupement, allLibelles:TypeEcriture.list() ]
    }

    def save = {
        def groupement = new Groupement()
        groupement.properties = params
        if(groupement.save()) {
			link(groupement, params)
            flash.message = "Groupement ${groupement.id} cr&eacute;e dans la base."
            redirect(action:show,id:groupement.id)
        }
        else {
            render(view:'create',model:[groupement:groupement])
        }
    }
	void link(groupement, params){
			TypeEcritureGroupementRel.executeUpdate("delete TypeEcritureGroupementRel rel where rel.groupement=:grp", [grp:groupement])
			def all = TypeEcritureGroupementRel.list()
			params.findAll{it.key?.startsWith('check')}.each {
				def currentIdx = new Integer(it.key.replace('check',''))
				def id = new Integer(params.get("id"+(currentIdx)))
				def typ = TypeEcriture.get(id)
				def rel = TypeEcritureGroupementRel.findByTypeEcritureAndGroupement(typ,groupement)
				if (!rel) {
					rel = new TypeEcritureGroupementRel(groupement:groupement,typeEcriture:typ)
					rel.save()
				}
			}
	}

}
