import org.hibernate.FetchMode as FM

class OperationController {
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST', search:'GET', lookup:'GET']

    static accessControl = {
		permission(perm: new EtudePerm("Operation", [ 'Liste' ]), only: ['list', 'search', 'lookup'])
		permission(perm: new EtudePerm("Operation", [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm("Operation", [ 'Modification' ]), only: [ 'edit', 'update' , "addBien", "addManyBien", "removeBien" , "addDossier", "addManyDossier", "removeDossier"])
        permission(perm: new EtudePerm("Operation", [ 'Creation' ]), only: [ 'create', 'save'])
        permission(perm: new EtudePerm("Operation", [ 'Suppression' ]), only: [ 'delete'])
    }
	
		
    def addBien = {
        def operation = Operation.get( params['operation.id'] )
        def bien = Bien.get( params['bienId'] )
        if(operation && bien) {
			bien.operation = operation
            if(bien.save()) {
				new Activity(user:session.user, opType:Activity.ATTACH, controllerId:Activity.BIEN, entityId:bien.id).save()
				flash.highlight = [bien]
                flash.message = "Bien $bien ajout&eacute;"
            }
            redirect(action:show,id:operation.id)
        }  else {
            flash.message = "Operation introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def addManyBien = {
        def operation = Operation.get( params['operation.id'] )
		def listSize = new Integer(params.listSize)
		for (i in 0..(listSize-1)) {
			if (params.get("check"+i)){
				def bien = Bien.get(params.get("id"+i))
				try {
					bien.operation = operation
					if (bien.save()) {
						new Activity(user:session.user, opType:Activity.ATTACH, controllerId:Activity.BIEN, entityId:bien.id).save()
						flash.highlight = flash.highlight ?: []
						flash.highlight << bien
						if (!flash.message) flash.message = "Ajout&eacute;e : <br/>"
						def msg = "${bien}"
						flash.message += msg + "<br/>"
					}
				} catch (e){
					def msg = "ECHEC : ${bien}"
					if (!flash.messageError) flash.messageError = ""
					flash.messageError += msg + "<br/>"
				}
			}
		}
        redirect(action:list, controller:'bien',params:['mode':'select','addTo':'Operation','id':params.'operation.id'])
    }

    def removeBien = {
        def bien = Bien.get(params.id)
        def operation = bien.operation
        if(operation && bien) {
			bien.operation = null
            if(bien.save()) {
				new Activity(user:session.user, opType:Activity.DETACH, controllerId:Activity.BIEN, entityId:bien.id).save()
                flash.message = "Bien $bien dissoci&eacute;"
            }
            redirect(action:show,id:operation.id)
        }  else {
            flash.message = "Bien introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

	
		
    def addDossier = {
        def operation = Operation.get( params['operation.id'] )
        def dossier = Dossier.get( params['dossierId'] )
        if(operation && dossier) {
			dossier.operation = operation
            if(dossier.save()) {
				flash.highlight = [dossier]
				new Activity(user:session.user, opType:Activity.ATTACH, controllerId:Activity.DOSSIER, entityId:dossier.id).save()
                flash.message = "Dossier $dossier ajout&eacute;"
            }
            redirect(action:show,id:operation.id)
        }  else {
            flash.message = "Operation introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def addManyDossier = {
        def operation = Operation.get( params['operation.id'] )
		def listSize = new Integer(params.listSize)
		for (i in 0..(listSize-1)) {
			if (params.get("check"+i)){
				def dossier = Dossier.get(params.get("id"+i))
				try {
					dossier.operation = operation
					if (dossier.save()) {
						new Activity(user:session.user, opType:Activity.ATTACH, controllerId:Activity.DOSSIER, entityId:dossier.id).save()
						flash.highlight = flash.highlight ?: []
						flash.highlight << dossier
						if (!flash.message) flash.message = "Ajout&eacute;e : <br/>"
						def msg = "${dossier}"
						flash.message += msg + "<br/>"
					}
				} catch (e){
					def msg = "ECHEC : ${dossier}"
					if (!flash.messageError) flash.messageError = ""
					flash.messageError += msg + "<br/>"
				}
			}
		}
        redirect(action:list, controller:'dossier',params:['mode':'select','addTo':'Operation','id':params.'operation.id'])
    }

    def removeDossier = {
        def dossier = Dossier.get(params.id)
        def operation = dossier.operation
        if(operation && dossier) {
			Dossier.withTransaction {
				Bien.findAllByDossierAndOperation(dossier,operation).each{it.dossier = null;it.save()}
				dossier.operation = null
	            if(dossier.save()) {
					new Activity(user:session.user, opType:Activity.DETACH, controllerId:Activity.DOSSIER, entityId:dossier.id).save()
	                flash.message = "Dossier $dossier dissoci&eacute;"
	            }
			}
            redirect(action:show,id:operation.id)
        }  else {
            flash.message = "Dossier introuvable avec identifiant ${params.id}"
            redirect(uri:"/")
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
			def parent = Operation.executeQuery("from $domainClassName where id = :id",[id:parentId])
			parent = parent.empty ? null : parent[0]
			resultats = Operation.withCriteria{
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
			resultats = Operation.findAllByLibelleIlike(k, params)
		}
		//Create XML response 
		def mime = ParamUtils.getMime(params)
		render(contentType: mime) { 
			operations() { 
				resultats.each { 
					d -> result(){ 
						name(d.libelle) 
						id(d.id) 
						code(d.id) 
						date(etude.relativeDate(date:d.dateCreation, plain:true))
						icon('operation') 
					}
				} 
			} 
		} 
	} 
    def search = {
		processParams(params)
		def k = ParamUtils.keyword(params.q)
		def resultats = Operation.findAllByLibelleIlike(k, params)
		def count = Operation.countByLibelleIlike(k)
		if (count == 1) {
			redirect(action:show, id: resultats.get(0).id)
		} else if (resultats.empty) {
			flash.message= "Aucun operation ne correspond &agrave; votre crit&egrave;re de recherche [${params.q}]"
			flash.messageType = "warn"
			redirect(action:"list", count: Operation.count())
		} else {
			flash.message= "R&eacute;sultats de la recherche de Operation [${params.q}] :"
			render(view:"list",model:[ operationList: resultats, 'count':count, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params) ])
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
				def parent = Operation.executeQuery("from ${params.addTo} where id = :id",[id:parentId])
				parent = parent.empty ? null : parent[0]
				resultats = Operation.withCriteria{
					isNull(ParamUtils.class2prop(params.addTo))
					maxResults(params.max.toInteger())
					order(params.sort,params.order)
				}
			}
			resultCount = Operation.createCriteria().get{
				isNull(ParamUtils.class2prop(params.addTo))
				projections { 
					count('id') 
				} 
			}
		}
		resultats = resultats != null ? resultats: Operation.list( params )
		resultCount = resultCount != null ? resultCount : Operation.count()
        [ operationList: resultats, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params), count:resultCount]
    }

    def show = {
		def operation = Operation.get(params.id)
		if (!operation) {
			flash.message = "Operation introuvable."
            redirect(action:list)
		}
		def listeBiens = Bien.createCriteria().listDistinct{eq("operation",operation)
		order('libelle','asc')
		order('dossier','desc')
		}
		def listeDossiers = Dossier.createCriteria().listDistinct{
			eq('operation', operation)
			isEmpty('biens')
			order('dateCreation','desc')
			//fetchMode("ecritures", FM.EAGER)
		}
		def dossiersAffectes = new HashSet(listeBiens.collect{it.dossier})
		dossiersAffectes.remove(null)
		def libellesAffiches = TypeEcriture.withCriteria{
			'in'('afficheDansOperation', [TypeEcriture.AFF_PAGE_OP, TypeEcriture.AFF_PAGE_OP_XLS])
		}
		def ecrituresOperation = libellesAffiches.empty ? [:] : EcritureDossier.withCriteria{
			and {
				if (!dossiersAffectes.empty){'in'('dossier', dossiersAffectes)}
				isNotNull('typeEcriture')
				'in'('typeEcriture',libellesAffiches)
			}
			if (!SecUtils.maitre()) {
				or {
					eq('marked',false)
					isNull('marked')
				}
			}
		}.groupBy{it.dossier}
		def ecritures = EcritureDossier.withCriteria{
			and {
				if (!dossiersAffectes.empty){'in'('dossier', dossiersAffectes)}
				isNotNull('montant')
				typeEcriture {
					eq('categorieEcriture', CategorieEcriture.findByLibelle("Prix"))
				}
			}
			if (!SecUtils.maitre()) {
				or {
					eq('marked',false)
					isNull('marked')
				}
			}
		}.groupBy{it.dossier}
		def dossierSoldesPrix = [:]
		dossiersAffectes.each{dossierAffecte->
			def soldePrix = 0.0f
			/*dossier.ecritures.findAll{
				it.montant && it.typeEcriture.categorieEcriture.id==2
			}*/
			ecritures.get(dossierAffecte).each{ecr-> 
				soldePrix = soldePrix + (ecr.typeEcriture.credit ? (ecr.etat.id == 2 ? 1f : 0f) : -1f) * ecr.montant
			}
			dossierSoldesPrix.put(dossierAffecte, soldePrix)
		}
        def data = [ operation : operation  , listeBiens : listeBiens  , listeDossiers : listeDossiers, ecrituresOperation:ecrituresOperation,dossierSoldesPrix:dossierSoldesPrix]
		if (params.preview) {                
			render(view:'preview',model:data)
		} else {
			return 	data
		}
    }

    def delete = {
        def operation = Operation.get( params.id )
        if(operation) {
            operation.delete()
            flash.message = g.message(code:'deleted')
            redirect(action:list)
        }
        else {
            flash.message = "Operation introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def operation = Operation.get( params.id )

        if(!operation) {
                flash.message = "Operation introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
            return [ operation : operation ]
        }
    }

    def update = {
        def operation = Operation.get( params.id )
        if(operation) {
             operation.properties = params
            if(operation.save()) {
				new Activity(user:session.user, opType:Activity.UPDATE, controllerId:Activity.OPERATION, entityId:operation.id).save()
                flash.message = "Operation ${operation} mis &agrave; jour."
                redirect(action:show,id:operation.id)
            }
            else {
                render(view:'edit',model:[operation:operation])
            }
        }
        else {
            flash.message = "Operation introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def operation = new Operation()
        operation.properties = params
        return ['operation':operation]
    }

    def save = {
        def operation = new Operation()
        operation.properties = params
        if(operation.save()) {
			new Activity(user:session.user, opType:Activity.CREATE, controllerId:Activity.OPERATION, entityId:operation.id).save()
            flash.message = "Operation ${operation} cr&eacute;e dans la base."
            redirect(action:show,id:operation.id)
        }
        else {
            render(view:'create',model:[operation:operation])
        }
    }

}
