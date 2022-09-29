
class EcritureController {
    static accessControl = {
		permission(perm: new EtudePerm('Ecriture',  'Liste' ), only: ['list'])
		permission(perm: new EtudePerm('Ecriture',  'Consultation' ), only: ['show', 'receipt'])
        permission(perm: new EtudePerm('Ecriture',  'Modification' ), only: [ 'edit', 'update'])
        permission(perm: new EtudePerm('Ecriture',  'ModificationMasse' ), only: [ 'validate', 'submitToValidate','affect', 'submitToAffect' ])
        permission(perm: new EtudePerm('Ecriture',  'Creation' ), only: [ 'create', 'createManyFrais','saveMany', 'save' ])
        permission(perm: new EtudePerm('Ecriture', 'Suppression'), only: [ 'delete'])
        permission(perm: new EtudePerm('Ecriture',  'RapportDetail' ), only: [ 'summary','detailFraisPrix', 'export','doExport', 'search', 'results'])
        permission(perm: new EtudePerm('Ecriture',  'RapportSynthese' ), only: [ 'summaryFraisPrix','groupement'])
		role(name: 'Maitre', only: ['selection','doSelect'])
    }
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [validate:'GET',delete:'POST', save:'POST', update:'POST', submitToValidate:'POST']

    def validate = {
		if (!params.id){flash.message="Il faut s&eacute;lectionner un compte bancaire";redirect(controller:'compteBancaire', action:'synthese')}
        if(!params.max)params.max = 13
		if(!params.sort){
			params.sort = "dateValeur"
			params.order = "desc" 
		}
		def montant = null
		try {montant = new BigDecimal(params.get("q"))} catch (ex){}
		def pieceComptable = params.get("q") ? ParamUtils.keyword(params.get("q")) : null
		def commentaire = params.get("q")  ? ParamUtils.keyword(params.get("q")) : null
		def compte = CompteBancaire.get(params.id)
		def enCours = EtatEcriture.findByLibelle("En Cours")
		def results = Ecriture.withCriteria{
			eq('etat',enCours)
			eq('compteBancaire',compte)
			and {
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
			}
			maxResults(params.max.toInteger())
			order(params.sort,params.order)
			firstResult(params.offset?params.offset.toInteger():0)
		}
		def count = Ecriture.createCriteria().get{
			eq('etat',enCours)
			eq('compteBancaire',compte)
			and {
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
			}
			projections { 
				countDistinct('id') 
			} 
		}
		def map = results.groupBy{it instanceof EcritureDossier}
		map = (map.get(true)?.groupBy{it.dossier} ?: [:]) + (map.get(false) ? ["Aucun dossier":(map.get(false))] : [:])
		[ ecritureDossierMap: map, count:count, compteBancaire:compte, paginateParams:ParamUtils.paginate(params,['q','id']), sortParams:ParamUtils.sort(params, ['q','id']),listSize:results.size()]
    }
    def submitToValidate = {
		def dat = new java.text.SimpleDateFormat('dd/MM/yyyy')
		def encoursSize = new Integer(params.listSize)
		def compte = CompteBancaire.get(params.'compteBancaire.id')
		def valide = EtatEcriture.findByLibelle("Valid\u00E9e")
		for (i in 0..(encoursSize-1)) {
			if (params.get("check"+i)){
				def dateValeurStr = params.get("dateValeur"+i)
				def dateMouvementStr = params.get("dateMouvement"+i)
				def ecr = Ecriture.get(params.get("id"+i))
				try {
					ecr.dateValeur = dat.parse(dateValeurStr)
					ecr.dateMouvement = dat.parse(dateMouvementStr)
					ecr.etat = valide
					ecr.save()
					if (!flash.message) flash.message = ""
					def msg = "Valid&eacute; : $ecr"
					flash.message += msg + "<br/>"
					new Activity(user:session.user, opType:Activity.VALIDATE, controllerId:(ecr instanceof EcritureDossier ? Activity.ECRITURE_DOSSIER : Activity.ECRITURE), entityId:ecr.id).save()
				} catch (e){
					log.warn(e)
					def msg = "Format de date incorrect, utiliser [jj/mm/aaaa] dans : $ecr"
					if (!flash.messageError) flash.messageError = ""
					flash.messageError += msg + "<br/>"
				}
			}
		}
        redirect(action:validate,id:compte.id)
    }
    def affect = {
		if (!params.id){flash.message="Il faut s&eacute;lectionner un compte bancaire";redirect(controller:'compteBancaire', action:'synthese')}
        if(!params.max)params.max = 13
        if(!params.offset)params.offset = 0
		if(!params.sort){
			params.sort = "dateValeur"
			params.order = "desc" 
		}
		def montant = null
		try {montant = new BigDecimal(params.get("q"))} catch (ex){}
		def pieceComptable = params.get("q") ? ParamUtils.keyword(params.get("q")) : null
		def commentaire = params.get("q")  ? ParamUtils.keyword(params.get("q")) : null
		def cb = CompteBancaire.get( params.id )
        def mpList = [MoyenPaiement.findByLibelle("Ch\u00E8que"),MoyenPaiement.findByLibelle("Virement")]
        def results = Ecriture.withCriteria{
			typeEcriture{
                eq('affectable',true)
            }
			isNull('compteBancaire')
            inList('moyenPaiement',mpList)
			and {
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
			}
			maxResults(params.max.toInteger())
			order(params.sort,params.order)
			firstResult(params.offset?params.offset.toInteger():0)
		}
        def countByEtat = Ecriture.createCriteria().get{
			typeEcriture{
                eq('affectable',true)
            }
			isNull('compteBancaire')
            inList('moyenPaiement',mpList)
			and {
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
			}
			projections {
				countDistinct('id')
			}
		}
		def map = results.groupBy{it instanceof EcritureDossier}
		map = (map.get(true)?.groupBy{it.dossier} ?: [:]) + (map.get(false) ? ["Aucun dossier":(map.get(false))] : [:])
		[ compteBancaire:cb,ecritureDossierMap: map, count:countByEtat, paginateParams:ParamUtils.paginate(params,['q','id']), sortParams:ParamUtils.sort(params, ['q','id']),listSize:(results.size())]
    }
    def selection = {
        if(!params.max)params.max = 13
		if(!params.sort){
			params.sort = "dateValeur"
			params.order = "desc" 
		}
		def results = Ecriture.list(params)
		def count = Ecriture.count()
		[ ecritureDossierList: results, count:count]
    }
    def submitToAffect = {
		def dat = new java.text.SimpleDateFormat('dd/MM/yyyy')
		def listSize = new Integer(params.listSize)
		def compte = CompteBancaire.get(params.'compteBancaire.id')
		for (i in 0..(listSize-1)) {
			if (params.get("check"+i)){
				def dateValeurStr = params.get("dateValeur"+i)
				def dateMouvementStr = params.get("dateMouvement"+i)
				def ecr = Ecriture.get(params.get("id"+i))
				try {
					ecr.dateValeur = dat.parse(dateValeurStr)
					ecr.dateMouvement = dat.parse(dateMouvementStr)
					ecr.compteBancaire = compte
					if (ecr.save()) {
						if (!flash.message) flash.message = ""
						def msg = "Affect&eacute; : $ecr"
						flash.message += msg + "<br/>"
						new Activity(user:session.user, opType:Activity.AFFECT, controllerId:(ecr instanceof EcritureDossier ? Activity.ECRITURE_DOSSIER : Activity.ECRITURE), entityId:ecr.id).save()
					}
				} catch (e){
					def msg = "Format de date incorrect, utiliser [jj/mm/aaaa] dans : $ecr"
					if (!flash.messageError) flash.messageError = ""
					flash.messageError += msg + "<br/>"
				}
			}
		}
		params.id = compte.id
        redirect(action:'affect',id:compte.id)
    }

