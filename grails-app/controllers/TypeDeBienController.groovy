


class TypeDeBienController {
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST', search:'GET', lookup:'GET']

    static accessControl = {
		permission(perm: new EtudePerm("TypeDeBien", [ 'Liste' ]), only: ['list', 'search', 'lookup'])
		permission(perm: new EtudePerm("TypeDeBien", [ 'Consultation' ]), only: ['show','listeChamps'])
        permission(perm: new EtudePerm("TypeDeBien", [ 'Modification' ]), only: [ 'edit', 'update' , "addChamp", "addManyChamp", "removeChamp"])
        permission(perm: new EtudePerm("TypeDeBien", [ 'Creation' ]), only: [ 'create', 'save'])
        permission(perm: new EtudePerm("TypeDeBien", [ 'Suppression' ]), only: [ 'delete'])
    }
	
		
    def addChamp = {
        def typeDeBien = TypeDeBien.get( params['typeDeBien.id'] )
        def champ = Champ.get( params['champId'] )
        if(typeDeBien && champ) {
			champ.typeDeBien = typeDeBien
            if(champ.save()) {
                flash.message = "Champ $champ ajout&eacute;"
            }
            redirect(action:show,id:typeDeBien.id)
        }  else {
            flash.message = "TypeDeBien introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def addManyChamp = {
        def typeDeBien = TypeDeBien.get( params['typeDeBien.id'] )
		def listSize = new Integer(params.listSize)
		for (i in 0..(listSize-1)) {
			if (params.get("check"+i)){
				def champ = Champ.get(params.get("id"+i))
				try {
					champ.typeDeBien = typeDeBien
					if (champ.save()) {
						if (!flash.message) flash.message = "Ajout&eacute;e : <br/>"
						def msg = "${champ}"
						flash.message += msg + "<br/>"
					}
				} catch (e){
					def msg = "ECHEC : ${champ}"
					if (!flash.messageError) flash.messageError = ""
					flash.messageError += msg + "<br/>"
				}
			}
		}
        redirect(action:list, controller:'champ',params:['mode':'select','addTo':'TypeDeBien','id':params.'typeDeBien.id'])
    }

    def removeChamp = {
        def champ = Champ.get(params.id)
        def typeDeBien = champ.typeDeBien
        if(typeDeBien && champ) {
			champ.typeDeBien = null
            if(champ.save()) {
                flash.message = "Champ $champ dissoci&eacute;"
            }
            redirect(action:show,id:typeDeBien.id)
        }  else {
            flash.message = "Champ introuvable avec identifiant ${params.id}"
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
			def parent = TypeDeBien.executeQuery("from $domainClassName where id = :id",[id:parentId])
			parent = parent.empty ? null : parent[0]
			resultats = TypeDeBien.withCriteria{
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
			resultats = TypeDeBien.findAllByLibelleIlike(k, params)
		}
		//Create XML response 
		def mime = ParamUtils.getMime(params)
		render(contentType: mime) { 
			typeDeBiens() { 
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
		def resultats = TypeDeBien.findAllByLibelleIlike(k, params)
		def count = TypeDeBien.countByLibelleIlike(k)
		if (count == 1) {
			redirect(action:show, id: resultats.get(0).id)
		} else if (resultats.empty) {
			flash.message= "Aucun typeDeBien ne correspond &agrave; votre crit&egrave;re de recherche [${params.q}]"
			flash.messageType = "warn"
			redirect(action:"list", count: TypeDeBien.count())
		} else {
			flash.message= "R&eacute;sultats de la recherche de TypeDeBien [${params.q}] :"
			render(view:"list",model:[ typeDeBienList: resultats, 'count':count, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params) ])
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
				def parent = TypeDeBien.executeQuery("from ${params.addTo} where id = :id",[id:parentId])
				parent = parent.empty ? null : parent[0]
				resultats = TypeDeBien.withCriteria{
					isNull(ParamUtils.class2prop(params.addTo))
					maxResults(params.max.toInteger())
					order(params.sort,params.order)
				}
			}
			resultCount = TypeDeBien.createCriteria().get{
				isNull(ParamUtils.class2prop(params.addTo))
				projections { 
					count('id') 
				} 
			}
		}
		resultats = resultats != null ? resultats: TypeDeBien.list( params )
		resultCount = resultCount != null ? resultCount : TypeDeBien.count()
        [ typeDeBienList: resultats, paginateParams:ParamUtils.paginate(params), sortParams:ParamUtils.sort(params), count:resultCount]
    }

    def show = {
		def typeDeBien = TypeDeBien.get( params.id )
		if (!typeDeBien) {
			flash.message = "Type De Bien introuvable."
            redirect(action:list)
		}
        [ typeDeBien : typeDeBien  , listeChamps : typeDeBien.champs ]
    }

    def delete = {
        def typeDeBien = TypeDeBien.get( params.id )
        if(typeDeBien) {
            typeDeBien.delete()
            flash.message = g.message(code:'deleted')
            redirect(action:list)
        }
        else {
            flash.message = "Type De Bien introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def typeDeBien = TypeDeBien.get( params.id )

        if(!typeDeBien) {
                flash.message = "Type De Bien introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
            return [ typeDeBien : typeDeBien ]
        }
    }

    def update = {
        def typeDeBien = TypeDeBien.get( params.id )
        if(typeDeBien) {
             typeDeBien.properties = params
            if(typeDeBien.save()) {
                flash.message = "Type De Bien ${typeDeBien} mis &agrave; jour."
                redirect(action:show,id:typeDeBien.id)
            }
            else {
                render(view:'edit',model:[typeDeBien:typeDeBien])
            }
        }
        else {
            flash.message = "Type De Bien introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def typeDeBien = new TypeDeBien()
        typeDeBien.properties = params
        return ['typeDeBien':typeDeBien]
    }

    def save = {
        def typeDeBien = new TypeDeBien()
        typeDeBien.properties = params
        if(typeDeBien.save()) {
            flash.message = "Type De Bien ${typeDeBien} cr&eacute;e dans la base."
            redirect(action:show,id:typeDeBien.id)
        }
        else {
            render(view:'create',model:[typeDeBien:typeDeBien])
        }
    }
	def listeChamps = {
		Long id = null;try{id = new Long(params.id)}catch(ex){}
		def typeDeBien = id ? TypeDeBien.get(id) :null
		def result = ""
		if (typeDeBien) {
		typeDeBien.champs.each{champ->
		result+="${etude.edit(label:champ.libelle, name:'entry'+champ.id, dbId:champ.id, type:champ.settingType, desc:champ.description?.encodeAsJavaScript(), value:champ.defaultValue, defValue:champ.defaultValue,hideable:'false',style:'text-align:left')}"
		}
		}

		render(text:result,contentType:"text/html",encoding:"UTF-8")
	}


}