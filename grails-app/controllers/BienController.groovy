


class BienController {
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST', search:'GET', lookup:'GET']

    static accessControl = {
		permission(perm: new EtudePerm("Bien", [ 'Liste' ]), only: ['list', 'search', 'lookup'])
		permission(perm: new EtudePerm("Bien", [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm("Bien", [ 'Modification' ]), only: [ 'edit', 'update' , "addValeur", "addManyValeur", "removeValeur"])
        permission(perm: new EtudePerm("Bien", [ 'Creation' ]), only: [ 'create', 'save'])
        permission(perm: new EtudePerm("Bien", [ 'Suppression' ]), only: [ 'delete'])
    }
	
		
    def addValeur = {
        def bien = Bien.get( params['bien.id'] )
        def valeur = Valeur.get( params['valeurId'] )
        if(bien && valeur) {
			valeur.bien = bien
            if(valeur.save()) {
                flash.message = "Valeur $valeur ajout&eacute;"
            }
            redirect(action:show,id:bien.id)
        }  else {
            flash.message = "Bien introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def addManyValeur = {
        def bien = Bien.get( params['bien.id'] )
		def listSize = new Integer(params.listSize)
		for (i in 0..(listSize-1)) {
			if (params.get("check"+i)){
				def valeur = Valeur.get(params.get("id"+i))
				try {
					valeur.bien = bien
					if (valeur.save()) {
						if (!flash.message) flash.message = "Ajout&eacute;e : <br/>"
						def msg = "${valeur}"
						flash.message += msg + "<br/>"
					}
				} catch (e){
					def msg = "ECHEC : ${valeur}"
					if (!flash.messageError) flash.messageError = ""
					flash.messageError += msg + "<br/>"
				}
			}
		}
        redirect(action:list, controller:'valeur',params:['mode':'select','addTo':'Bien','id':params.'bien.id'])
    }

    def removeValeur = {
        def valeur = Valeur.get(params.id)
        def bien = valeur.bien
        if(bien && valeur) {
			valeur.bien = null
            if(valeur.save()) {
                flash.message = "Valeur $valeur dissoci&eacute;"
            }
            redirect(action:show,id:bien.id)
        }  else {
            flash.message = "Valeur introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
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
			def parent = Bien.executeQuery("from $domainClassName where id = :id",[id:parentId])
			parent = parent.empty ? null : parent[0]
			resultats = Bien.withCriteria{
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
			resultats = Bien.findAllByLibelleIlike(k, params)
		}
		//Create XML response 
		def mime = ParamUtils.getMime(params)
		render(contentType: mime) { 
			biens() { 
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
		def resultats = Bien.findAllByLibelleIlike(k, params)
		def count = Bien.countByLibelleIlike(k)
		if (count == 1) {
			redirect(action:show, id: resultats.get(0).id)
		} else if (resultats.empty) {
			flash.message= "Aucun bien ne correspond &agrave; votre crit&egrave;re de recherche [${params.q}]"
			flash.messageType = "warn"
			redirect(action:"list", count: Bien.count())
		} else {
			def map = [:]
			resultats.each{
				def list = map.get(it.typeDeBien)
				if (null == list) {
					list = new TreeSet()
					map.put(it.typeDeBien, list)
				}
				list.add(it)
			}
			resultats = map
			flash.message= "R&eacute;sultats de la recherche de Bien [${params.q}] :"
			render(view:"list",model:[ bienList: resultats, 'count':count, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params) ])
		}
    }

	void processParams(params){
        if(!params.max)params.max = 10
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
			String ctrlName = ParamUtils.class2prop(params.addTo)
			Long parentId = null
			try {parentId = new Long(params.id)}catch(e){}
			if (parentId) {
				def parent = Bien.executeQuery("from ${params.addTo} where id = :id",[id:parentId])
				parent = parent.empty ? null : parent[0]
				resultats = Bien.createCriteria().list{
					if (parent?.operation) {
						eq('operation', parent.operation)
					}
					isNull(ctrlName)
					maxResults(params.max.toInteger())
					order(params.sort,params.order)
					firstResult(params.offset?params.offset.toInteger():0)
				}
				if (resultats.empty) {
					if (!flash.message) {
						flash.message = "Aucun bien n'est disponible."
						render "<div class='message'>${flash.message}</div>"
					} else {
						flash.message = flash.message
						redirect(controller:(params.from ?: "$ctrlName"),action:'show',id:(params.from ? params.fromId : parentId))
					}
				}
				resultCount = Bien.createCriteria().get{
					if (parent?.operation) {
						eq('operation', parent.operation)
					}
					isNull(ctrlName)
					projections { 
						count('id') 
					} 
				}
			}
		}
		resultats = resultats != null ? resultats: Bien.list(params)
		resultCount = resultCount != null ? resultCount : Bien.count()
		def map = [:]
		resultats.each{
			def list = map.get(it.typeDeBien)
			if (null == list) {
				list = new TreeSet()
				map.put(it.typeDeBien, list)
			}
			list.add(it)
		}
		resultats = map
        [ bienList: resultats, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params), count:resultCount]
    }

    def show = {
		def bien = Bien.get( params.id )
		if (!bien) {
			flash.message = "Bien introuvable."
            redirect(action:list)
		}
        def data = [ bien : bien  , listeValeurs : bien ? Valeur.findAllByBien(bien) : [] ]
		if (params.preview) {                
			render(view:'preview',model:data)
		} else {
			return data
		}
    }

    def delete = {
        def bien = Bien.get( params.id )
        if(bien) {
			def operation = bien.operation
            bien.delete()
			new Activity(user:session.user, opType:Activity.DELETE, controllerId:Activity.BIEN, entityId:new Long(params.id)).save()
            flash.message = "Bien [${bien}] supprim&eacute;."
            redirect(action:show,controller:'operation', id:operation.id)
        }
        else {
            flash.message = "Bien introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def bien = Bien.get( params.id )

        if(!bien) {
                flash.message = "Bien introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
            return [ bien : bien ]
        }
    }

    def update = {
        def bien = Bien.get( params.id )
        if(bien) {
             bien.properties = params
			bien.valeurs.each{valeur->
				def contenu = params.get("entry"+valeur.champ.id)
				valeur.contenu = contenu
				valeur.save()
			}
            if(bien.save()) {
				new Activity(user:session.user, opType:Activity.UPDATE, controllerId:Activity.BIEN, entityId:bien.id).save()
                flash.message = "Bien ${bien} mis &agrave; jour."
				redirect(action:show,controller:'operation',id:bien.operation.id)
            }
            else {
                render(view:'edit',model:[bien:bien])
            }
        }
        else {
            flash.message = "Bien introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def bien = new Bien()
        bien.properties = params
		def operation = null
		if (params.'operation.id') {operation = Operation.get(params.'operation.id')}
        return ['bien':bien, lovTypeDeBien:TypeDeBien.createCriteria().listDistinct{}, lovDossier:(operation?Dossier.findAllByOperation(operation):Dossier.list())]
    }

    def save = {
		def howMany = params.howMany ?: 1
		howMany = new Long(howMany)
		def createMany = params.createMany == 'on'
		def ok = false
		def defaultBien = new Bien()
	    defaultBien.properties = params
		Bien.withTransaction {
			howMany = createMany ? howMany : 1
			for (i in 1..howMany) {
				def bien = new Bien()
				bien.properties = params
				bien.typeDeBien.champs.each{champ->
					def contenu = params.get("entry"+champ.id)
					bien.addToValeurs(new Valeur(champ:champ, contenu:(createMany && !params.get("copy"+champ.id) ? null : contenu)))
				}
				if(bien.save()) {
					new Activity(user:session.user, opType:Activity.CREATE, controllerId:Activity.BIEN, entityId:bien.id).save()
					ok = true
				} else {
					defaultBien = bien
				}
			}
		}
		if (ok) {
			flash.highlight =[defaultBien] 
			flash.message = "Bien ${params.libelle} cr&eacute;e${howMany>1 ? ' en '+howMany+' copies' : ''}.</>"
			redirect(action:show,controller:'operation',id:params.'operation.id')
		} else {
			def operation = null
			if (params.'operation.id') {operation = Operation.get(params.'operation.id')}
			render(view:'create',model:[bien:defaultBien, lovTypeDeBien:TypeDeBien.createCriteria().listDistinct{}, lovDossier:(operation?Dossier.findAllByOperation(operation):Dossier.list())])
		}
    }

}