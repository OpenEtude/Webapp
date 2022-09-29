            
class TypeEcritureController {
    static accessControl = {
		permission(perm: new EtudePerm('TypeEcriture', [ 'Liste' ]), action: 'list')
		permission(perm: new EtudePerm('TypeEcriture', [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm('TypeEcriture', [ 'Modification' ]), only: [ 'edit', 'update', 'standardize', 'uniformiser' ])
        permission(perm: new EtudePerm('TypeEcriture', [ 'Creation' ]), only: [ 'create', 'createFrais', 'createPrix', 'save' ])
        permission(perm: new EtudePerm('TypeEcriture', [ 'Suppression' ]), only: [ 'delete'])
        permission(perm: new EtudePerm('TypeEcriture', [ 'ModificationMasse' ]), only: [ 'xlsTemplate','upload','doUpload'])
    }
	
	def typeEcritureService
	
    def index = { redirect('action':'list','params':params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST',uniformiser:'POST']

    def list = {
        if(params.max)params.remove('max')
		if(!params.sort){
			params.sort = "id"
			params.order = "desc" 
		}
        [ libelles: TypeEcriture.list( params ).groupBy{it.categorieEcriture} ]
    }

    def show = {
		def typeEcriture = TypeEcriture.get( params.id )
        if(!typeEcriture) {
            flash.message = "Libell&eacute; introuvable avec identifiant ${params.id}"
            flash.messageType = "warn"
            redirect(action:list)
        }
        [ typeEcriture : typeEcriture ]
    }

    def delete = {
        def typeEcriture = TypeEcriture.get( params.id )
        if(typeEcriture) {
            try{
				if (typeEcriture.delete()){
					def activity = new Activity(user:session.user, opType:Activity.DELETE, controllerId:Activity.TYPE_ECRITURE, entityId:typeEcriture.id)
					activity += typeEcriture
					activity.save()
					flash.message = "Libell&eacute; [${typeEcriture.libelle}] supprim&eacute;."
				}
			} catch(ex) {
				flash.message = "Le libell&eacute; ne peut &ecirc;tre supprim&eacute;."
				flash.messageType = "error"
			}
            redirect(action:list)
        } else {
            flash.message = "Libell&eacute; introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def typeEcriture = TypeEcriture.get( params.id )

        if(!typeEcriture) {
                flash.message = "Libell&eacute; introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
            return [ typeEcriture : typeEcriture ]
        }
    }

    def update = {
		def typeEcriture = TypeEcriture.get( params.id )
		if(typeEcriture) {
			 typeEcriture.properties = params
			if(typeEcriture.save()) {
								new Activity(user:session.user, opType:Activity.UPDATE, controllerId:Activity.TYPE_ECRITURE, entityId:typeEcriture.id).save()
				flash.message = "Libell&eacute; [${typeEcriture.libelle}] mis &agrave; jour."
				redirect(action:show,id:typeEcriture.id)
			}
			else {
				render(view:'edit',model:[typeEcriture:typeEcriture])
			}
		}
		else {
			flash.message = "Libell&eacute; introuvable avec identifiant ${params.id}"
			redirect(action:edit,id:params.id)
		}
    }
    
    def standardize = {
	}
	
    def uniformiser = {
        def methode = params.methode
		def transform = {}
		switch (methode){
			case 'upper' : transform = {it.libelle = it.libelle.toUpperCase()};break;
			case 'lower' : transform = {it.libelle = it.libelle.toLowerCase()};break;
			case 'capitalize' : transform = {it.libelle = ParamUtils.capitalize(it.libelle)};break;
		}
		TypeEcriture.withTransaction{
			TypeEcriture.list().each{t->
				transform(t)
				t.save()
			}
		}
		flash.message = "Changement appliqu&eacute;s"
		redirect(action:list)
    }

    def createFrais = {
        def typeEcriture = new TypeEcriture()
        typeEcriture.properties = params
        typeEcriture.categorieEcriture = categ("Frais")
        render(view:'create',model:['typeEcriture':typeEcriture])
    }

	CategorieEcriture categ(String s) {
		def o = CategorieEcriture.findByLibelle(s)
		if (!o){
			o = new CategorieEcriture(libelle: s).save(flush:true)
		}
		o
	}
	def createPrix = {
        def typeEcriture = new TypeEcriture()
        typeEcriture.properties = params
        typeEcriture.categorieEcriture = categ("Prix")
        render(view:'create',model:['typeEcriture':typeEcriture])
    }
    def createAutre = {
        def typeEcriture = new TypeEcriture()
		typeEcriture.affectable = true
        typeEcriture.properties = params
        typeEcriture.categorieEcriture = categ("Autre")
        render(view:'create',model:['typeEcriture':typeEcriture])
    }

    def save = {
        def typeEcriture = new TypeEcriture()
        typeEcriture.properties = params
        if(typeEcriture.save()) {
			new Activity(user:session.user, opType:Activity.CREATE, controllerId:Activity.TYPE_ECRITURE, entityId:typeEcriture.id).save()
            flash.message = "Libell&eacute; [${typeEcriture.libelle}] cr&eacute;e dans la base de donn&eacute;e."
            redirect(action:show,id:typeEcriture.id)
        }
        else {
            render(view:'create',model:[typeEcriture:typeEcriture])
        }
    }
    def checkLibelle = {
		def typeEcriture = params.getLong('id') ? TypeEcriture.get(params.id) : null
		def ecriture = params.getLong('ecriture.id') ? Ecriture.get(params.'ecriture.id') : null
		if (!typeEcriture){render ""}
		else {
		     def result = jsec.hasPermission(type:"EtudePerm", target:"CompteBancaire", actions:"Consultation"){
            if(typeEcriture.affectable && (!typeEcriture.credit || !(ecriture instanceof EcritureDossier))){
				            """<tr class='prop'><td valign='top' class='name'><label for='compteBancaire'>Compte Bancaire:</label></td><td valign='top' class='value  ${hasErrors(bean:ecriture,field:'typeEcriture','errors')}''>${g.select(optionKey:"id", from:CompteBancaire.list(), name:'compteBancaire.id', noSelection:['null':''], value:ecriture?.compteBancaire?.id)}</td></tr>"""
            }
			 }
			render result
		}

	}

    def export = {
		chain(action:'xlsTemplate', params:['export':true])
    }
    def upload = {
    }

	def xlsTemplate = {
		def comptes = Compte.list()
		def template = servletContext.getResourceAsStream( "/WEB-INF/ImportLibelles.xls")
		def args = [response:response,
			categorieEcriture:CategorieEcriture.list(),
			compteADebiter : comptes,
			compteACrediter : comptes,
			credit:['Cr\u00E9dit','D\u00E9bit'],
			affectable:['Affectable \u00E0 compte bancaire','Non affectable \u00E0 compte bancaire'],
			afficheDansOperation:([0,1,2,3].collect{g.message(code:"typeEcriture.afficheDansOperation.${it}")}),
			templateInputStream:template]
		if (params.export){args.populate=true}
		typeEcritureService.xlsTemplate(args)
	}
	def doUpload = {
		def f = request.getFile('myFile')
		if(!f.empty) {
			def xlsData = [:]
			try {
				xlsData = typeEcritureService.xls2Libelles(f)
				def libellesMap = xlsData.libelles
				def injected = libellesMap.libelles
				def rejets = libellesMap.rejets
				def handleRejects = {					
					def rejects = [:]
					if (libellesMap.rejets) {rejects.Libelles=libellesMap.rejets}
					render(view:'upload',model:[rejects:rejects,lineNumbers:xlsData.lineNumbers])
				}
				if (!rejets?.empty) {
					handleRejects()
				} else if (!libellesMap.libelles?.empty) {
					TypeEcriture.withTransaction{status ->
						new ArrayList(libellesMap.libelles).each{libelle->
							if(libelle.save()) {
								new Activity(user:session.user, opType:Activity.IMPORT, controllerId:Activity.TYPE_ECRITURE, entityId:libelle.id).save()
							} else{
								libellesMap.libelles.remove(libelle)
								libellesMap.rejets << libelle
							}
						}
						rejets = libellesMap.rejets
						if (!rejets.empty){
							status.setRollbackOnly()
							log.warn("Rollback import de libelles [${f.originalFilename}]")
						}
					}
					if (!rejets.empty){
						handleRejects()
					} else {
						log.info("Import de libelles reussi [${f.originalFilename}]")
						flash.message = "Fichier import&eacute; avec succ&egrave;s<br/>"
						redirect(action:'list')
					}
				} else {
					flash.message = 'Le fichier est vide'
					flash.messageType="warn"
					redirect(action:upload)
				}
			} catch (e){
				log.error("Libelle import error :${f.originalFilename}", e)
				flash.message = "Echec lors de l'import du document ${f.originalFilename}, veuillez v&eacute;rifier le format du fichier."
				flash.messageType="warn"
				redirect(action:upload)
			}
		} else {
			flash.message = 'Le fichier est vide'
			flash.messageType="warn"
			redirect(action:upload)
		}
	}

}
