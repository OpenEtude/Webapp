


class ChampController {
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST', search:'GET', lookup:'GET']

    static accessControl = {
		permission(perm: new EtudePerm("Champ", [ 'Liste' ]), only: ['list', 'search', 'lookup'])
		permission(perm: new EtudePerm("Champ", [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm("Champ", [ 'Modification' ]), only: [ 'edit', 'update'])
        permission(perm: new EtudePerm("Champ", [ 'Creation' ]), only: [ 'create', 'save'])
        permission(perm: new EtudePerm("Champ", [ 'Suppression' ]), only: [ 'delete'])
    }
	

	def lookup = { 
		processParams(params)
        params.max = 10
		def k = ParamUtils.keyword(params.query)
		def resultats = []
		def filterName = params.find{it.key?.startsWith('filter')}?.key
		def domainClassName = filterName ? filterName - 'filter' : ""
		def filter = domainClassName.size() > 0 ? domainClassName[0].toLowerCase()+domainClassName.substring(1) : null
		Long parentId = null
		try {parentId = new Long(params.get(filterName))}catch(e){}
		if (parentId && filter) {
			def parent = Champ.executeQuery("from $domainClassName where id = :id",[id:parentId])
			parent = parent.empty ? null : parent[0]
			resultats = Champ.withCriteria{
				and {
					or {
						ilike('libelle',k)
					}
					if (filter && parent) {
						or {
							typeDeBien{
								eq('id',parent.id)
							}
							isNull(filter)
						}
					}
				}
				maxResults(params.max.toInteger())
				order(params.sort,params.order)
			}
		} else {
			resultats = Champ.findAllByLibelleIlike(k, params)
		}
		//Create XML response 
		def mime = ParamUtils.getMime(params)
		render(contentType: mime) { 
			champs() { 
				resultats.each { 
					d -> result(){ 
						name(d.libelle) 
						id(d.id) 
						code(d.id) 

					}
				} 
			} 
		} 
	} 
    def search = {
		processParams(params)
		def k = ParamUtils.keyword(params.q)
		def resultats = Champ.findAllByLibelleIlike(k, params)
		def count = Champ.countByLibelleIlike(k)
		if (count == 1) {
			redirect(action:show, id: resultats.get(0).id)
		} else if (resultats.empty) {
			flash.message= "Aucun champ ne correspond &agrave; votre crit&egrave;re de recherche [${params.q}]"
			flash.messageType = "warn"
			redirect(action:"list", count: Champ.count())
		} else {
			flash.message= "R&eacute;sultats de la recherche de Champ [${params.q}] :"
			render(view:"list",model:[ champList: resultats, 'count':count, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params) ])
		}
    }

	void processParams(params){
        if(!params.max)params.max = 15
		if(!params.sort){
			params.sort = "id"
			params.order = "desc" 
		}
	}

    def list = {
        processParams(params)
		def resultats = null
		def resultCount = null
		if (params.mode == 'select' && params.id && params.addTo) {
			Long parentId = null
			try {parentId = new Long(params.id)}catch(e){}
			if (parentId) {
				def parent = Champ.executeQuery("from ${params.addTo} where id = :id",[id:parentId])
				parent = parent.empty ? null : parent[0]
				resultats = Champ.withCriteria{
					isNull(ParamUtils.class2prop(params.addTo))
					maxResults(params.max.toInteger())
					order(params.sort,params.order)
				}
			}
			resultCount = Champ.createCriteria().get{
				isNull(ParamUtils.class2prop(params.addTo))
				projections { 
					count('id') 
				} 
			}
		}
		resultats = resultats != null ? resultats: Champ.list( params )
		resultCount = resultCount != null ? resultCount : Champ.count()
        [ champList: resultats, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params), count:resultCount]
    }

    def show = {
		def champ = Champ.get( params.id )
		if (!champ) {
			flash.message = "Champ introuvable."
            redirect(action:list)
		}
        [ champ : champ ]
    }

    def delete = {
        def champ = Champ.get( params.id )
        if(champ) {
            champ.delete()
            flash.message = g.message(code:'deleted')
            redirect(action:list)
        }
        else {
            flash.message = "Champ introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def champ = Champ.get( params.id )

        if(!champ) {
                flash.message = "Champ introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
            return [ champ : champ ]
        }
    }

    def update = {
        def champ = Champ.get( params.id )
        if(champ) {
             champ.properties = params
            if(champ.save()) {
                flash.message = "Champ ${champ} mis &agrave; jour."
                redirect(action:show,id:champ.id)
            }
            else {
                render(view:'edit',model:[champ:champ])
            }
        }
        else {
            flash.message = "Champ introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def champ = new Champ()
        champ.properties = params
        return ['champ':champ]
    }

    def save = {
        def champ = new Champ()
        champ.properties = params
		def typeDeBien = TypeDeBien.get(params.get("typeDeBien.id"))
		champ.typeDeBien = typeDeBien
        if(champ.save()) {
            flash.message = "Champ ${champ} ajout&eacute;."
            redirect(controller:'typeDeBien', action:show,id:typeDeBien.id)
        }
        else {
            render(view:'create',model:[champ:champ])
        }
    }

}