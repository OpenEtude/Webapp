import org.springframework.beans.factory.InitializingBean

class DossierService implements InitializingBean {
    static transactional = true
	
	def grailsApplication
	
    def setting

    void afterPropertiesSet() {
        this.setting = grailsApplication.config.setting
    }	
	
	def saveManyFrais(Dossier dossier, List manyFrais){
		for (frais in manyFrais) {
			dossier.addToEcritures(frais).save()
		}
		dossier.save()
	}
	def xls2Dossiers(file) {
		def clientMap = ['clients':[], 'rejets':[]]
		def operationMap = ['operations':[], 'rejets':[]]
		def bienMap = ['biens':[], 'rejets':[]]
		def dossierMap = ['dossiers':[], 'rejets':[]]
		def actesMap = ['actes':[], 'rejets':[]]
		def fraisMap = ['frais':[], 'rejets':[]]
		def prixMap = ['prix':[], 'rejets':[]]
		def lineNumberMap = [:]
		def xls = new SimpleXlsSlurper(file.inputStream)
		def fetch = {xls.rowCount > 1 ? (2..(xls.rowCount)) : []}
		def load = {domain,label->label ? domain.get(new Long(label.split(' - ')[0])) : null}
		def find = {domain,label,finder->label ? domain."${finder}"(label) : null}

		xls.sheets("Clients")
		fetch().each{rowNum->
			def client = new Client(
			nom : xls.valueAt("'Clients'!A${rowNum}"),
			telephone : xls.valueAt("'Clients'!B${rowNum}"),
			mobile : xls.valueAt("'Clients'!C${rowNum}"),
			fax : xls.valueAt("'Clients'!D${rowNum}"),
			email : xls.valueAt("'Clients'!E${rowNum}"),
			addresse1 : xls.valueAt("'Clients'!F${rowNum}"),
			addresse2 : xls.valueAt("'Clients'!G${rowNum}"),
			ville : xls.valueAt("'Clients'!H${rowNum}"),
			commentaire : xls.valueAt("'Clients'!I${rowNum}"),
			civilite : load(Civilite,xls.valueAt("'Clients'!J${rowNum}")),
			prenom : xls.valueAt("'Clients'!K${rowNum}"),
			numIdentite : xls.valueAt("'Clients'!L${rowNum}"),
			pieceIdentite : load(Civilite,xls.valueAt("'Clients'!M${rowNum}")))
			if (client.validate()){
				clientMap.clients << client
			} else {
				clientMap.rejets << client
			}
			lineNumberMap.put(client,rowNum)
		}
		xls.sheets("Operations")
		fetch().each{rowNum->
			def operation = new Operation(
			client : load(Client,xls.valueAt("'Operations'!A${rowNum}")),
			libelle : xls.valueAt("'Operations'!B${rowNum}"),
			description : xls.valueAt("'Operations'!C${rowNum}"),
			dateCreation : xls.valueAt("'Operations'!D${rowNum}") ?: new Date())
			if (operation.validate()){
				operationMap.operations << operation
			} else {
				operationMap.rejets << operation
			}
			lineNumberMap.put(operation,rowNum)
		}
		xls.sheets("Dossiers")
		fetch().each{rowNum->
			def dossier = new Dossier(
			operation : load(Operation,xls.valueAt("'Dossiers'!A${rowNum}")),
			numeroDossier : xls.valueAt("'Dossiers'!B${rowNum}"),
			libelle : xls.valueAt("'Dossiers'!C${rowNum}"),
			description : xls.valueAt("'Dossiers'!D${rowNum}"),
			dateCreation : xls.valueAt("'Dossiers'!E${rowNum}") ?: new Date())
			if (dossier.validate()){
				dossierMap.dossiers << dossier
			} else {
				dossierMap.rejets << dossier
			}
			lineNumberMap.put(dossier,rowNum)
		}
		xls.sheets("Actes")
		fetch().each{rowNum->
			def dossier = dossierMap.dossiers.find{it.numeroDossier == xls.valueAt("'Actes'!A${rowNum}")}
			def acte = new Acte(dossier : dossier,
			numRepertoire : xls.valueAt("'Actes'!B${rowNum}"),
			libelle : xls.valueAt("'Actes'!C${rowNum}"),
			dateCreation : xls.valueAt("'Actes'!D${rowNum}") ?: new Date())
			if (acte.validate()){
				actesMap.actes << acte
			} else {
				actesMap.rejets << acte
			}
			lineNumberMap.put(acte,rowNum)
		}
		xls.sheets("Biens")
		fetch().each{rowNum->
			def dossier = dossierMap.dossiers.find{it.numeroDossier == xls.valueAt("'Biens'!A${rowNum}")}
			def acte = new Bien(dossier : dossier,
			numRepertoire : xls.valueAt("'Actes'!B${rowNum}"),
			libelle : xls.valueAt("'Actes'!C${rowNum}"),
			dateCreation : xls.valueAt("'Actes'!D${rowNum}") ?: new Date())
			if (acte.validate()){
				actesMap.actes << acte
			} else {
				actesMap.rejets << acte
			}
			lineNumberMap.put(acte,rowNum)
		}
		def defaultEtat = EtatEcriture.findByLibelle("En Cours")
		def defaultMoyenPaiement = MoyenPaiement.findByLibelle("Ch\u00E8que")
		xls.sheets("Frais")
		fetch().each{rowNum->
			def dossier = dossierMap.dossiers.find{it.numeroDossier == xls.valueAt("'Frais'!A${rowNum}")}
			def acte = actesMap.actes.find{it.numRepertoire == xls.valueAt("'Frais'!I${rowNum}")}
			def frais = new EcritureDossier(
				dossier : dossier, 
				typeEcriture : load(TypeEcriture,xls.valueAt("'Frais'!B${rowNum}")),
				commentaire : xls.valueAt("'Frais'!C${rowNum}"),
				pieceComptable : xls.valueAt("'Frais'!D${rowNum}"),
				montant : xls.valueAt("'Frais'!E${rowNum}"),
				etat : load(EtatEcriture,xls.valueAt("'Frais'!F${rowNum}")) ?: defaultEtat,
				moyenPaiement : load(MoyenPaiement,xls.valueAt("'Frais'!G${rowNum}")) ?: defaultMoyenPaiement,
				compteBancaire : load(CompteBancaire,xls.valueAt("'Frais'!H${rowNum}")),
				acte : acte,
				dateValeur : xls.valueAt("'Frais'!J${rowNum}") ?: new Date(),
				dateMouvement : xls.valueAt("'Frais'!K${rowNum}") ?: new Date() + 2
				)
			
			if (frais.validate()){
				fraisMap.frais << frais
			} else {
				fraisMap.rejets << frais
			}
			lineNumberMap.put(frais,rowNum)
		}
		xls.sheets("Prix")
		fetch().each{rowNum->
			def dossier = dossierMap.dossiers.find{it.numeroDossier == xls.valueAt("'Prix'!A${rowNum}")}
			def acte = actesMap.actes.find{it.numRepertoire == xls.valueAt("'Prix'!I${rowNum}")}
			def prix = new EcritureDossier(
				dossier : dossier, 
				typeEcriture : load(TypeEcriture,xls.valueAt("'Prix'!B${rowNum}")),
				commentaire : xls.valueAt("'Prix'!C${rowNum}"),
				pieceComptable : xls.valueAt("'Prix'!D${rowNum}"),
				montant : xls.valueAt("'Prix'!E${rowNum}"),
				etat : load(EtatEcriture,xls.valueAt("'Prix'!F${rowNum}")) ?: defaultEtat,
				moyenPaiement : load(MoyenPaiement,xls.valueAt("'Prix'!G${rowNum}")) ?: defaultMoyenPaiement,
				compteBancaire : load(CompteBancaire,xls.valueAt("'Prix'!H${rowNum}")),
				acte : acte,
				dateValeur : xls.valueAt("'Prix'!J${rowNum}") ?: new Date(),
				dateMouvement : xls.valueAt("'Prix'!K${rowNum}") ?: new Date() + 2
				)
			
			if (prix.validate()){
				prixMap.prix << prix
			} else {
				prixMap.rejets << prix
			}
			lineNumberMap.put(prix,rowNum)
		}
		return [dossiers : dossierMap, actes : actesMap, frais: fraisMap, prix : prixMap,lineNumbers:lineNumberMap]
	}
	def xlsTemplate(args) {
		def response = args.response
		response.setHeader("Content-disposition", "attachment; filename=ImportDossiers.xls")
		response.contentType = "application/vnd.ms-excel"
		def lovIndex = 1
		def nextNum = {def first = "'LOV'!\$A\$${lovIndex}";lovIndex += args["${it}"]?.size()-1;def result="${first}:\$A\$${lovIndex}";lovIndex++;result.toString()}
		def col = {"${it}2:${it}65536".toString()}
		def value = {"\$${it}\$2:\$${it}\$65536".toString()}
		def clientsValidation = {[:]}
		def operationsValidation = {args.clients.empty ? [:] : [(col("A")):nextNum('clients')]}
		def dossiersValidation = {args.operations.empty ? [:] : [(col("A")):nextNum('operations')]}
		def compteBancairesValidation = {args.compteBancaires.empty ? [:] : [(col("H")):nextNum('compteBancaires')]}
		def workbook = new SimpleXlsBuilder().workbook(
			templateInputStream:args.templateInputStream
		) {
			sheet(name:"LOV",hidden:true){			
				args.frais.each{row(0:String.valueOf(it))}
				args.etats.each{row(0:"${it.id} - ${it.libelle}")}
				args.modePaiements.each{row(0:"${it.id} - ${it.libelle}")}
				args.prix.each{row(0:String.valueOf(it))}
				args.etats.each{row(0:"${it.id} - ${it.libelle}")}
				args.modePaiements.each{row(0:"${it.id} - ${it.libelle}")}
			}
			sheet(name:"Clients",validation:clientsValidation()){
				row()
				args.clients.each{
					row(0:it.nom,1:it.telephone,2:it.mobile,
					3:it.fax,4:it.email,5:it.addresse1,6:it.addresse2,
					7:it.ville,8:it.commentaire,9:"${it.civilite?.id} - ${it.civilite}",10:it.numIdentite,11:"${it.pieceIdentite?.id} - ${it.pieceIdentite}")
				}
			}
			sheet(name:"Operations",validation:operationsValidation()){
				row()
				args.operations.each{
					row(0:"${it.client?.id} - ${it.client?.nom}",1:it.libelle,2:it.description,3:it.dateCreation)
				}
			}
			sheet(name:"Dossiers",validation:dossiersValidation()){}
			sheet(name:"Actes",validation:[(col("A")):"Dossiers!${value('B')}"]){}
			sheet(name:"Biens",validation:[(col("A")):"Operations!${value('B')}",(col("B")):"Dossiers!${value('B')}"]){}
			sheet(name:"Frais", validation:[(col("A")):"Dossiers!${value('B')}", (col("I")):"Actes!${value('B')}", (col("B")):nextNum('frais'), (col("F")):nextNum('etats'), (col("G")):nextNum('modePaiements')]+compteBancairesValidation()){}
			sheet(name:"Prix", validation:[(col("A")):"Dossiers!${value('B')}", (col("I")):"Actes!${value('B')}", (col("B")):nextNum('prix'), (col("F")):nextNum('etats'), (col("G")):nextNum('modePaiements')]+compteBancairesValidation()){}
		}
		workbook.saveToOutput(response.outputStream,false)
	}
	private buildSheet(builder,entity,name,mapping){
		xls.sheets("${name}")
		fetch().each{rowNum->
			def object = entity.getClass().newInstance(
			operation : load(Operation,xls.valueAt("'Dossiers'!A${rowNum}")),
			numeroDossier : xls.valueAt("'Dossiers'!B${rowNum}"),
			libelle : xls.valueAt("'Dossiers'!C${rowNum}"),
			description : xls.valueAt("'Dossiers'!D${rowNum}"),
			dateCreation : xls.valueAt("'Dossiers'!E${rowNum}") ?: new Date())
			if (dossier.validate()){
				dossierMap.dossiers << dossier
			} else {
				dossierMap.rejets << dossier
			}
			lineNumberMap.put(dossier,rowNum)
		}
	}
}
