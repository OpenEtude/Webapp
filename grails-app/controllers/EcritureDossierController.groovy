
class EcritureDossierController {
    static accessControl = {
		permission(perm: new EtudePerm('EcritureDossier',  'Liste' ), only: ['list'])
		permission(perm: new EtudePerm('EcritureDossier',  'Consultation' ), only: ['show', 'receipt'])
        permission(perm: new EtudePerm('EcritureDossier',  'Modification' ), only: [ 'edit', 'update'])
        permission(perm: new EtudePerm('EcritureDossier',  'ModificationMasse' ), only: [ 'validate', 'submitToValidate' ])
        permission(perm: new EtudePerm('EcritureDossier',  'Creation' ), only: [ 'create', 'createManyFrais','saveMany', 'save' ])
        permission(perm: new EtudePerm('EcritureDossier', 'Suppression'), only: [ 'delete'])
        permission(perm: new EtudePerm('EcritureDossier',  'RapportDetail' ), only: [ 'summary','detailFraisPrix'])
        permission(perm: new EtudePerm('EcritureDossier',  'RapportSynthese' ), only: [ 'summaryFraisPrix','groupement','tdb', 'tdbDisplay', 'critereGroupement'])
		role(name: 'Maitre', only: ['selection','doSelect'])
    }
	def toDate(params,varName,methode="specific"){
		def date = null
		def cal = Calendar.instance
		if ("specific"==methode){
			date = new java.text.SimpleDateFormat('dd/MM/yyyy').parse(params.get(varName+'_day')+'/'+params.get(varName+'_month')+'/'+params.get(varName+'_year'))
		} else if ("currMonth"==methode){
			cal.set(Calendar.DAY_OF_MONTH, (varName == 'debut' ? 1 : cal.getActualMaximum(Calendar.DAY_OF_MONTH)))
			date = cal.time
		} else if ("currQuarter"==methode){
			int month = cal.get(Calendar.MONTH) /* 0 through 11 */
			int quarter = (month / 3)
			cal.set(Calendar.MONTH, (varName == 'debut' ? (quarter * 3) : (((1+quarter) * 3)-1)))
			cal.set(Calendar.DAY_OF_MONTH, (varName == 'debut' ? 1 : cal.getActualMaximum(Calendar.DAY_OF_MONTH)))
			date = cal.time
		} else if ("currYear"==methode){
			cal.set(Calendar.MONTH, (varName == 'debut' ? 0 : 11))
			cal.set(Calendar.DAY_OF_MONTH, (varName == 'debut' ? 1 : 31))
			date = cal.time
		}
		date.clearTime()
		return date
	}
	def fileDate(){new java.text.SimpleDateFormat('ddMMMMyyyy').format(new Date())}
	def duration(date1, date2){
		def fmt = new java.text.SimpleDateFormat('dd.MM.yyyy')
		fmt.format(date1)+ "_"+fmt.format(date2)
	}
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [validate:'GET',delete:'POST', save:'POST', update:'POST', submitToValidate:'POST',tdb:'GET',tdbDisplay:'GET']

