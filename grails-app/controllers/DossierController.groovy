class DossierController {
	
	def dossierService
	def wordService
    
	static accessControl = {
		permission(perm: new EtudePerm('Dossier', [ 'Liste' ]), only: ['list', 'search', 'lookup'])
		permission(perm: new EtudePerm('Dossier', [ 'Consultation' ]), action: 'show')
        permission(perm: new EtudePerm('Dossier', [ 'Modification' ]), only: [ 'edit', 'update' ])
        permission(perm: new EtudePerm('Dossier', [ 'Creation' ]), only: [ 'create', 'save' ])
        permission(perm: new EtudePerm('Dossier', [ 'Suppression' ]), only: [ 'delete'])
        permission(perm: new EtudePerm('Dossier', [ 'RapportDetail' ]), only: [ 'advSearch'])
        permission(perm: new EtudePerm('Dossier', [ 'ModificationMasse' ]), only: [ 'xlsTemplate','upload','doUpload','export'])
	}
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [index:'POST',delete:'POST', save:'POST', update:'POST', search:'GET', lookup:'GET',doUpload:'POST']
    def fileDate(){new java.text.SimpleDateFormat('ddMMMMyyyy').format(new Date())}
	def lookup = { 
		processParams(params)
        params.max = 10
		def k = ParamUtils.keyword(params.query)
		def addTo = params.addTo ? ParamUtils.class2prop(params.addTo) : null
		def resultats = []
		def filterName = params.find{it.key?.startsWith('filter')}?.key
		def onlyName = params.find{it.key?.startsWith('only')}?.key
		def domainClassName = filterName ? filterName - 'filter' : ""
		def onlyDomainClassName = onlyName ? onlyName - 'only' : ""
		def filter = domainClassName.size() > 0 ? domainClassName[0].toLowerCase()+domainClassName.substring(1) : null
		def only = onlyDomainClassName.size() > 0 ? onlyDomainClassName[0].toLowerCase()+onlyDomainClassName.substring(1) : null
		Long parentId = null
		try {parentId = new Long(params.get(filterName))}catch(e){}
		Long onlyParentId = null
		try {onlyParentId = new Long(params.get(onlyName))}catch(e){}
		if (addTo || (parentId && filter) || (onlyParentId && only)) {
			def parent = (parentId || onlyParentId) ? Dossier.executeQuery("from ${parentId ? domainClassName : onlyDomainClassName} where id = :id",[id:(parentId ?: onlyParentId)]) : []
			parent = parent.empty ? null : parent[0]
			resultats = Dossier.withCriteria{
				and {
					or {
						ilike('libelle',k)
						ilike('numeroDossier',k)
					}
					if (addTo){
						isNull(addTo)
					} else if (filter && parent) {
						or {
							ne(filter,parent)
							isNull(filter)
						}
					} else if (only && parent) {
						eq(only,parent)
					}

				}
				maxResults(params.max.toInteger())
				order(params.sort,params.order)
			}
		} else {
			resultats = Dossier.findAllByLibelleIlikeOrNumeroDossierIlike(k, k, params)
		}
		//Create XML response 
		def mime = ParamUtils.getMime(params)
		render(contentType: mime) { 
			dossiers() { 
				resultats.each { 
					d -> result(){ 
						name(d.libelle) 
						id(d.id) 
						code(d.numeroDossier) 
						date(etude.relativeDate(date:d.dateCreation, plain:true)) 
						icon(d.operation ? 'folderoperation':'folder') 
					}
				} 
			} 
		} 
	} 
    def search = {
		processParams(params)
		def k = ParamUtils.keyword(params.q)
		def resultats = Dossier.withCriteria{
				and {
					or {
						ilike('libelle',k)
						ilike('numeroDossier',k)
					}
				}
				maxResults(params.max.toInteger())
				order(params.sort,params.order)
			}

		def count = Dossier.countByLibelleIlikeOrNumeroDossierIlike(k, k)
		if (count == 1) {
			redirect(action:show, id: resultats.get(0).id)
		} else if (resultats.empty) {
			flash.message= "Aucun dossier ne correspond &agrave; votre crit&egrave;re de recherche [${params.q}]"
			flash.messageType = "warn"
			redirect(action:"list")
		} else {
			flash.message= "R&eacute;sultats de la recherche [${params.q}] :"
			render(view:"list",model:[ dossierList: resultats, 'count':count, paginateParams:params.findAll{it.key in ['typeEcriture','q','etat','max','sort','order']}, sortParams:params.findAll{it.key in ['typeEcriture','q','etat','max','offset']} ])
		}
    }

	void processParams(params){
        if(!params.max)params.max = 18
        else {params.max = new Long(params.max)}
        if(!params.offset)params.offset = 0
        else {params.offset = new Long(params.offset)}
        if (params.format=="xls") {
        	params.remove("max")
        	params.remove("offset")
        }
		if(!params.sort){
			params.sort = "numero"
			params.order = "desc" 
		}
	}
	def maitre(){SecUtils.hasRole('Maitre')}
	def maitreCrit(lbl){maitre()?'':" and (${lbl}.marked is null or ${lbl}.marked = false) "}
	def maitreCrit(){maitreCrit('ecr')}

    def list = {
		//[ dossierList: Dossier.findAll( "from Dossier as d where (d.cloture=:cloture or d.cloture is null) order by d.numero "+params.order,[cloture:false],params) ]
		def filters = ParamUtils.filters(params, ['typeEcriture' : {TypeEcriture.get(it)},
		'minAmount' : {new BigDecimal(it)},  
		'notTag' : {def tags = it.split(',').toList(); Dossier.getAvailableTags().findAll{tag->tag.name in tags}}, 
		'exclude' : {TypeEcriture.get(it)},
		'etat' : {EtatEcriture.get(it)},
		'isNull' : {it.split(',').toList()}
		])
		if (filters.notTag?.empty){filters.remove('notTag')}
		if(!params.sort && (filters.etat || filters.typeEcriture)){
			params.sort = "dateValeur"
			params.order = "desc" 
		}
		processParams(params)
		def k = ParamUtils.keyword(params.q)?.toLowerCase()
		def parent = null
		def ctrlName = null
		if (params.mode == 'select' && params.id && params.addTo) {
			Long parentId = null
			ctrlName = ParamUtils.class2prop(params.addTo)
			try {parentId = new Long(params.id)}catch(e){}
			if (parentId) {
				parent = Bien.executeQuery("from ${params.addTo} where id = :id",[id:parentId])
				parent = parent.empty ? null : parent[0]
			}
		}
			boolean ecrFilterOn = filters.etat || filters.typeEcriture
			def prefix = ecrFilterOn ? "ecr." : ""
			def hql = ecrFilterOn ? "from EcritureDossier ecr" : "from Dossier dossier"
			boolean first = true
			def maxDateValeurOrder = ""
			def queryParams = [:]
			def query = ""
			def countQuery = ""
			if (filters.etat || filters.typeEcriture || params.q || parent || filters.notTag || filters.isNull) {
				hql += " where "
			}
			if (params.q) {
				hql+="${first ? "" : "and "} (lower(${prefix}dossier.libelle) like :keyword or lower(${prefix}dossier.numeroDossier) like :keyword) "
				first = false
				queryParams.keyword = k
			}
			if (parent) {
				hql += "${first ? "" : "and"} (${prefix}dossier.${ctrlName} is null)) "
				first = false
			}
			if (filters.isNull) {
				filters.isNull.each{column->
					hql += "${first ? "" : "and"} (${prefix}dossier.${column} is null) "
					first = false
				}
			}
			if (filters.notTag) {
				hql += "${first ? "" : "and "} (${prefix}dossier.id not in (select tagLink.tagRef from org.grails.taggable.TagLink tagLink where tagLink.tag in (:tagList)))"
				first = false
				queryParams.tagList = filters.notTag
			}
			if (filters.etat || filters.typeEcriture) {
				hql+= first ? "" : "and "
				boolean first2 = true
				if (filters.exclude) {
					hql += "${first2 ? "" : "and "} (ecr.dossier not in (select e.dossier from EcritureDossier e where e.dossier = ecr.dossier and e.typeEcriture = :exclude)) "
					first2 = false
					queryParams.exclude = filters.exclude
				}
				if (filters.etat) {
					hql += "${first2 ? "" : "and"} (ecr.etat = :etat) "
					first2 = false
					queryParams.etat = filters.etat
				}
				if (filters.typeEcriture) {
					hql+="${first2 ? "" : "and"} (ecr.typeEcriture = :typeEcriture) "
					first2 = false
					queryParams.typeEcriture = filters.typeEcriture
					if (filters.minAmount) {
						hql+="${first2 ? "" : "and"} (ecr.montant > :minAmount) "
						first2 = false
						queryParams.minAmount = filters.minAmount
					}
				}
				if (params.sort == 'dateValeur') {
					maxDateValeurOrder+=" order by max(ecr.dateValeur) ${params.order}"
				} else {
					maxDateValeurOrder+=" order by ecr.dossier.${params.sort} ${params.order}"
				}
				def additionalColumn = ""
				if (params.sort && params.sort!= "dateValeur") {
					additionalColumn = ", ecr.dossier.${params.sort}"
				}
				query = "select new map(ecr.dossier as dossier${additionalColumn},max(ecr.dateValeur) as derniere) "+hql+" group by ecr.dossier${additionalColumn}"+maxDateValeurOrder
				countQuery = "select count(distinct ecr.dossier) "+hql
			} else {
				query = hql+" order by dossier.${params.sort} ${params.order}"
				countQuery = "select count(*) "+hql
			}
			println "##############################"
			println query
			println "##############################"
			println queryParams
			println "##############################"
		def dossierList = Dossier.executeQuery(query, queryParams,(params.format == 'xls' ? [:] : [max : params.max, offset : params.offset]))
		def count = Dossier.executeQuery(countQuery, queryParams)[0]
		if (filters.etat || filters.typeEcriture){
			dossierList  = dossierList.collect{it.dossier}
		}
		if (parent && count==0) {
			if (!flash.message) { flash.message = "Aucun dossier n'est disponible."}
			else {flash.message = flash.message}
			redirect(controller:"$ctrlName",action:'show',id:parent.id)
		}
		def dates = [:]
		if (filters.etat || filters.typeEcriture) {
			dossierList.each{dates.put(it, it.ecritures.findAll{
				(filters.typeEcriture ? it.typeEcriture == filters.typeEcriture : true) && (filters.etat ? it.etat == filters.etat : true)
			}.max{ecr->ecr.dateValeur}?.dateValeur)}
		}
		def result = [ hql:query,dossierList: dossierList, count: count, filters: filters, dates:dates, paginateParams:ParamUtils.paginate(params,filters.keySet()), sortParams:ParamUtils.sort(params, filters.keySet()) ]
        if (params.format == null || params.format=='html') {
	        result
		} 	else if (params.format=='xls')  { 
			def header = [
				numeroDossier : message(code:"xls.header.numeroDossier"),
			    libelle : message(code:"xls.header.libelle"),
			    description : message(code:"xls.header.description"),
			    dateCreation : message(code:"xls.header.dateCreation")
			]
			if (filters.etat || filters.typeEcriture) {
				header.derniereEcriture = message(code:"xls.header.derniereEcriture")
			}
			def flatDossierList = result.dossierList.collect{d->
				def record = [numeroDossier:d.numeroDossier,
				libelle:d.libelle,
				description:d.description,
				dateCreation:d.dateCreation
				]
				if (filters.etat || filters.typeEcriture) {
					record.derniereEcriture = dates.get(d)
				}
				record
			}
			ExcelWriter.writeSheets((params.title?.replace('/','-')?.replace(' ','_') ?: "Dossiers")+"_${fileDate()}", response, [header],[flatDossierList],[params.title?.replace('/','-') ?: "Dossiers"])
		}

    }

    def show = {
		def dossier = Dossier.get( params.id )
        if(!dossier) {
            flash.message = "Dossier introuvable avec identifiant ${params.id}"
            flash.messageType = "warn"
            redirect(action:list)
        } else {
		def paiements = new ArrayList()
		def listeFrais = new ArrayList()
		def listePrix = new ArrayList()
		def fraisType = CategorieEcriture.findByLibelle("Frais")
		def prixType = CategorieEcriture.findByLibelle("Prix")
		def ecritures = EcritureDossier.createCriteria().list{
			eq("dossier",dossier)
			order('dateValeur', 'asc')
			order('dateMouvement', 'asc')
			if (!maitre()) {
				or {
					eq('marked',false)
					isNull('marked')
				}
			}
		}
		def actes = Acte.createCriteria().list{
			eq("dossier",dossier)
			order('dateCreation', 'desc')
			order('numRepertoire', 'desc')
		}
		def biens = (dossier.operation != null ? Bien.createCriteria().listDistinct{
			eq("dossier",dossier)
		} : [])
		ecritures.each{ ecr ->
			switch (ecr.typeEcriture.categorieEcriture) {
			    case fraisType:
					listeFrais << ecr
					break
			    case prixType:
					listePrix << ecr
					break
			    default:
					break
			}
		}
        if (params.format == null || params.format=='html') {
			def ppe = TypeEcriture.get(Setting.syssetting('id.pmt.pret.engagement'))
			def data = [ dossier : dossier, listeFrais: listeFrais, listePrix: listePrix, actes: actes, biens : biens,ppe:ppe]
			if (params.preview) {                
				render(view:'preview',model:data)
			} else {
				return 	data
			}
		} 	else if (params.format=='xls')  { 
			def header = [
				typeEcriture : message(code:"xls.header.typeEcriture"),
				commentaire : message(code:"xls.header.commentaire"),
			    debit : message(code:"xls.header.debit"),
			    credit : message(code:"xls.header.credit"),
			    dateValeur : message(code:"xls.header.dateValeur"),
			    dateMouvement : message(code:"xls.header.dateMouvement"),
			    etat : message(code:"xls.header.etat"),
			    moyenPaiement : message(code:"xls.header.moyenPaiement"),
			    pieceComptable : message(code:"xls.header.pieceComptable"),
				acte : message(code:"xls.header.acte"),
				compteBancaire : message(code:"xls.header.compteBancaire")
			]
			ExcelWriter.writeSheets("Fiche_comptable_"+dossier.toString().replace('/','-').replace(' ','_').replace('__','_')
			+"_${fileDate()}", response, [header,header],[toMap(listeFrais),toMap(listePrix)],["Frais","Prix"])
		} 	else if (params.format=='facture')  { 
			def debitFrais = listeFrais.findAll{it.montant && !it.typeEcriture.credit}
			if (debitFrais.montant.sum()) {
				wordService.toFacture([ dossier : dossier, filename:"Facture_"+dossier.toString().replace('/','-').replace(' ','_').replace('__','_')
				+"_${fileDate()}", listeFrais: debitFrais,response:response])
				} else {
					flash.messageType = 'warn'
		            flash.message = "Le dossier ne contient pas d'&eacute;critures frais en d&eacute;bit."
		            redirect(action:show, id:dossier.id)
				}
		} 	else if (params.format=='ppe')  { 
			def ppe = TypeEcriture.get(Setting.syssetting('id.pmt.pret.engagement'))
			def debitPpe = listePrix.findAll{it.typeEcriture == ppe && !it.typeEcriture.credit}
			if (debitPpe.montant.sum()) {
				wordService.toPpe([ dossier : dossier, filename:"PPE_"+dossier.toString().replace('/','-').replace(' ','_').replace('__','_')
				+"_${fileDate()}", listePpe: debitPpe,response:response])
				} else {
					flash.messageType = 'warn'
		            flash.message = "Le dossier ne contient pas d'&eacute;critures paiements pret engagement."
		            redirect(action:show, id:dossier.id)
				}
		}
		}


    }

def toMap(results){
			def display = []
			def totalDebit=new BigDecimal(0)
			def totalCredit=new BigDecimal(0)
			results.each{display << [typeEcriture:it.typeEcriture?.id + " - " +it.typeEcriture?.libelle,
			dossier:it.dossier,
			debit:(it.typeEcriture.credit?null:it.montant),
			credit:(it.typeEcriture.credit?it.montant:null),
			dateMouvement:it.dateMouvement,
			commentaire:it.commentaire,
			acte:it.acte,
			pieceComptable:it.pieceComptable,
			compteBancaire:it.compteBancaire,
			moyenPaiement:it.moyenPaiement,
			dateValeur:it.dateValeur,
			etat:it.etat]
			totalDebit+=(it.typeEcriture.credit?new BigDecimal(0):(it.montant ? it.montant: new BigDecimal(0)))
			totalCredit+=(it.typeEcriture.credit?(it.montant ? it.montant: new BigDecimal(0)):new BigDecimal(0))
			}
			display << [typeEcriture:"_"+message(code:"xls.header.solde"),commentaire:totalCredit-totalDebit,credit:totalCredit,debit:totalDebit]
			return display
}
    def delete = {
        def dossier = Dossier.get( params.id )
        if(dossier) {
            if (dossier.ecritures.empty) {
				dossier.removeAllTags()
				dossier.delete()
				new Activity(user:session.user, opType:Activity.DELETE, controllerId:Activity.DOSSIER, entityId:dossier.id, msg:"Dossier : "+dossier).save()
	            flash.message = "Dossier ${dossier} supprim&eacute;."
	            redirect(action:list)
			} else {
				flash.messageType = 'warn'
	            flash.message = "Le dossier ne peut pas &ecirc;tre supprim&eacute; tant qu'il contient des &eacute;critures."
	            redirect(action:show, id:dossier.id)
			}
        }
        else {
			flash.messageType = 'warn'
            flash.message = "Dossier introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def dossier = Dossier.get( params.id )
        if(!dossier) {
                flash.message = "Dossier introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }  else {
			if (params.nomodele) {
				dossier.modele = false
				def nomModele = dossier.nomModele
				dossier.nomModele = null
				dossier.keepMontant = null
				dossier.etatModele = null
				dossier.save()
                flash.message = "Le mod&egrave;le ${nomModele} &agrave; &eacute;t&eacute; supprim&eacute;."
                redirect(action:show,id:dossier.id)
			} else if (params.modele) {
				return [ dossier : dossier, nomModele : (dossier.nomModele ?: "MODELE BASE sur " + dossier.libelle), modele : true ]
			} else {
				return [ dossier : dossier ]
			}
        }
    }

    def update = {
        def dossier = Dossier.get( params.id )
        if(dossier) {
             dossier.properties = params
            if(dossier.save()) {
				dossier.updateTags(params)
				new Activity(user:session.user, opType:Activity.UPDATE, controllerId:Activity.DOSSIER, entityId:dossier.id).save()
                flash.message = "Dossier ${dossier.numeroDossier} mis &agrave; jour."
                redirect(action:show,id:dossier.id)
            }
            else {
                render(view:'edit',model:[dossier:dossier])
            }
        }
        else {
            flash.message = "Dossier introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def dossier = new Dossier()
        dossier.properties = params
        return ['dossier':dossier, modeles:Dossier.findAllByModele(true)]
    }

    def save = {
        def dossier = new Dossier()
        dossier.properties = params
        if(dossier.save(flush:true)) {
			dossier.refresh()
			new Activity(user:session.user, opType:Activity.CREATE, controllerId:Activity.DOSSIER, entityId:dossier.id).save()
			if (params.modeleId) {
				Dossier.withTransaction {
					def template = null
					try{template=Dossier.get( params.modeleId )}catch(e){}
					if (template) {
						def ecritures = EcritureDossier.createCriteria().list{
							eq("dossier",template)
							order('dateValeur', 'asc')
							order('dateMouvement', 'asc')
							if (!maitre()) {
								or {
									eq('marked',false)
									isNull('marked')
								}
							}
						}
						
						ecritures.each{ecr ->
								def ecritureDossier = new EcritureDossier(ecr.properties)
								ecritureDossier.dossier = dossier
								ecritureDossier.commentaire = null
								ecritureDossier.pieceComptable = null
								ecritureDossier.compteBancaire = null
								if (template.keepMontant==false) ecritureDossier.montant = null
								ecritureDossier.dateValeur = ParamUtils.newDate()
								ecritureDossier.dateMouvement = ecritureDossier.dateValeur + 2
								ecritureDossier.etat = template.etatModele ?: ecritureDossier.etat
								ecritureDossier.save()
								new Activity(user:session.user, opType:Activity.CREATE, controllerId:Activity.ECRITURE_DOSSIER, entityId:ecritureDossier.id).save()
						}
					}
				}
			}
			dossier.updateTags(params)
            flash.message = "Dossier ${dossier.numeroDossier} cr&eacute;e dans la base de donn&eacute;e."
            redirect(action:show,id:dossier.id)
        }
        else {
            render(view:'create',model:[dossier:dossier, modeles:Dossier.findAllByModele(true)])
        }
    }
	
    def advSearch = {
        [debut:ParamUtils.newDate()-180, fin:ParamUtils.newDate()+3,operation:params.'operation.id'?Operation.get(params.'operation.id'):null]
    }
    def results = {
	        if(params.format=='html' && !params.max)params.max = 18
			if(!params.sort){
				params.sort = "numero"
				params.order = "desc" 
			}
			def debut = ParamUtils.toDate(params,'debut')
			def fin = ParamUtils.toDate(params,'fin')
			def args = [debut:debut,fin:fin]
			processParams(params)
			def keyw = ParamUtils.keyword(params.q)
			def resultats = Dossier.withCriteria(){
				and {
					between("dateCreation", debut, fin)
					or {
						ilike('numeroDossier', keyw)
						ilike('libelle', keyw)
						ilike('description', keyw)
					}
					if (params.'operation.id' && params.'operation.id'!='null') {
						eq('operation',Operation.get(params.'operation.id'))
					}
				}
				if(params.format == 'html') {
					maxResults(params.max.toInteger())
					firstResult(params.offset?params.offset.toInteger():0)
				}
				order(params.sort,params.order)
			}
			def count = Dossier.createCriteria().get{
				and {
					between("dateCreation", debut, fin)
					if (params.q) {
						or {
							ilike('numeroDossier', keyw)
							ilike('libelle', keyw)
							ilike('description', keyw)
						}
					}
					if (params.'operation.id' && params.'operation.id'!='null') {
						eq('operation',Operation.get(params.'operation.id'))
					}
				}
				if(params.format == 'html') {
					maxResults(params.max.toInteger())
					firstResult(params.offset?params.offset.toInteger():0)
				}
				projections { 
					countDistinct('id') 
				} 
			}
			if (resultats.empty) {
				flash.message= "Aucun dossier ne correspond &agrave; votre crit&egrave;re de recherche [${params.q}]"
				flash.messageType = "warn"
				redirect(action:"list", count: Dossier.count())
			} else {
			def header=[:]
			if (params.'operation.id') header.bien = message(code:"xls.header.bien")
			def dynTypeEcriture = TypeEcriture.withCriteria{'in'('afficheDansOperation', [TypeEcriture.AFF_XLS,TypeEcriture.AFF_PAGE_OP_XLS])}
			def headerMap = [
				numeroDossier : message(code:"xls.header.numeroDossier"),
				libelle : message(code:"xls.header.libelle")
			]
			dynTypeEcriture.eachWithIndex{lib,i->
				headerMap.put('typeEcriture'+i, lib.libelle)
				headerMap.put('date.typeEcriture'+i, "Date "+lib.libelle)
			}
			headerMap.put('soldeFrais', message(code:"xls.header.soldeFrais"))
			headerMap.put('soldePrix', message(code:"xls.header.soldePrix"))
			header += headerMap
			println toListMap(resultats)
			def safeNomFeuille=(params.'operation.id' && params.'operation.id'!='null'? 
				Operation.get(params.'operation.id')?.toString().replace('/','_').replace(' ','_').replace('__','_') : "dossiers")+
					"_"+(ParamUtils.duration(debut,fin)).replace('/','_').replace(' ','_').replace('__','_')
			ExcelWriter.writeSheets(safeNomFeuille, response, [header],[toListMap(resultats)],[(params.'operation.id' && params.'operation.id'!='null'? Operation.get(params.'operation.id')?.toString():message(code:"search.results"))])
			}
	}
def toListMap(res){
			def display = []
			def dynTypeEcriture = TypeEcriture.withCriteria{'in'('afficheDansOperation', [TypeEcriture.AFF_XLS,TypeEcriture.AFF_PAGE_OP_XLS])}
			res.each{it->
				//For each dossier
				def soldeFrais = new BigDecimal(0)
				def soldePrix = new BigDecimal(0)
				boolean maitre = SecUtils.maitre()
				def ecritureMap = [:]
				dynTypeEcriture.each{lib->
					ecritureMap.put(lib, new BigDecimal(0))
				}
				def allEcrituresDossier = EcritureDossier.findAllByDossier(it)
				allEcrituresDossier.each{ecr->
					if (ecr.montant && (maitre || !ecr.marked) && (!ecr.typeEcriture.credit || (ecr.typeEcriture.credit && ecr.etat.id == 2))) {
						def inc = ecr.montant
						def lib = ecr.typeEcriture
						def showLibelle = dynTypeEcriture.contains(ecr.typeEcriture)
						if (showLibelle) ecritureMap.put(lib, ecritureMap.get(lib) + inc)
						if (!ecr.typeEcriture.credit) inc *= new BigDecimal(-1)
						if (ecr.typeEcriture.categorieEcriture.id==1) {
							soldeFrais += inc
						} else {
							soldePrix += inc
						}
					}
				}
				def entry = [
				numeroDossier:it.numeroDossier,
				libelle:it.libelle,soldePrix:soldePrix,soldeFrais:soldeFrais]
				if (it.operation) {
					def biens = Bien.findAllByDossier(it)
					entry.bien=''
					int idx = 0
					biens.each{bien-> entry.bien += "${(idx++ > 0 ? '\n' : '')}${bien.libelle}"}
				}
				dynTypeEcriture.eachWithIndex{lib,i->
					entry.put('typeEcriture'+i,ecritureMap.get(lib))
					entry.put('date.typeEcriture'+i,allEcrituresDossier.findAll{it.typeEcriture==lib}?.max{it.dateMouvement}?.dateMouvement)
				}
				display << entry
			}
			return display
}
    def addManyBien = {
        def dossier = Dossier.get( params['dossier.id'] )
		def listSize = new Integer(params.listSize)
		for (i in 0..(listSize-1)) {
			if (params.get("check"+i)){
				def bien = Bien.get(params.get("id"+i))
				try {
					bien.dossier = dossier
					if (bien.save()) {
						if (!flash.message) flash.message = "Bien affect&eacute; : <br/>"
						def msg = "${bien.libelle}"
						flash.message = flash.message + msg + "<br/>"
					}
				} catch (e){
					def msg = "ECHEC : ${bien}"
					if (!flash.messageError) flash.messageError = ""
					flash.messageError += msg + "<br/>"
				}
			}
		}
        redirect(action:(params.from ? "show" : "list"), controller:(params.from ?: "bien"),params:['mode':'select','addTo':'Dossier','id':(params.from == 'operation' ? dossier.operation.id : params.'dossier.id')])
    }
	def listeEcritures = {
		Long id = null;try{id = new Long(params.id)}catch(ex){}
		def dossier = id ? Dossier.get(id) :null
		def result = ""
		if (dossier) {
		def fraisType = CategorieEcriture.findByLibelle("Frais")
		def prixType = CategorieEcriture.findByLibelle("Prix")
		def ecritures = EcritureDossier.createCriteria().list{
			eq("dossier",dossier)
			order('dateValeur', 'asc')
			order('dateMouvement', 'asc')
			if (!maitre()) {
				or {
					eq('marked',false)
					isNull('marked')
				}
			}
		}
		def frais=[]
		def prix = []
		ecritures.each{ ecr ->
			switch (ecr.typeEcriture.categorieEcriture) {
			    case fraisType:
					frais << ecr
					break
			    case prixType:
					prix << ecr
					break
			    default:
					break
			}
		}
		result+="<tr><td colspan='2'><a href='#' class='hidden' id='hideButton' onClick='\$(\"detail\").hide();\$(\"showButton\").show();\$(\"showButton\").className=\"\";\$(\"hideButton\").hide();Modalbox.resize(0,-2000);'>Masquer l'aper&ccedil;u</a><a href='#' id='showButton' onClick='\$(\"detail\").show();\$(\"hideButton\").show();\$(\"hideButton\").className=\"\";\$(\"detail\").className=\"\";\$(\"showButton\").hide();Modalbox.resize(0,-2000);'>Afficher l'aper&ccedil;u</a></td></tr>"
		result+="<tr><td colspan='2'><table id='detail' class='hidden'><tr><td><b>Frais:</b></td></tr>"
		def i=0
		frais.each{ecr->
			result+="<tr class='frais${(i % 2) == 0 ? 'odd' : 'even'}'><td><b>${ecr.typeEcriture}</b>${dossier.keepMontant ? ' : '+(ecr.montant ?: ''): ''} <i>${dossier.etatModele ?: ecr.etat }</i></td></tr>"
			i++
		}
		i=0
		result+="<tr><td><b>Prix:</b></td></tr>"
		prix.each{ecr->
			result+="<tr class='prix${(i % 2) == 0 ? 'odd' : 'even'}'><td><b>${ecr.typeEcriture}</b>${dossier.keepMontant ? ' : '+(ecr.montant ?: ''): ''} <i>${dossier.etatModele ?: ecr.etat}</i></td></tr>"
			i++
		}
		}
		result+="</table></td></tr>"
		render result
	}
	def listIphone2 = {this.listIphone()}

    def upload = {
    }

	def xlsTemplate = {
		def template = servletContext.getResourceAsStream( "/WEB-INF/ImportDossiers.xls")
		dossierService.xlsTemplate(
			[response:response,
			clients:Client.list(),
			operations:Operation.list(),
			etats:EtatEcriture.list(),
			modePaiements:MoyenPaiement.list(),
			compteBancaires:CompteBancaire.list(),
			frais:TypeEcriture.findAllByCategorieEcriture(CategorieEcriture.findByLibelle("Frais")),
			prix:TypeEcriture.findAllByCategorieEcriture(CategorieEcriture.findByLibelle("Prix")),
			templateInputStream:template]
		)
	}
	def doUpload = {
		def f = request.getFile('myFile')
		if(!f.empty) {
			def xlsData = [:]
			try {
				xlsData = dossierService.xls2Dossiers(f)
				def dossierMap = xlsData.dossiers
				def actesMap = xlsData.actes
				def fraisMap = xlsData.frais
				def prixMap = xlsData.prix
				def injected = dossierMap.dossiers + actesMap.actes + fraisMap.frais + prixMap.prix
				def rejets = dossierMap.rejets + actesMap.rejets + fraisMap.rejets + prixMap.rejets
				def handleRejects = {					
					def rejects = [:]
					if (dossierMap.rejets) {rejects.Dossiers=dossierMap.rejets}
					if (actesMap.rejets) {rejects.Actes=actesMap.rejets}
					if (fraisMap.rejets) {rejects.Frais=fraisMap.rejets}
					if (prixMap.rejets) {rejects.Prix=prixMap.rejets}
					return [rejects:rejects,lineNumbers:xlsData.lineNumbers]
				}
				if (!rejets?.empty) {
					render(view:'upload',model:handleRejects())
				} else if (!dossierMap.dossiers?.empty) {
					Dossier.withTransaction{status ->
						new ArrayList(dossierMap.dossiers).each{dossier->
							if(dossier.save()) {
								new Activity(user:session.user, opType:Activity.IMPORT, controllerId:Activity.DOSSIER, entityId:dossier.id).save()
							} else{
								dossierMap.dossiers.remove(dossier)
								dossierMap.rejets << dossier
							}
						}
						new ArrayList(actesMap.actes).each{acte->
							if(acte.save()) {
								new Activity(user:session.user, opType:Activity.IMPORT, controllerId:Activity.ACTE, entityId:acte.id).save()
							} else{
								actesMap.actes.remove(acte)
								actesMap.rejets << acte
							}
						}
						new ArrayList(fraisMap.frais).each{ecritureDossier->
							if(ecritureDossier.save()) {
								new Activity(user:session.user, opType:Activity.IMPORT, controllerId:Activity.ECRITURE_DOSSIER, entityId:ecritureDossier.id).save()
							} else{
								fraisMap.frais.remove(ecritureDossier)
								fraisMap.rejets << ecritureDossier
							}
						}
						new ArrayList(prixMap.prix).each{ecritureDossier->
							if(ecritureDossier.save()) {
								new Activity(user:session.user, opType:Activity.IMPORT, controllerId:Activity.ECRITURE_DOSSIER, entityId:ecritureDossier.id).save()
							} else{
								prixMap.prix.remove(ecritureDossier)
								prixMap.rejets << ecritureDossier
							}
						}
						rejets = dossierMap.rejets + actesMap.rejets + fraisMap.rejets + prixMap.rejets
						if (!rejets.empty){
							status.setRollbackOnly()
							log.warn("Rollback import de dossiers [${f.originalFilename}]")
						}
					}
					if (!rejets.empty){
						render(view:'upload',model:handleRejects())
					} else {
						log.info("Import de dossiers reussi [${f.originalFilename}]")
						flash.message = "Fichier import&eacute; avec succ&egrave;s<br/>"
						redirect(action:'upload')
					}
				} else {
					flash.message = 'Le fichier est vide'
					flash.messageType="warn"
					redirect(action:upload)
				}
			} catch (e){
				log.error("Dossier import error :${f.originalFilename}", e)
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
