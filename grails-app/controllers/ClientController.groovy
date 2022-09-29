


class ClientController {
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST', search:'GET', lookup:'GET']

    static accessControl = {
		permission(perm: new EtudePerm("Client", [ 'Liste' ]), only: ['list', 'search', 'lookup'])
		permission(perm: new EtudePerm("Client", [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm("Client", [ 'Modification' ]), only: [ 'edit', 'update' , "addOperation", "addManyOperation", "removeOperation"])
        permission(perm: new EtudePerm("Client", [ 'Creation' ]), only: [ 'create', 'save'])
        permission(perm: new EtudePerm("Client", [ 'Suppression' ]), only: [ 'delete'])
    }
	
		
    def addOperation = {
        def client = Client.get( params['client.id'] )
        def operation = Operation.get( params['operationId'] )
        if(client && operation) {
			operation.client = client
            if(operation.save()) {
                flash.message = "Operation $operation ajout&eacute;"
            }
            redirect(action:show,id:client.id)
        }  else {
            flash.message = "Client introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def addManyOperation = {
        def client = Client.get( params['client.id'] )
		def listSize = new Integer(params.listSize)
		for (i in 0..(listSize-1)) {
			if (params.get("check"+i)){
				def operation = Operation.get(params.get("id"+i))
				try {
					operation.client = client
					if (operation.save()) {
						if (!flash.message) flash.message = "Ajout&eacute;e : <br/>"
						def msg = "${operation}"
						flash.message += msg + "<br/>"
					}
				} catch (e){
					def msg = "ECHEC : ${operation}"
					if (!flash.messageError) flash.messageError = ""
					flash.messageError += msg + "<br/>"
				}
			}
		}
        redirect(action:list, controller:'operation',params:['mode':'select','addTo':'Client','id':params.'client.id'])
    }

    def removeOperation = {
        def operation = Operation.get(params.id)
        def client = operation.client
        if(client && operation) {
			operation.client = null
            if(operation.save()) {
                flash.message = "Operation $operation dissoci&eacute;"
            }
            redirect(action:show,id:client.id)
        }  else {
            flash.message = "Operation introuvable avec identifiant ${params.id}"
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
			def parent = Client.executeQuery("from $domainClassName where id = :id",[id:parentId])
			parent = parent.empty ? null : parent[0]
			resultats = Client.withCriteria{
				and {
					or {
						ilike('nom',k)
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
			resultats = Client.findAllByNomIlike(k, params)
		}
		//Create XML response 
		def mime = ParamUtils.getMime(params)
		render(contentType: mime) { 
			clients() { 
				resultats.each { 
					d -> result(){ 
						name(d.nom) 
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
		def resultats = Client.findAllByNomIlike(k, params)
		def count = Client.countByNomIlike(k)
		if (count == 1) {
			redirect(action:show, id: resultats.get(0).id)
		} else if (resultats.empty) {
			flash.message= "Aucun client ne correspond &agrave; votre crit&egrave;re de recherche [${params.q}]"
			flash.messageType = "warn"
			redirect(action:"list", count: Client.count())
		} else {
			flash.message= "R&eacute;sultats de la recherche de Client [${params.q}] :"
			render(view:"list",model:[ clientList: resultats, 'count':count, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params) ])
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
				def parent = Client.executeQuery("from ${params.addTo} where id = :id",[id:parentId])
				parent = parent.empty ? null : parent[0]
				resultats = Client.withCriteria{
					isNull(ParamUtils.class2prop(params.addTo))
					maxResults(params.max.toInteger())
					order(params.sort,params.order)
				}
			}
			resultCount = Client.createCriteria().get{
				isNull(ParamUtils.class2prop(params.addTo))
				projections { 
					count('id') 
				} 
			}
		}
		resultats = resultats != null ? resultats: Client.list( params )
		resultCount = resultCount != null ? resultCount : Client.count()
        [ clientList: resultats, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params), count:resultCount]
    }

    def show = {
		def client = Client.get( params.id )
		if (!client) {
			flash.message = "Client introuvable."
            redirect(action:list)
		}
        [ client : client  , listeOperations : Operation.findAllByClient(client) ]
    }

    def delete = {
        def client = Client.get( params.id )
        if(client) {
            client.delete()
            flash.message = g.message(code:'deleted')
            redirect(action:list)
        }
        else {
            flash.message = "Client introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def client = Client.get( params.id )

        if(!client) {
                flash.message = "Client introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
            return [ client : client ]
        }
    }

    def update = {
        def client = Client.get( params.id )
        if(client) {
             client.properties = params
            if(client.save()) {
                flash.message = "Client ${client} mis &agrave; jour."
                redirect(action:show,id:client.id)
            }
            else {
                render(view:'edit',model:[client:client])
            }
        }
        else {
            flash.message = "Client introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def client = new Client()
        client.properties = params
        return ['client':client]
    }

    def save = {
        def client = new Client()
        client.properties = params
        if(client.save()) {
            flash.message = "Client ${client} cr&eacute;e dans la base."
            redirect(action:show,id:client.id)
        }
        else {
            render(view:'create',model:[client:client])
        }
    }

}