    def doSelect = {
		def encoursSize = new Integer(params.encoursSize)
		for (i in 0..(encoursSize-1)) {
			def ecr = Ecriture.get(params.get("id"+i))
			if (params.get("check"+i) && !ecr?.marked){
				ecr.marked = true
				sel(ecr)
			} else if (!params.get("check"+i) && ecr?.marked) {
				ecr.marked = false
				sel(ecr)
			}
		}
        redirect(action:selection, params:params)
    }
	
	void sel(ecr){
		ecr?.save()
		if (!flash.message) flash.message = ""
		def msg = "S&eacute;lectionn&eacute;e : $ecr"
		flash.message += msg + "<br/>"
	}

    def list = {
        if(!params.max)params.max = 13
		if(!params.sort){
			params.sort = "dateValeur"
			params.order = "desc" 
		}
		def result = Ecriture.withCriteria {
			if (!SecUtils.maitre()) {
				or {
					eq('marked',false)
					isNull('marked')
				}
			}
			typeEcriture {
				eq("categorieEcriture.id", 3l)
			}
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
			typeEcriture {
				eq("categorieEcriture.id", 3l)
			}
			projections { 
				countDistinct('id') 
			} 
		}
		[ ecritureDossierMap: result.groupBy{it.compteBancaire}, count:count ]
    }

