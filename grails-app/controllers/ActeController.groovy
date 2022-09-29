class ActeController {

    static accessControl = {
		permission(perm: new EtudePerm('Acte', [ 'Liste' ]), only: ['list','listIphone'])
		permission(perm: new EtudePerm('Acte', [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm('Acte', [ 'Modification' ]), only: [ 'edit', 'update'])
        permission(perm: new EtudePerm('Acte', [ 'Creation' ]), only: [ 'create', 'save'])
        permission(perm: new EtudePerm('Acte', [ 'Suppression' ]), only: [ 'delete'])
    }
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST', upload:'GET', doUpload:'POST']

	def lookup = { 
		processParams(params)
        params.max = 10
		def k = ParamUtils.keyword(params.query)
		def num = null
		try{num=new Integer(params.query)}catch(e){}
		def resultats = Acte.withCriteria {
			if (num){
				eq("numRepertoire", num)
			} else {
				ilike("libelle", k)
			}
			maxResults(params.max.toInteger())
			order(params.sort,params.order)
			firstResult(params.offset?params.offset.toInteger():0)
		}
		//Create XML response 
		def mime = ParamUtils.getMime(params)
		render(contentType: mime) { 
			actes() { 
				resultats.each { 
					a -> result(){ 
						name(a.libelle) 
						id(a.id) 
						code(a.numRepertoire) 
						date(etude.relativeDate(date:a.dateCreation, plain:true)) 
						icon('acte')
					}
				} 
			} 
		} 
	} 

    def search = {
		processParams(params)
        params.max = 14
		def k = params.q
		def num = null
		try{num=new Integer(k)}catch(e){k=ParamUtils.keyword(k)}
		def resultats = Acte.withCriteria {
			if (num){
				eq("numRepertoire", num)
			} else {
				ilike("libelle", k)
			}
			maxResults(params.max.toInteger())
			order(params.sort,params.order)
			firstResult(params.offset?params.offset.toInteger():0)
		}
		def count = Acte.createCriteria().get {
			if (num){
				eq("numRepertoire", num)
			} else {
				ilike("libelle", k)
			}
			projections { 
				countDistinct('id') 
			} 
		}
		if (count == 1) {
			redirect(action:show, id: resultats.get(0).id)
		} else if (resultats.empty) {
			flash.message= "Aucun acte ne correspond &agrave; votre crit&egrave;re de recherche [${params.q}]"
			flash.messageType = "warn"
			redirect(action:"list", count: Acte.count())
		} else {
			flash.message= "R&eacute;sultats de la recherche [${params.q}] :"
			render(view:"list",model:[ acteList: resultats, 'count':count ])
		}
    }

	void processParams(params){
        if(!params.max)params.max = 14
		if(!params.sort){
			params.sort = "dateCreation"
			params.order = "desc" 
		}
	}

    def list = {
		processParams(params)
        [ acteList: Acte.list( params ), count: Acte.count() ]
    }
	
    def upload = {
		def acte = Acte.get( params.id )
        return ['acte' : acte]
    }
    def ocr = {
		def acte = Acte.get( params.id )
        return ['acte' : acte]
    }

    def doSaveOcr = {
		def acte = Acte.get( params.id )
		def text = params.txt
        render(text)
    }

    def show = {
		def acte = Acte.get( params.id )
		if (!acte) {
            flash.message = "L'acte s&eacute;lectionn&eacute; (ID ${params.id}) n'existe plus."
			flash.messageType='warn'
            redirect(action:list)
		} else {
			def listEcritures = SecUtils.maitre() ? EcritureDossier.findAllByActe(acte) : EcritureDossier.withCriteria{
				eq('acte',acte)
				or {
					eq('marked',false)
					isNull('marked')
				}
			}
			def data = ['acte': acte, listEcritures: listEcritures]
			if (params.preview) {                
				render(view:'preview',model:data)
			} else {
				return 	data
			}
		}
    }

    def delete = {
        def acte = Acte.get( params.id )
        if(acte) {
			def dossier = acte.dossier
            acte.delete()
			new Activity(user:session.user, opType:Activity.DELETE, controllerId:Activity.ACTE, entityId:acte.id,msg:"Dossier : "+acte.dossier+" ["+acte+"]").save()
            flash.message = "Acte ${params.id} supprim&eacute;."
			redirect(controller:'dossier',action:show, id:dossier.id)
        }
        else {
            flash.message = "Acte introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }
	
    def edit = {
        def acte0 = flash.acte ?: Acte.get( params.long('id') )
		if(!acte0.isAttached()) {
			acte0.attach()
		}
        if(!acte0) {
			flash.message = "Acte introuvable avec identifiant ${params.id}"
			redirect(action:list)
        } else {
			def listEcritures = SecUtils.maitre() ? EcritureDossier.findAllByActe(acte0) : EcritureDossier.withCriteria{
				eq('acte',acte0)
				or {
					eq('marked',false)
					isNull('marked')
				}
			}
			return [acte: acte0, listEcritures: listEcritures]
        }
    }

    def update = {
        def acte = flash.acte ?: Acte.get( Long.parseLong(params.id) )
        if(acte) {
             acte.properties = params
            if(acte.save()) {
                flash.message = "Acte ${params.id} mis &agrave; jour."
				new Activity(user:session.user, opType:Activity.UPDATE, controllerId:Activity.ACTE, entityId:acte.id).save()
                redirect(action:show,id:acte.id)
            } else {
				flash.errors = acte.errors 
				flash.acte = acte
				redirect(action:'edit')
            }
        }
        else {
            flash.message = "Acte introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def acte = flash.acte ?: new Acte()
        if (!flash.errors){
			acte.properties = params
		}
		def lovDossier = Dossier.list(sort:'dateCreation', order:'desc')
        return ['acte':acte, 'lovDossier':lovDossier]
    }

    def save = {
        def acte = new Acte(params)
        if(acte.save()) {
			new Activity(user:session.user, opType:Activity.CREATE, controllerId:Activity.ACTE, entityId:acte.id).save()
            flash.message = "Acte ${acte.id} cr&eacute;e dans la base de donn&eacute;e."
            redirect(action:show,id:acte.id)
        }
        else {
			flash.errors = acte.errors 
			flash.acte = acte
			def args = [action:'create']
			if (acte.dossier){
				args.params = ['dossier.id':acte.dossier.id]
			}
            redirect(args)
        }
    }

}
