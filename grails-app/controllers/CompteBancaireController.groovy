            
class CompteBancaireController {
    def index = { redirect(action:synthese,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    static accessControl = {
		permission(perm: new EtudePerm("CompteBancaire", [ 'Liste' ]), only: [ 'list', 'synthese'])
		permission(perm: new EtudePerm("CompteBancaire", [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm("CompteBancaire", [ 'Modification' ]), only: [ 'edit', 'update'])
        permission(perm: new EtudePerm("CompteBancaire", [ 'Creation' ]), only: [ 'create', 'save'])
        permission(perm: new EtudePerm("CompteBancaire", [ 'Suppression' ]), only: [ 'delete'])
    }

	def fileDate(){new java.text.SimpleDateFormat('ddMMMMyyyy').format(new Date())}
    def list = {
        redirect(action:'synthese')
    }
    def synthese = {
		def syn = CompteBancaire.executeQuery("""
		select new map(cb as cb, sum((case e.typeEcriture.credit when false then -1 else 1 end) * e.montant) as solde) 
		from CompteBancaire cb left join cb.ecritures as e
		where ((e.typeEcriture.credit = false) or (e.typeEcriture.credit = true and e.etat.id = 2)) ${SecUtils.maitreCrit('e')}
		group by cb 
		order by sum((case e.typeEcriture.credit when false then -1 else 1 end) * e.montant) desc
		""")
		def encours = CompteBancaire.executeQuery("""
		select new map(cb as cb, sum((case e.typeEcriture.credit when false then 1 else 0 end) * e.montant) as encoursDebit, sum((case e.typeEcriture.credit when false then 0 else 1 end) * e.montant) as encoursCredit, count(e) as pending) 
		from CompteBancaire cb left join cb.ecritures as e
		where (e.etat.id = 1) ${SecUtils.maitreCrit('e')}
		group by cb 
		""")
		syn = syn.collect{
				it.solde = (it.solde ?: new BigDecimal(0))
				it
		}
		encours = encours.collect{
				it.encoursDebit = (it.encoursDebit ?: new BigDecimal(0))
				it
		}
		def comptesSoldes = syn.collect{it.cb}
		def comptesEncours = encours.collect{it.cb}
		CompteBancaire.list().each{
		if (!comptesSoldes.contains(it)) {
			syn.add(['cb':it,'solde':new BigDecimal(0)])
		}
		if (!comptesEncours.contains(it)) {
			encours.add(['cb':it,'encoursCredit':new BigDecimal(0),'encoursDebit':new BigDecimal(0),'pending':0])
		}
		}
		encours.each{enc -> def found = syn.find{it.cb==enc.cb};found?.encoursCredit = enc.encoursCredit;found?.encoursDebit = enc.encoursDebit;found.pending = enc.pending}
        if (params.format == null || params.format=='html') {
	        [ 'syn' : syn ]
		} 	else if (params.format=='xls')  { 
			def header = [
				cb : message(code:"xls.header.compteBancaire"),
			    solde : message(code:"xls.header.solde"),
			    encoursDebit : message(code:"xls.header.encoursDebit"),
			    encoursCredit : message(code:"xls.header.encoursCredit"),
			]
			def total = [cb:"_Total", solde:syn.solde.sum(),encoursDebit:syn.encoursDebit.sum(),encoursCredit:syn.encoursCredit.sum()]
			ExcelWriter.writeSheets("Situation_Comptes_Bancaires_${fileDate()}", response, [header],[syn+total],["Comptes bancaires"])
		}
    }
    def detail = {
		if (!params.id){flash.message="Il faut s&eacute;lectionner un compte bancaire";redirect(action:'synthese')}
        if(!params.max)params.max = 13
		if(!params.sort){
			params.sort = "dateValeur"
			params.order = "desc" 
		}
		long SOLDE_INITIAL = 61l //sorry
		def te = TypeEcriture.get(SOLDE_INITIAL)
		def cb  = CompteBancaire.get( params.id )
		boolean hasSoldeInitial = Ecriture.findByCompteBancaireAndTypeEcriture(cb,te)
		def montant = null
		try {montant = new BigDecimal(params.get("q"))} catch (ex){}
		def pieceComptable = params.get("q") ? ParamUtils.keyword(params.get("q")) : null
		def commentaire = params.get("q")  ? ParamUtils.keyword(params.get("q")) : null
		def result = Ecriture.withCriteria {
			if (!SecUtils.maitre()) {
				or {
					eq('marked',false)
					isNull('marked')
				}
			}
			if (commentaire != null) {
				or {
					if (montant != null) between('montant', montant, (montant + new BigDecimal(1)) as BigDecimal)
					ilike('pieceComptable', pieceComptable)
					ilike('commentaire', commentaire)
				}
			}
			eq("compteBancaire", cb)
			maxResults(params.max.toInteger())
			order(params.sort,params.order)
			firstResult(params.offset?params.offset.toInteger():0)
		}
		def count = Ecriture.createCriteria().get {
			if (!SecUtils.maitre()) {
				or {
					eq('marked',false)
					isNull('marked')
				}
			}
			if (commentaire != null) {
				or {
					if (montant != null) between('montant', montant, (montant + new BigDecimal(1)) as BigDecimal)
					ilike('pieceComptable', pieceComptable)
					ilike('commentaire', commentaire)
				}
			}
			eq("compteBancaire", cb)
			projections { 
				countDistinct('id') 
			} 
		}
		def map = result.groupBy{it instanceof EcritureDossier}
		map = (map.get(true)?.groupBy{it.dossier} ?: [:]) + (map.get(false) ? ["Aucun dossier":(map.get(false))] : [:])
		[ ecritureDossierMap: map, count: count, compteBancaire : cb, paginateParams:ParamUtils.paginate(params,['q','id']), sortParams:ParamUtils.sort(params, ['q','id']), listSize:result.size() , hasSoldeInitial:hasSoldeInitial]
    }

    def show = {
		long SOLDE_INITIAL = 61l //sorry
		def cb = CompteBancaire.get(params.id)
		def te = TypeEcriture.get(SOLDE_INITIAL)
		boolean hasSoldeInitial = Ecriture.findByCompteBancaireAndTypeEcriture(cb,te)
		[compteBancaire: cb, hasSoldeInitial:hasSoldeInitial]
    }

    def delete = {
        def compteBancaire = CompteBancaire.get( params.id )
        if(compteBancaire) {
            if (compteBancaire.ecritures.empty) {
	            compteBancaire.delete()
	            flash.message = g.message(code:'deleted')
				new Activity(user:session.user, opType:Activity.DELETE, controllerId:Activity.COMPTE_BANCAIRE, entityId:compteBancaire.id, msg:"Compte Bancaire : "+compteBancaire).save()
				redirect(action:synthese)
			} else {
				flash.messageType = 'warn'
	            flash.message = "Le compte bancaire ne peut pas &ecirc;tre supprim&eacute; tant qu'il contient des &eacute;critures."
	            redirect(action:detail, id:compteBancaire.id)
			}
        }
        else {
            flash.message = "Compte Bancaire introuvable avec identifiant ${params.id}"
            redirect(action:synthese)
        }
    }

    def edit = {
        def compteBancaire = CompteBancaire.get( params.id )

        if(!compteBancaire) {
                flash.message = "Compte Bancaire introuvable avec identifiant ${params.id}"
                redirect(action:'synthese')
        }
        else {
            return [ compteBancaire : compteBancaire ]
        }
    }

    def update = {
        def compteBancaire = CompteBancaire.get( params.id )
        if(compteBancaire) {
             compteBancaire.properties = params
            if(compteBancaire.save()) {
                flash.message = "Compte Bancaire ${compteBancaire} mis &agrave; jour."
				new Activity(user:session.user, opType:Activity.UPDATE, controllerId:Activity.COMPTE_BANCAIRE, entityId:compteBancaire.id).save()
                redirect(action:show,id:compteBancaire.id)
            }
            else {
                render(view:'edit',model:[compteBancaire:compteBancaire])
            }
        }
        else {
            flash.message = "Compte Bancaire introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def compteBancaire = new CompteBancaire()
        compteBancaire.properties = params
        return ['compteBancaire':compteBancaire]
    }

    def save = {
        def compteBancaire = new CompteBancaire()
        compteBancaire.properties = params
        if(compteBancaire.save()) {
            flash.message = "Compte Bancaire ${compteBancaire} cr&eacute;e dans la base."
			try {
				Long soldeInitial = params.soldeInitial ? new Long(params.soldeInitial) : null
				if (soldeInitial){
					compteBancaire.addToEcritures(new Ecriture(
							typeEcriture: TypeEcriture.get(61),
							etat: EtatEcriture.get(2),
							montant: soldeInitial
					))
				}
			} catch (e){
				flash.message += " <b style='color:red'>Le solde initial [${params.soldeInitial}] n'a pas été pris en compte.</b>"
			}
			new Activity(user:session.user, opType:Activity.CREATE, controllerId:Activity.COMPTE_BANCAIRE, entityId:compteBancaire.id).save()
            redirect(action:detail,id:compteBancaire.id)
        }
        else {
            render(view:'create',model:[compteBancaire:compteBancaire])
        }
    }

}