    def show = {
		def ecr = Ecriture.get( params.id )
		if (!ecr) {
            flash.message = "L'&eacute;criture s&eacute;lectionn&eacute;e (ID ${params.id}) n'existe plus."
			flash.messageType='warn'
            redirect(action:list)
		}
        [ ecritureDossier : ecr ]
    }

    def delete = {
        def ecr = Ecriture.get( params.id )
        if(ecr) {
			if (ecr.canBeDeleted()){
				def str = ecr.toString()
				ecr.delete()
				def activity = new Activity(user:session.user, opType:Activity.DELETE, controllerId:(ecr instanceof EcritureDossier ? Activity.ECRITURE_DOSSIER : Activity.ECRITURE), entityId:ecr.id,msg:" ["+ecr+"]")
				activity += ecr
				activity.save()
				flash.message = "[$str] supprim&eacute;e."
			} else {
				flash.message = "${g.message(code:'ecriture.verrouillee')}"
				flash.messageType = "warn"
			}
			if (params.from == "compte") {
				redirect(controller:'compteBancaire',action:show,id:ecr.compteBancaire.id)
			} else {
				redirect(action:list)
			}
        }
        else {
            flash.message = "Ecriture ${params.id} introuvable"
            redirect(action:list)
        }
    }

    def edit = {
        def ecriture = Ecriture.get( params.id )
	
        if(!ecriture) {
                flash.message = "Ecriture ${params.id} introuvable"
                redirect(action:list)
        }
        else {
			def lovCompte = CompteBancaire.list(sort:'dateCreation', order:'desc')
            return [ ecritureDossier : ecriture, lovCompte: lovCompte]
        }
    }

