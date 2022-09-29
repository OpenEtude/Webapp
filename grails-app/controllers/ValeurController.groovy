


class ValeurController {
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST', search:'GET', lookup:'GET']

    static accessControl = {
		permission(perm: new EtudePerm("Valeur", [ 'Liste' ]), only: ['list', 'search', 'lookup'])
		permission(perm: new EtudePerm("Valeur", [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm("Valeur", [ 'Modification' ]), only: [ 'edit', 'update'])
        permission(perm: new EtudePerm("Valeur", [ 'Creation' ]), only: [ 'create', 'save'])
        permission(perm: new EtudePerm("Valeur", [ 'Suppression' ]), only: [ 'delete'])
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
			def parent = Valeur.executeQuery("from $domainClassName where id = :id",[id:parentId])
			parent = parent.empty ? null : parent[0]
			resultats = Valeur.withCriteria{
				and {
					or {
						ilike('libelle',k)
					}
					if (filter && parent) {
						or {
							ne(filter,parent)
							isNull(filter)
						}
					}
				}
				maxResults(params.max.toInteger())
				order(params.sort,params.order)
			}
		} else {
			resultats = Valeur.findAllByLibelleIlike(k, params)
		}
		//Create XML response 
		def mime = ParamUtils.getMime(params)
		render(contentType: mime) { 
			valeurs() { 
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
		def resultats = Valeur.findAllByLibelleIlike(k, params)
		def count = Valeur.countByLibelleIlike(k)
		if (count == 1) {
			redirect(action:show, id: resultats.get(0).id)
		} else if (resultats.empty) {
			flash.message= "Aucun valeur ne correspond &agrave; votre crit&egrave;re de recherche [${params.q}]"
			flash.messageType = "warn"
			redirect(action:"list", count: Valeur.count())
		} else {
			flash.message= "R&eacute;sultats de la recherche de Valeur [${params.q}] :"
			render(view:"list",model:[ valeurList: resultats, 'count':count, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params) ])
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
				def parent = Valeur.executeQuery("from ${params.addTo} where id = :id",[id:parentId])
				parent = parent.empty ? null : parent[0]
				resultats = Valeur.withCriteria{
					isNull(ParamUtils.class2prop(params.addTo))
					maxResults(params.max.toInteger())
					order(params.sort,params.order)
				}
			}
			resultCount = Valeur.createCriteria().get{
				isNull(ParamUtils.class2prop(params.addTo))
				projections { 
					count('id') 
				} 
			}
		}
		resultats = (null !=  resultats ? resultats : Valeur.executeQuery("from Valeur"))
		resultCount = resultCount != null ? resultCount : Valeur.count()
        [ valeurList: resultats, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params), count:resultCount]
    }

    def show = {
		def valeur = Valeur.get( params.id )
		if (!valeur) {
			flash.message = "Valeur introuvable."
            redirect(action:list)
		}
        [ valeur : valeur ]
    }

    def delete = {
        def valeur = Valeur.get( params.id )
        if(valeur) {
            valeur.delete()
            flash.message = g.message(code:'deleted')
            redirect(action:list)
        }
        else {
            flash.message = "Valeur introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def valeur = Valeur.get( params.id )

        if(!valeur) {
                flash.message = "Valeur introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
            return [ valeur : valeur ]
        }
    }

    def update = {
        def valeur = Valeur.get( params.id )
        if(valeur) {
             valeur.properties = params
            if(valeur.save()) {
                flash.message = "Valeur ${valeur} mis &agrave; jour."
                redirect(action:show,id:valeur.id)
            }
            else {
                render(view:'edit',model:[valeur:valeur])
            }
        }
        else {
            flash.message = "Valeur introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def valeur = new Valeur()
        valeur.properties = params
        return ['valeur':valeur]
    }

    def save = {
        def valeur = new Valeur()
        valeur.properties = params
        if(valeur.save()) {
            flash.message = "Valeur ${valeur} cr&eacute;e dans la base."
            redirect(action:show,id:valeur.id)
        }
        else {
            render(view:'create',model:[valeur:valeur])
        }
    }

}