    def validate = {
        if(!params.max)params.max = 14
		if(!params.sort){
			params.sort = "dateValeur"
			params.order = "desc" 
		}
		def montant = null
		try {montant = new BigDecimal(params.get("q"))} catch (ex){}
		def pieceComptable = params.get("q") ? ParamUtils.keyword(params.get("q")) : null
		def commentaire = params.get("q")  ? ParamUtils.keyword(params.get("q")) : null
		def results = EcritureDossier.withCriteria{
			eq('etat',EtatEcriture.findByLibelle("En Cours"))
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
		def count = EcritureDossier.createCriteria().get{
			eq('etat',EtatEcriture.findByLibelle("En Cours"))
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
		[ ecritureDossierMap: results.groupBy{it.dossier}, count:count, paginateParams:ParamUtils.paginate(params,['q']), sortParams:ParamUtils.sort(params, ['q']), encoursSize:results.size()]
    }
    def selection = {
        if(!params.max)params.max = 14
		if(!params.sort){
			params.sort = "dateValeur"
			params.order = "desc" 
		}
		def results = EcritureDossier.list(params)
		def count = EcritureDossier.count()
		[ ecritureDossierList: results, count:count]
    }
    def submitToValidate = {
		def dat = new java.text.SimpleDateFormat('dd/MM/yyyy')
		def encoursSize = new Integer(params.encoursSize)
		def valide = EtatEcriture.findByLibelle("Valid\u00E9e")
		for (i in 0..(encoursSize-1)) {
			if (params.get("check"+i)){
				def dateValeurStr = params.get("dateValeur"+i)
				def dateMouvementStr = params.get("dateMouvement"+i)
				def ecr = EcritureDossier.get(params.get("id"+i))
				try {
					ecr.dateValeur = dat.parse(dateValeurStr)
					ecr.dateMouvement = dat.parse(dateMouvementStr)
					ecr.etat = valide
					ecr.save()
					if (!flash.message) flash.message = ""
					def msg = "Valid&eacute; : [${ecr.dossier}] $ecr"
					flash.message += msg + "<br/>"
					def activity = new Activity(user:session.user, opType:Activity.VALIDATE, controllerId:Activity.ECRITURE_DOSSIER, entityId:ecr.id)
					activity.save()
				} catch (e){
					def msg = "Format de date incorrect, utiliser [jj/mm/aaaa] dans : [${ecr.dossier}] $ecr"
					if (!flash.messageError) flash.messageError = ""
					flash.messageError += msg + "<br/>"
				}
			}
		}
        redirect(action:validate)
    }

    def doSelect = {
		def encoursSize = new Integer(params.encoursSize)
		for (i in 0..(encoursSize-1)) {
			def ecr = EcritureDossier.get(params.get("id"+i))
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
		def msg = "S&eacute;lectionn&eacute;e : [${ecr?.dossier}] $ecr"
		flash.message += msg + "<br/>"
	}

    def list = {
        if(!params.max)params.max = 14
		if(!params.sort){
			params.sort = "dateValeur"
			params.order = "desc" 
		}
		def results = SecUtils.maitre() ? EcritureDossier.list(params) : EcritureDossier.withCriteria{
			or {
				eq('marked',false)
				isNull('marked')
			}
			maxResults(params.max.toInteger())
			order(params.sort,params.order)
			firstResult(params.offset?params.offset.toInteger():0)
		}
		def count = SecUtils.maitre() ? EcritureDossier.count() : EcritureDossier.createCriteria().get{
			or {
				eq('marked',false)
				isNull('marked')
			}
			projections { 
				countDistinct('id') 
			} 
		}
        if (results?.empty || params.format == null || params.format=='html') {
			
			return [ ecritureDossierMap: results.groupBy{it.dossier}, count:count ]
		}
		else if (params.format=='xls')  { 
			def header = [
				typeEcriture : message(code:"xls.header.typeEcriture"),
				dossier : message(code:"xls.header.dossier"),
			    debit : message(code:"xls.header.debit"),
			    credit : message(code:"xls.header.credit"),
			    dateValeur : message(code:"xls.header.dateValeur"),
			    dateMouvement : message(code:"xls.header.dateMouvement"),
			    etat : message(code:"xls.header.etat")
			]
			def display = []
			def totalDebit=new BigDecimal(0)
			def totalCredit=new BigDecimal(0)
			results.each{display << [typeEcriture:it.typeEcriture?.id + " - " +it.typeEcriture?.libelle,
			dossier:it.dossier,
			debit:(it.typeEcriture.credit?null:it.montant),
			credit:(it.typeEcriture.credit?it.montant:null),
			dateMouvement:it.dateMouvement,
			dateValeur:it.dateValeur,
			etat:it.etat]
			totalDebit+=(it.typeEcriture.credit?new BigDecimal(0):it.montant)
			totalCredit+=(it.typeEcriture.credit?it.montant:new BigDecimal(0))
			}
			display << [typeEcriture:"_"+message(code:"xls.header.solde"),dossier:totalCredit-totalDebit,credit:totalCredit,debit:totalDebit]
			ExcelWriter.writeSheet("Liste_des_\u00e9critures", response, header,display,"Ecritures")
		}

    }

    def show = {
		def ecr = EcritureDossier.get( params.id )
		if (!ecr) {
            flash.message = "L'&eacute;criture s&eacute;lectionn&eacute;e (ID ${params.id}) n'existe plus."
			flash.messageType='warn'
            redirect(action:list)
		}
        [ ecritureDossier : ecr ]
    }

    def summary = {
        if(!params.max)params.max = 14
        if(!params.offset)params.offset = 0
		def syntheseEcritures = EcritureDossier.executeQuery("""
		select new map(ed.typeEcriture as typeEcriture, sum(ed.montant) as solde) 
		from EcritureDossier ed 
		where (ed.typeEcriture.credit = false) or (ed.typeEcriture.credit = true and ed.etat.id = :etat) ${SecUtils.maitreCrit('ed')}
		group by ed.typeEcriture.id 
		order by ed.typeEcriture.id asc
		""",[etat:2l],[max : new Long(params.max), offset : new Long(params.offset)])
        if (params.format == null || params.format=='html') {
	        [ syn : syntheseEcritures ]
		} 	else if (params.format=='xls')  { 
			def header = [
				typeEcriture : message(code:"xls.header.typeEcriture"),
			    solde : message(code:"xls.header.solde")
			]
			ExcelWriter.writeSheets("Synth\u00e8se_${fileDate()}", response, [header],[syntheseEcritures],["Synth\u00e8se"])
		}
    }

    def summaryFraisPrix = {
		def syntheseEcritures = EcritureDossier.executeQuery("""
		select new map(ed.typeEcriture.categorieEcriture as categorieEcriture, sum((case ed.typeEcriture.credit when false then -1 else 1 end) * ed.montant) as solde) 
		from EcritureDossier ed 
		where (ed.typeEcriture.credit = false) or (ed.typeEcriture.credit = true and ed.etat.id = 2)  ${SecUtils.maitreCrit('ed')}
		group by ed.typeEcriture.categorieEcriture.id 
		order by ed.typeEcriture.categorieEcriture.id asc
		""")
        if (params.format == null || params.format=='html') {
	        [ syn : syntheseEcritures ]
		} 	else if (params.format=='xls')  { 
			def header = [
				categorieEcriture : message(code:"xls.header.categorieEcriture"),
			    solde : message(code:"xls.header.solde")
			]
			ExcelWriter.writeSheets("Synth\u00e8se_Frais_Prix_${fileDate()}", response, [header],[syntheseEcritures],["Synth\u00e8se Frais Prix"])
		}
    }

    def detailFraisPrix = {
    	boolean notXls = (params.format == null || params.format=='html')
        if(!params.max)params.max = 14
        if(!params.offset)params.offset = 0
        if (!notXls) {
        	params.remove('max')
        	params.remove('offset')
        }
        def precision = null
        try {
        	precision = new Integer(params.precision ?: 0)
        } catch (e) {
        	flash.message = "Veuillez saisir un montant seuil du solde"
        	flash.messageType = "warn"
        	redirect(action:'detailFraisPrix')
        }
        if (precision || !params.precision) {
		def soldePrix = "sum((case ecr.typeEcriture.categorieEcriture.id when 2 then 1 else 0 end)*(case ecr.typeEcriture.credit when false then -1 else 1 end) * ecr.montant)"

		def soldeFrais = "sum((case ecr.typeEcriture.categorieEcriture.id when 1 then 1 else 0 end)*(case ecr.typeEcriture.credit when false then -1 else 1 end) * ecr.montant)"
		def qry = """
			select new map(ecr.dossier as dossier,ecr.dossier.description as description, $soldeFrais as soldeFrais, $soldePrix as soldePrix, ecr.dossier.dateCreation as dateCreation) 
			from EcritureDossier  ecr
			where ((ecr.typeEcriture.credit = false)
			or (ecr.typeEcriture.credit = true and ecr.etat.id = :flag))
			${SecUtils.maitreCrit()}
			group by ecr.dossier,ecr.dossier.description, ecr.dossier.dateCreation 
			having ($soldeFrais not between (-1 * :precision) and :precision or $soldePrix not between (-1 * :precision) and :precision )
			order by ecr.dossier.dateCreation desc
			
		"""
		def qParams = [flag:2l,'precision':precision]
		//FIXME: what a huge issue there :D
		def resultCount = notXls ? EcritureDossier.executeQuery(qry, qParams).size() : -1
		def synthese = EcritureDossier.executeQuery(qry,qParams,(notXls ? [max : new Long(params.max), offset : new Long(params.offset)] : [:]))
        if (notXls) {
	        return [ syn : synthese, count:resultCount ]
		} 	else if (params.format=='xls')  { 
			def header = [
				dossier : message(code:"xls.header.dossier"),
				description : message(code:"xls.header.description"),
			    soldeFrais : message(code:"xls.header.soldeFrais"),
			    soldePrix : message(code:"xls.header.soldePrix")
			]
			ExcelWriter.writeSheets("D\u00e9tail_Frais_Prix_${fileDate()}", response, [header],[synthese],["D\u00e9tail Frais Prix"])
		}
        }
    }

    def critereGroupement = {
        [lovGroupement:Groupement.list(), lovEtat:EtatEcriture.list(), debut:ParamUtils.newDate()-90, fin:ParamUtils.newDate()]
    }
    def groupement = {
		def gid = params.get("groupement.id")
		if (!gid) {
            flash.message = "Vous devez s&eacute;l&eacute;ctionner un groupement d'ecritures param&egrave;tr&eacute;"
			flash.messageType='warn'
            redirect(action:critereGroupement)
		} else {
			def g = Groupement.get(new Integer(gid))
			def e = EtatEcriture.get(new Integer(params.get("etat.id")))
			def debut = toDate(params,'debut',params.periode)
			def fin = toDate(params,'fin',params.periode)
			def synthese = Ecriture.executeQuery("""
			select new map(ecr.typeEcriture as typeEcriture, sum(ecr.montant) as total)
			from Ecriture ecr, TypeEcritureGroupementRel rel 
			where ecr.typeEcriture = rel.typeEcriture
			and rel.groupement = :groupement
			and ecr.etat = :etat
			and ecr.dateMouvement between :debut and :fin  
			 ${SecUtils.maitreCrit()}
			group by ecr.typeEcriture
			order by sum(ecr.montant) desc
			""",[groupement:g, etat:e,debut:debut,fin:fin])
	        if (synthese?.empty || params.format == null || params.format=='html') {
		        return [synthese:synthese, groupement:g, etat:e,debut:debut,fin:fin]
			} 	else if (params.format=='xls')  {
				def header = [
					typeEcriture : message(code:"xls.header.typeEcriture"),
				    total : message(code:"xls.header.total")
				]
				def total = new BigDecimal(0)
				synthese?.each{if (it.total) total+=it.total}
				synthese << [typeEcriture:"_Total :",'total':total]
				ExcelWriter.writeSheet((g.libelle +"_"+duration(debut,fin)+' '+e).replace('/','_').replace(' ','_').replace('__','_')
				, response, header,synthese,g.libelle + ' '+e)
			}
		}

		}

    def tdb = {
		use (org.codehaus.groovy.runtime.TimeCategory) {
			return [lovEtat:EtatEcriture.list(), debut:ParamUtils.newDate()-3.months, fin:ParamUtils.newDate()]
		}
    }

    def tdbDisplay = {

		def e = EtatEcriture.get(new Integer(params.get("etat.id")))
		def debut = toDate(params,'debut',params.periode)
		def fin = toDate(params,'fin',params.periode)
    	println "**"*10
    	println SecUtils.maitreCrit()
    	println ([etat:e,debut:debut,fin:fin]) 
    	println "**"*10

   		def res = Ecriture.executeQuery("""
		select new map(rel.groupement as grp, ecr.typeEcriture as typeEcriture, sum(ecr.montant) as total)
		from Ecriture ecr, TypeEcritureGroupementRel rel 
		where ecr.typeEcriture = rel.typeEcriture
		and ecr.dateMouvement between :debut and :fin  
		${SecUtils.maitreCrit()}
		group by rel.groupement, ecr.typeEcriture
		order by  sum(ecr.montant) desc, rel.groupement desc
		""",[debut:debut,fin:fin])
		// and datediff('dd', :debut, ecr.dateMouvement)>= 0  
		// and datediff('dd', ecr.dateMouvement, :fin) >=0  
		
		def result = [:]
		res.each{
			def syn = result[it.grp]
			if (!syn) {
				syn = new ArrayList();result[it.grp] = syn
			}
			syn << [typeEcriture : it.typeEcriture, total:it.total]
		}
		if (res?.empty || params.format == null || params.format=='html') {
		    return [all:result, etat:e,debut:debut,fin:fin]
		} else {
			def headers = [] 
			result.keySet().size().times{
				headers << [typeEcriture : "Libelle", total : "Total"]
			}

			ExcelWriter.writeSheets(("Synht\u00e8se_groupements_"+duration(debut,fin)+"_"+e).replace('/','_').replace(' ','_').replace('__','_')
			, response, headers,result.collect{it.value},result.keySet().collect{it.libelle + ' '+e})
		}
    }
    def groupementDetail = {
		def gid = params.get("groupement.id")
		if (!gid) {
            flash.message = "Vous devez s&eacute;l&eacute;ctionner un groupement d'ecritures param&egrave;tr&eacute;"
			flash.messageType='warn'
            redirect(action:critereGroupement)
		} else {
			def g = Groupement.get(new Integer(gid))
			def e = EtatEcriture.get(new Integer(params.get("etat.id")))
			def debut = toDate(params,'debut',params.periode)
			def fin = toDate(params,'fin',params.periode)
			def requete = """
			select ecr
			from Ecriture ecr, TypeEcritureGroupementRel rel 
			where ecr.typeEcriture = rel.typeEcriture
			and rel.groupement = :groupement
			and ecr.etat = :etat
			and ecr.dateMouvement between :debut and :fin  
			 ${SecUtils.maitreCrit()}
			order by ecr.dateMouvement asc
			"""
			def synthese = Ecriture.executeQuery(requete,[groupement:g, etat:e, debut:debut, fin:fin])
			def title="D&eacute;tail  : ${g?.libelle} (${e?.libelle})"
			def dat = new java.text.SimpleDateFormat('dd MMMM yyyy')
			def tip="P&eacute;riode du <b>${dat.format(debut)}</b> au <b>${dat.format(fin)}</b>."
	        if (synthese?.empty || params.format == null || params.format=='html') {
				render(view:'list',model: [ecritureDossierMap:synthese.groupBy{it.dossier ?: "Sans dossier"}, nopaginate:true, title:title, tip:tip])
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
				    pieceComptable : message(code:"xls.header.pieceComptable"),
					acte : message(code:"xls.header.acte"),
					compteBancaire : message(code:"xls.header.compteBancaire")
				]
				ExcelWriter.writeSheet((g.libelle+"_"+duration(debut,fin)+"_"+e).replace('/','_').replace(' ','_').replace('__','_')
				, response, header,toMap(synthese),g.libelle + ' '+e)
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
			compteBancaire:it.compteBancaire,
			commentaire:it.commentaire,
			acte:it instanceof EcritureDossier ? it.acte : null,
			pieceComptable:it.pieceComptable,
			moyenPaiement:it.moyenPaiement,
			dateValeur:it.dateValeur,
			etat:it.etat
			]
			totalDebit+=(it.typeEcriture.credit?new BigDecimal(0):(it.montant ? it.montant: new BigDecimal(0)))
			totalCredit+=(it.typeEcriture.credit?(it.montant ? it.montant: new BigDecimal(0)):new BigDecimal(0))
			}
			display << [typeEcriture:"_"+message(code:"xls.header.solde"),commentaire:totalCredit-totalDebit,credit:totalCredit,debit:totalDebit]
			return display
}

    def delete = {
        def ecr = EcritureDossier.get( params.id )
        if(ecr) {
			def dossier = ecr.dossier
			if (ecr.canBeDeleted()){
				def str = ecr.toString()
				ecr.delete()
				def activity = new Activity(user:session.user, opType:Activity.DELETE, controllerId:Activity.ECRITURE_DOSSIER, entityId:ecr.id)
				activity += ecr
				activity.save()
				flash.message = "[$str] supprim&eacute;e."
			} else {
				flash.message = "${g.message(code:'ecriture.verrouillee')}"
				flash.messageType = "warn"
			}
			if (params.from == "dossier") {
				redirect(controller:'dossier',action:show,id:dossier.id)
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
        def ecritureDossier = EcritureDossier.get( params.id )
	
        if(!ecritureDossier) {
                flash.message = "Ecriture ${params.id} introuvable"
                redirect(action:list)
        }
        else {
			def lovActe = Acte.findAllByDossier(ecritureDossier.dossier,[sort:'dateCreation', order:'desc'])
			def lovTypeEcriture = TypeEcriture.findAllByCategorieEcriture(ecritureDossier.typeEcriture.categorieEcriture)
            return [ ecritureDossier : ecritureDossier, lovActe: lovActe, lovCompte:(ecritureDossier.typeEcriture.affectable ? CompteBancaire.list() : []), lovTypeEcriture:lovTypeEcriture  ]
        }
    }

    def update = {
        def ecritureDossier = EcritureDossier.get( params.id )
        if(ecritureDossier) {
             ecritureDossier.properties = params
			 if (!ecritureDossier.typeEcriture.affectable){
				ecritureDossier.compteBancaire = null
			 }
	def activity = new Activity(user:session.user, opType:Activity.UPDATE, controllerId:Activity.ECRITURE_DOSSIER, entityId:ecritureDossier.id)
				activity << ecritureDossier
            if(!(ecritureDossier.marked && (!ecritureDossier.typeEcriture?.credit || ecritureDossier.typeEcriture?.categorieEcriture?.id != 1)) && ecritureDossier.save()) {
				activity.save()
                flash.message = "[${ecritureDossier}] mise &agrave; jour."
				if (params.from) {
					flash.highlight = [ecritureDossier]
					redirect(controller:params.from,action:show,id:ecritureDossier."${params.from}".id)
				} else {
		            redirect(action:show,id:ecritureDossier.id)
				}
            }
            else {
	            flash.message = "Merci de v&eacute;rifier les donn&eacute;es saisies."
				flash.messageType = "warn"
				def lovDossier = Dossier.list(sort:'dateCreation', order:'desc')
				def lovActe = params["dossier.id"]?Acte.findAllByDossier(Dossier.get(new Integer(params["dossier.id"]))):Acte.list(sort:'numRepertoire', order:'desc')
				def categId = "frais".equals(params.type) ? 1l : ("prix".equals(params.type) ? 2l : 3l)
				def c = TypeEcriture.createCriteria()
				def lovTypeEcriture = c {
					eq("categorieEcriture.id", categId)
				}
                render(view:'edit',model:['ecritureDossier':ecritureDossier, 'lovDossier':lovDossier, 'lovActe':lovActe, 'lovTypeEcriture':lovTypeEcriture,  lovCompte:(ecritureDossier.typeEcriture.affectable ? CompteBancaire.list() : []),categ:categId])
            }
        }
        else {
            flash.message = "Ecriture de Dossier introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def ecritureDossier = new EcritureDossier()
        ecritureDossier.properties = params
		def lovDossier = Dossier.list(sort:'dateCreation', order:'desc')
		def lovActe = params["dossier.id"]?Acte.findAllByDossier(Dossier.get(new Integer(params["dossier.id"]))):Acte.list(sort:'numRepertoire', order:'desc')
		def categId = CategorieEcriture.findByLibelle("frais".equals(params.type) ? "Frais" : ("prix".equals(params.type) ? "Prix" : "Autre"))?.id
		def c = TypeEcriture.createCriteria()
		def lovTypeEcriture = c {
			eq("categorieEcriture.id", categId)
		}
        return ['ecritureDossier':ecritureDossier, 'lovDossier':lovDossier, 'lovActe':lovActe, 'lovTypeEcriture':lovTypeEcriture, categ:categId]
    }
    
	def createManyFrais = {
		def num = new Integer(7)
		def manyFrais = new ArrayList(num)
	    num.times {
	        def frais = new EcritureDossier()
	        frais.properties = params
			manyFrais << frais
		}
		def listeFrais = TypeEcriture.findAllByCategorieEcriture(CategorieEcriture.findByLibelle("Frais"))
		def lovActe = params["dossier.id"]?Acte.findAllByDossier(Dossier.get(new Integer(params["dossier.id"]))):Acte.list(sort:'numRepertoire', order:'desc')
		def lovCompteBancaire = CompteBancaire.list()
        return ['manyFrais':manyFrais,'listeFrais':listeFrais, lovActe:lovActe, 'lovCompteBancaire':lovCompteBancaire]
    }

    def saveMany = {
		def fraisSize= new Integer(params.get('fraisSize'))
		def dossier = Dossier.get(new Integer(params.get('dossier.id')))
		def compteBancaire = null
		try {compteBancaire = CompteBancaire.get(new Integer(params.get('compteBancaire.id')))} catch(e){}
		int added = 0
			try {
				Dossier.withTransaction{
					for (i in 0..fraisSize){
						def ecritureDossier = new EcritureDossier()
						if (params.get('montant'+i)) {
							def montant = new BigDecimal(params.get('montant'+i))
							ecritureDossier.properties = params
							def te = new Integer(params.get('typeEcriture.id'+i))
							if (te) {
								ecritureDossier.typeEcriture = TypeEcriture.get(te)
								ecritureDossier.montant = montant
								ecritureDossier.commentaire = params.get('commentaire'+i)
								ecritureDossier.dossier = dossier
								ecritureDossier.compteBancaire = compteBancaire
								def t = ecritureDossier
								ecritureDossier.save()
								new Activity(user:session.user, opType:Activity.CREATE, controllerId:Activity.ECRITURE_DOSSIER, entityId:ecritureDossier.id).save()
								added++
								flash.highlight = flash.highlight ?: []
								flash.highlight << ecritureDossier
							}
						}
					}
					dossier.save(flush:true)
					if (added > 0) {
						flash.message='Les frais ont &eacute;t&eacute; rajout&eacute;s avec succ&egrave;s.'
					} else {
						flash.messageType = "warn"
						flash.message='Aucun frais n\'a &eacute;t&eacute; rajout&eacute; au dossier.'
					}
				}
			} catch (e){
				flash.message='ERREUR de l\'enregistrement des frais, Merci de v&eacute;rifier les donn&eacute;s saisies.'
				flash.messageType="error"
			}
		redirect(controller:'dossier', action:'show', id:dossier.id)
    }
	
    def save = {
        def ecritureDossier = new EcritureDossier(params)
        if (!(ecritureDossier.marked && (!ecritureDossier.typeEcriture?.credit || ecritureDossier.typeEcriture?.categorieEcriture?.id != 1)) && ecritureDossier.save()) {
			new Activity(user:session.user, opType:Activity.CREATE, controllerId:Activity.ECRITURE_DOSSIER, entityId:ecritureDossier.id).save()
            flash.message = "[${ecritureDossier}] cr&eacute;e dans la base de donn&eacute;e."
			if (params.from) {
				flash.highlight = [ecritureDossier]
				redirect(controller:params.from,action:show,id:ecritureDossier."${params.from}".id)
			} else {
				redirect(action:show,id:ecritureDossier.id)
			}
        } else {
            flash.message = "Merci de v&eacute;rifier les donn&eacute;es saisies."
			flash.messageType = "warn"
			def lovDossier = Dossier.list(sort:'dateCreation', order:'desc')
			def lovActe = params["dossier.id"]?Acte.findAllByDossier(Dossier.get(new Integer(params["dossier.id"]))):Acte.list(sort:'numRepertoire', order:'desc')
			def categId = "frais".equals(params.type) ? 1l : ("prix".equals(params.type) ? 2l : 3l)
			def c = TypeEcriture.createCriteria()
			def lovTypeEcriture = c {
				eq("categorieEcriture.id", categId)
			}
			render(view:'create',model:['ecritureDossier':ecritureDossier, 'lovDossier':lovDossier, 'lovActe':lovActe, 'lovTypeEcriture':lovTypeEcriture, categ:categId])
        }
    }

    def receipt = {
        def ecritureDossier = EcritureDossier.get( params.id )
			new Activity(user:session.user, opType:Activity.RECEIPT, controllerId:Activity.ECRITURE_DOSSIER, entityId:ecritureDossier.id,msg:"<b>Montant</b>:${ParamUtils.format(g,ecritureDossier.montant)}").save()
        render(view:'receipt',model:[ecritureDossier:ecritureDossier])
    }
}