    def update = {
        def ecriture = Ecriture.get( params.id )
        if(ecriture) {
             ecriture.properties = params
            if(ecriture.save()) {
				def activity = new Activity(user:session.user, opType:Activity.UPDATE, controllerId:(ecriture instanceof EcritureDossier ? Activity.ECRITURE_DOSSIER : Activity.ECRITURE), entityId:ecriture.id)
				activity << ecriture
				activity.save()
                flash.message = "[${ecriture}] mis &agrave; jour."
				if (params.from == "compte") {
					redirect(controller:'compteBancaire',action:show,id:ecriture.compteBancaire.id)
				} else {
		            redirect(action:show,id:ecriture.id)
				}
            }
            else {
				def lovCompte = CompteBancaire.list(sort:'dateCreation', order:'desc')
                render(view:'edit',model:[ecritureDossier:ecriture, lovCompte: lovCompte])
            }
        }
        else {
            flash.message = "Ecriture introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def ecriture = new Ecriture()
        ecriture.properties = params
		def lovCompte = params."compte.id" ? [] : CompteBancaire.list(sort:'dateCreation', order:'desc')
		if (params."compte.id") {
			ecriture.compteBancaire = CompteBancaire.get(new Integer(params."compte.id"))
		}
		def c = TypeEcriture.createCriteria()
		def lovTypeEcriture = c {
			eq("categorieEcriture.id", 3l)
		}
        return ['ecritureDossier':ecriture, 'lovCompte':lovCompte]
    }
    
	
    def save = {
        def ecriture = new Ecriture(params)
        if(ecriture.save()) {
			new Activity(user:session.user, opType:Activity.CREATE, controllerId:(ecriture instanceof EcritureDossier ? Activity.ECRITURE_DOSSIER : Activity.ECRITURE), entityId:ecriture.id).save()
            flash.message = "[${ecriture}] cr&eacute;e dans la base de donn&eacute;e."
			if (ecriture.compteBancaire) {
				redirect(controller:'compteBancaire',action:'detail',id:ecriture.compteBancaire.id)
			} else {
				redirect(action:'show',id:ecriture.id)
			}
        } else {
			def lovCompte = CompteBancaire.list(sort:'dateCreation', order:'desc')
			render(view:'create',model:['Ecriture':ecriture, 'lovCompte':lovCompte])
        }
    }

    def receipt = {
        def ecriture = Ecriture.get( params.id )
        render(view:'receipt',model:[ecritureDossier:ecriture])
    }
    def export = {
		use (org.codehaus.groovy.runtime.TimeCategory) {
			return [lovCompteBancaire:CompteBancaire.list(), lovEtat:EtatEcriture.list(), debut:ParamUtils.newDate()-1.months, fin:ParamUtils.newDate()]
		}
    }
    def doExport = {
		def gid = params.get("compteBancaire.id")
		if (!gid) {
            flash.message = "Vous devez s&eacute;l&eacute;ctionner un compte bancaire"
			flash.messageType='warn'
            redirect(action:export)
		} else {
			def cb = CompteBancaire.get(new Integer(gid))
			def e = EtatEcriture.get(new Integer(params.get("etat.id")))
			def debut = ParamUtils.toDate(params,'debut')
			def fin = ParamUtils.toDate(params,'fin')
			def synthese = Ecriture.executeQuery("""
			select ecr
			from Ecriture ecr
			where ecr.compteBancaire = :compteBancaire
			and ecr.etat = :etat
			and datediff('dd', :debut, ecr.dateMouvement)>= 0  
			and datediff('dd', ecr.dateMouvement, :fin) >=0  
			 ${SecUtils.maitreCrit()}
			order by ecr.dateMouvement asc
			""",[compteBancaire:cb, etat:e,debut:debut,fin:fin])
			def title="Relev&eacute;  : ${cb?.libelle} (${e?.libelle})"
			def dat = new java.text.SimpleDateFormat('dd MMMM yyyy')
			def tip="P&eacute;riode du <b>${dat.format(debut)}</b> au <b>${dat.format(fin)}</b>."
	        if (synthese?.empty || params.format == null || params.format=='html') {
				render(view:'list',model: [ecritureDossierList:synthese, nopaginate:true, title:title, tip:tip])
			} 	else if (params.format=='xls')  {
				def header = [
					dossier : message(code:"xls.header.dossier"),
					typeEcriture : message(code:"xls.header.typeEcriture"),
					commentaire : message(code:"xls.header.commentaire"),
				    debit : message(code:"xls.header.debit"),
				    credit : message(code:"xls.header.credit"),
				    dateMouvement : message(code:"xls.header.dateMouvement"),
				    dateValeur : message(code:"xls.header.dateValeur"),
				    moyenPaiement : message(code:"xls.header.moyenPaiement"),
				    pieceComptable : message(code:"xls.header.pieceComptable"),
					acte : message(code:"xls.header.acte")
				]
				ExcelWriter.writeSheet((cb.libelle+"_"+ParamUtils.duration(debut,fin)+"_"+e).replace('/','_').replace(' ','_').replace('__','_')
				, response, header,toMap(synthese),cb.libelle + ' '+e)
			}
		}
    }
def toMap(results){
			def display = []
			def totalDebit=new BigDecimal(0)
			def totalCredit=new BigDecimal(0)
			results.each{display << [typeEcriture:(it.marked ? '(*) ' : '')+it.typeEcriture?.id + " - " +it.typeEcriture?.libelle,
			dossier:it instanceof EcritureDossier ? it.dossier : null,
			debit:(it.typeEcriture.credit?null:it.montant),
			credit:(it.typeEcriture.credit?it.montant:null),
			dateMouvement:it.dateMouvement,
			commentaire:it.commentaire,
			acte:it instanceof EcritureDossier ? it.acte : null,
			pieceComptable:it.pieceComptable,
			moyenPaiement:it.moyenPaiement,
			dateValeur:it.dateValeur,
			compteBancaire:it.compteBancaire,
			etat:it.etat
			]
			totalDebit+=(it.typeEcriture.credit?new BigDecimal(0):(it.montant ? it.montant: new BigDecimal(0)))
			totalCredit+=(it.typeEcriture.credit?(it.montant ? it.montant: new BigDecimal(0)):new BigDecimal(0))
			}
			display << [typeEcriture:"_Total :",credit:totalCredit,debit:totalDebit]
			return display
}
    def simpleSearch = {
        chain(action:"results",params:[format:'html',montant:params.q,commentaire:params.q,pieceComptable:params.q,simple:true])
    }
    def search = {
        render(view:"_search",model:[lovEtat:EtatEcriture.list(), lovCompteBancaire : CompteBancaire.list(), lovTypeEcriture : TypeEcriture.findAll([sort:"categorieEcriture", order:"asc"]),debut:ParamUtils.newDate()-90, fin:ParamUtils.newDate()+3])
    }
    def results = {
	        if(params.format=='html' && !params.max)params.max = 13
			if(!params.sort){
				params.sort = "dateMouvement"
				params.order = "desc" 
			}
			def e = params.get("etat.id")
			e = (e!=null && e!=/${}/) ? EtatEcriture.get(new Integer(e)) : null
			def compteBancaire = params.get("compteBancaire.id")
			compteBancaire = (compteBancaire!=null && compteBancaire!=/${}/) ? CompteBancaire.get(new Integer(compteBancaire)) : null
			def typeEcriture = params.get("typeEcriture.id")
			typeEcriture = (typeEcriture!=null && typeEcriture!=/${}/) ? TypeEcriture.get(new Integer(typeEcriture)) : null
			def montant = null
			try {montant = new BigDecimal(params.get("montant"))} catch (ex){}
			def pieceComptable = params.get("pieceComptable") ? ParamUtils.keyword(params.get("pieceComptable")) : null
			def commentaire = params.get("commentaire")  ? ParamUtils.keyword(params.get("commentaire")) : null
			def debut = ParamUtils.toDate(params,'debut')
			def fin = ParamUtils.toDate(params,'fin')
			def args = [debut:debut,fin:fin]
			def simple = params.simple == 'true'
			def synthese = Ecriture.withCriteria{
				if (simple) {
						if (commentaire != null) {
							or {
								if (montant != null) between('montant', montant, (montant + new BigDecimal(1)) as BigDecimal)
								ilike('pieceComptable', pieceComptable)
								ilike('commentaire', commentaire)
							}
						}
				} else {
					between('dateMouvement', debut, fin)
					if (e != null) eq('etat', e)
					if (compteBancaire != null) eq('compteBancaire', compteBancaire)
					if (typeEcriture != null) eq('typeEcriture', typeEcriture)
					if (montant != null) between('montant', montant, (montant + 1) as BigDecimal)
					if (pieceComptable != null) ilike('pieceComptable', pieceComptable)
					if (commentaire != null) ilike('commentaire', commentaire)
				}
				if (!SecUtils.maitre()) {
					or {
						eq('marked',false)
						isNull('marked')
					}
				}
				if(params.format == 'html') {
					maxResults(params.max.toInteger())
					firstResult(params.offset?params.offset.toInteger():0)
				}
				order(params.sort,params.order)
			}

			def title="D&eacute;tail  : "
			def dat = new java.text.SimpleDateFormat('dd MMMM yyyy')
	        if (synthese?.empty || params.format == null || params.format=='html') {
				def count = Ecriture.createCriteria().get{
					if (simple) {
						if (commentaire != null) {
							or {
								if (montant != null) between('montant', montant, (montant + new BigDecimal(1)) as BigDecimal)
								ilike('pieceComptable', pieceComptable)
								ilike('commentaire', commentaire)
							}
						}
					} else {
						between('dateMouvement', debut, fin)
						if (e != null) eq('etat', e)
						if (compteBancaire != null) eq('compteBancaire', compteBancaire)
						if (typeEcriture != null) eq('typeEcriture', typeEcriture)
						if (montant != null) between('montant', montant, (montant + 1f) as BigDecimal)
						if (pieceComptable != null) ilike('pieceComptable', pieceComptable)
						if (commentaire != null) ilike('commentaire', commentaire)
					}
					if (!SecUtils.maitre()) {
						or {
							eq('marked',false)
							isNull('marked')
						}
					}
					projections { 
						countDistinct('id') 
					} 
				}
				def sortParams = new HashMap()
				params.each{k,v -> sortParams.put(k,v)}
				sortParams.remove('sort')
				sortParams.remove('order')
				if (count==1){
					def ecr = synthese.get(0)
					redirect(controller:(ecr instanceof EcritureDossier ? 'ecritureDossier' : 'ecriture'), action:show, id: ecr.id)
				} else {
					return [ecritureDossierList:synthese, count:count, sortParams:sortParams,debut:debut,fin:fin,etat:e,compteBancaire:compteBancaire,typeEcriture:typeEcriture,pieceComptable:params.get("pieceComptable"),montant:montant, commentaire:params.get("commentaire"),simple:simple]
				}
			} 	else if (params.format=='xls')  {
				def header = [
					dossier : message(code:"xls.header.dossier"),
					typeEcriture : message(code:"xls.header.typeEcriture"),
					commentaire : message(code:"xls.header.commentaire"),
				    debit : message(code:"xls.header.debit"),
				    credit : message(code:"xls.header.credit"),
				    dateValeur : message(code:"xls.header.dateValeur"),
				    dateMouvement : message(code:"xls.header.dateMouvement"),
				    moyenPaiement : message(code:"xls.header.moyenPaiement"),
					etat : message(code:"xls.header.etat"),
				    pieceComptable : message(code:"xls.header.pieceComptable"),
					acte : message(code:"xls.header.acte"),
					compteBancaire : message(code:"xls.header.compteBancaire")
				]
				ExcelWriter.writeSheet("recherche_"+(ParamUtils.duration(debut,fin)).replace('/','_').replace(' ','_').replace('__','_')
				, response, header,toMap(synthese),message(code:"search.results"))
			}
	}
}
