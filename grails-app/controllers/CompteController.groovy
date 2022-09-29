class CompteController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    static accessControl = {
		permission(perm: new EtudePerm("Compte", [ 'Liste' ]), only: [ 'list', 'synthese'])
		permission(perm: new EtudePerm("Compte", [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm("Compte", [ 'Modification' ]), only: [ 'edit', 'update', 'standardize', 'uniformiser' ])
        permission(perm: new EtudePerm("Compte", [ 'Creation' ]), only: [ 'create', 'save'])
        permission(perm: new EtudePerm("Compte", [ 'Suppression' ]), only: [ 'delete'])
        permission(perm: new EtudePerm("Compte", [ 'ModificationMasse' ]), only: [ 'xlsTemplate','upload','doUpload'])
    }
	
	def compteService
    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.remove('max')
        params.remove('offset')
        [compteInstanceList: Compte.list(params)]
    }

    def create = {
        def compteInstance = new Compte()
        compteInstance.properties = params
        return [compteInstance: compteInstance]
    }

    def save = {
        def compteInstance = new Compte(params)
        if (compteInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'compte.label', default: 'Compte'), compteInstance.id])}"
            redirect(action: "show", id: compteInstance.id)
        }
        else {
            render(view: "create", model: [compteInstance: compteInstance])
        }
    }

    def show = {
        def compteInstance = Compte.get(params.id)
        if (!compteInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'compte.label', default: 'Compte'), params.id])}"
            redirect(action: "list")
        }
        else {
            [compteInstance: compteInstance]
        }
    }

    def edit = {
        def compteInstance = Compte.get(params.id)
        if (!compteInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'compte.label', default: 'Compte'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [compteInstance: compteInstance]
        }
    }

    def update = {
        def compteInstance = Compte.get(params.id)
        if (compteInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (compteInstance.version > version) {
                    
                    compteInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'compte.label', default: 'Compte')] as Object[], "Another user has updated this Compte while you were editing")
                    render(view: "edit", model: [compteInstance: compteInstance])
                    return
                }
            }
            compteInstance.properties = params
            if (!compteInstance.hasErrors() && compteInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'compte.label', default: 'Compte'), compteInstance.id])}"
                redirect(action: "show", id: compteInstance.id)
            }
            else {
                render(view: "edit", model: [compteInstance: compteInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'compte.label', default: 'Compte'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def compteInstance = Compte.get(params.id)
        if (compteInstance) {
            try {
                compteInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'compte.label', default: 'Compte'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'compte.label', default: 'Compte'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'compte.label', default: 'Compte'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def export = {
		chain(action:'xlsTemplate', params:['export':true])
    }
    def upload = {
    }

	def xlsTemplate = {
		def template = servletContext.getResourceAsStream( "/WEB-INF/ImportPlanComptable.xls")
		def args = [response:response,
			templateInputStream:template]
		if (params.export){args.populate=true}
		compteService.xlsTemplate(args)
	}
	def doUpload = {
		def f = request.getFile('myFile')
		if(!f.empty) {
			def xlsData = [:]
			try {
				xlsData = compteService.xls2PlanComptable(f)
				def planComptableMap = xlsData.planComptable
				def injected = planComptableMap.planComptable
				def rejets = planComptableMap.rejets
				def handleRejects = {					
					def rejects = [:]
					if (planComptableMap.rejets) {rejects."Plan Comptable"=planComptableMap.rejets}
					render(view:'upload',model:[rejects:rejects,lineNumbers:xlsData.lineNumbers])
				}
				if (!rejets?.empty) {
					handleRejects()
				} else if (!planComptableMap.planComptable?.empty) {
					Compte.withTransaction{status ->
						new ArrayList(planComptableMap.planComptable).each{libelle->
							if(libelle.save()) {
								new Activity(user:session.user, opType:Activity.IMPORT, controllerId:Activity.TYPE_ECRITURE, entityId:libelle.id).save()
							} else{
								planComptableMap.planComptable.remove(libelle)
								planComptableMap.rejets << libelle
							}
						}
						rejets = planComptableMap.rejets
						if (!rejets.empty){
							status.setRollbackOnly()
							log.warn("Rollback import de planComptable [${f.originalFilename}]")
						}
					}
					if (!rejets.empty){
						handleRejects()
					} else {
						log.info("Import de planComptable reussi [${f.originalFilename}]")
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
		Compte.withTransaction{
			Compte.list().each{t->
				transform(t)
				t.save()
			}
		}
		flash.message = "Changement appliqu&eacute;s"
		redirect(action:list)
    }

}
