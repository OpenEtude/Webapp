import org.apache.commons.codec.digest.DigestUtils

class DevelopmentBootStrap {
	BootStrapService bootStrapService
	def init = { servletContext ->
		if (true) return ""
		environments {
			development {
				println ">>>>>>>>>>>>>>>>>>>>>>>>>DEVELOPMENT TEST DATA"
				try {
					def maitreRole = bootStrapService.roleDef("Maitre")
					def comptableRole = bootStrapService.roleDef("Comptable")
					def stagiaireRole = bootStrapService.roleDef('Stagiaire')
					def secretaireRole = bootStrapService.roleDef('Secretaire')
					def technicienRole = bootStrapService.roleDef('Technicien')
					def auditeurRole = bootStrapService.roleDef('Auditeur')
					def visiteurRole = bootStrapService.roleDef('Visiteur')
					new CompteBancaire(libelle: "CAM").save()
					new CompteBancaire(libelle: "CIH").save()
					new CompteBancaire(libelle: "BMCE").save()
					new CompteBancaire(libelle: "ATTIJARI").save()
					new Client(nom: "Promoteur 1", civilite: Civilite.get(1), pieceIdentite: PieceIdentite.get(1)).save()
					new Client(nom: "Promoteur 2", civilite: Civilite.get(1), pieceIdentite: PieceIdentite.get(1)).save()
					for (int i in (1..3)) {
						def op = new Operation(libelle: "Operation $i", client: Client.get(1 + (i % 2)), dateCreation: new Date() - i)
						if (op.save()) {
							op.refresh()
							new Bien(operation: op, libelle: "7${i}8${i}/${i}3A", dossier: (Dossier.get(2 + (i % 2))), typeDeBien: TypeDeBien.findByLibelle("Appartement")).save()
						} else {
							op.errors.allErrors.each {
								log.error("Unable to create operation [${op}]\n $i \n ")
							}
						}
					}
					//['En Cours',"Valid\u00E9e"].each{et-> new EtatEcriture(libelle: et).save(flush:true)}
					def comptable = new JsecUser(username: 'ct', passwordHash: DigestUtils.shaHex('ct'))
					comptable.save()
					new JsecUserRoleRel(user: comptable, role: comptableRole).save()
					def stagiare = new JsecUser(username: 'st', passwordHash: DigestUtils.shaHex('st'))
					stagiare.save()
					new JsecUserRoleRel(user: stagiare, role: stagiaireRole).save()
					def secretaire = new JsecUser(username: 'sc', passwordHash: DigestUtils.shaHex('sc'))
					secretaire.save()
					new JsecUserRoleRel(user: secretaire, role: secretaireRole).save()
					def cih = CompteBancaire.findByLibelle('CIH')
					new Dossier(numeroDossier: "01/45", libelle: 'Dossier test 1', description: 'description 1', dateCreation: new Date()).save()
					new Dossier(numeroDossier: "01/47", libelle: 'Dossier test 2', description: 'description 2', dateCreation: new Date(), operation: Operation.get(3)).save()
					new Dossier(numeroDossier: "01/48", libelle: 'Dossier test 3', description: 'description 3', dateCreation: new Date(), operation: Operation.get(2)).save()
					new Dossier(numeroDossier: "01/49", libelle: 'Dossier test 4', description: 'description 4', dateCreation: new Date(), operation: Operation.get(3)).save()
					new TypeEcriture(categorieEcriture: CategorieEcriture.findByLibelle("Frais"), libelle: "Type Ecriture test 1", credit: true).save()
					new TypeEcriture(categorieEcriture: CategorieEcriture.findByLibelle("Prix"), libelle: "Type Ecriture test 2", credit: true).save()
					new TypeEcriture(categorieEcriture: CategorieEcriture.findByLibelle("Frais"), libelle: "Type Ecriture test 3", credit: false).save()
					new TypeEcriture(categorieEcriture: CategorieEcriture.findByLibelle("Prix"), libelle: "Type Ecriture test 4", credit: false, affectable: true).save()
					new TypeEcriture(categorieEcriture: CategorieEcriture.findByLibelle("Frais"), libelle: "Type Ecriture test 5", credit: true).save()
					new TypeEcriture(categorieEcriture: CategorieEcriture.findByLibelle("Prix"), libelle: "Type Ecriture test 6", credit: true, affectable: true).save()
					new TypeEcriture(categorieEcriture: CategorieEcriture.findByLibelle("Frais"), libelle: "Type Ecriture test 7", credit: false).save()
					new TypeEcriture(categorieEcriture: CategorieEcriture.findByLibelle("Prix"), libelle: "Type Ecriture test 8", credit: true).save()
					new TypeEcriture(categorieEcriture: CategorieEcriture.get(3), libelle: "Type Ecriture test 9", credit: true, affectable: true).save()
					new TypeEcriture(categorieEcriture: CategorieEcriture.get(3), libelle: "Type Ecriture test 10", credit: false, affectable: true).save()
					def enr = new TypeEcriture(categorieEcriture: CategorieEcriture.findByLibelle("Frais"), libelle: "Enregistrement", credit: false, affectable: true)
					enr.save()
					def tf = new TypeEcriture(categorieEcriture: CategorieEcriture.findByLibelle("Frais"), libelle: "Taxe fonciere", credit: false, affectable: true)
					tf.save()
					def ppe = new TypeEcriture(categorieEcriture: CategorieEcriture.findByLibelle("Prix"), libelle: "Paiement Pret Engagement", credit: false, affectable: true)
					ppe.save()
					new Groupement(libelle: "Tous").save()
					TypeEcriture.list().each { lib ->
						new TypeEcritureGroupementRel(groupement: Groupement.get(1), typeEcriture: lib).save()
					}
					new Groupement(libelle: "Some").save()
					new TypeEcritureGroupementRel(groupement: Groupement.get(2), typeEcriture: TypeEcriture.get(1)).save()
					new TypeEcritureGroupementRel(groupement: Groupement.get(2), typeEcriture: TypeEcriture.get(8)).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Ch\u00E8que"), typeEcriture: TypeEcriture.get(1), dossier: Dossier.get(1), montant: new BigDecimal(1245), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Esp\u00E8ces"), typeEcriture: TypeEcriture.get(2), dossier: Dossier.get(4), montant: new BigDecimal(2345), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(3), dossier: Dossier.get(4), montant: new BigDecimal(1250), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Esp\u00E8ces"), typeEcriture: TypeEcriture.get(11), dossier: Dossier.get(4), montant: new BigDecimal(2345), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Esp\u00E8ces"), typeEcriture: TypeEcriture.get(12), dossier: Dossier.get(4), montant: new BigDecimal(2345), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: ppe, dossier: Dossier.get(4), montant: new BigDecimal(1250), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Ch\u00E8que"), typeEcriture: TypeEcriture.get(4), dossier: Dossier.get(1), montant: new BigDecimal(1500), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Esp\u00E8ces"), typeEcriture: TypeEcriture.get(5), dossier: Dossier.get(1), montant: new BigDecimal(1245), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(6), dossier: Dossier.get(1), montant: new BigDecimal(2345), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Ch\u00E8que"), typeEcriture: TypeEcriture.get(7), dossier: Dossier.get(1), montant: new BigDecimal(1250), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Ch\u00E8que"), typeEcriture: TypeEcriture.get(8), dossier: Dossier.get(1), montant: new BigDecimal(1500), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(1), dossier: Dossier.get(2), montant: new BigDecimal(1245), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(2), dossier: Dossier.get(2), montant: new BigDecimal(2345), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Ch\u00E8que"), typeEcriture: TypeEcriture.get(3), dossier: Dossier.get(2), montant: new BigDecimal(1250), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Esp\u00E8ces"), typeEcriture: TypeEcriture.get(4), dossier: Dossier.get(2), montant: new BigDecimal(1500), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Ch\u00E8que"), typeEcriture: TypeEcriture.get(5), dossier: Dossier.get(3), montant: new BigDecimal(1245), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Esp\u00E8ces"), typeEcriture: TypeEcriture.get(6), dossier: Dossier.get(3), montant: new BigDecimal(2345), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Ch\u00E8que"), typeEcriture: TypeEcriture.get(7), dossier: Dossier.get(2), montant: new BigDecimal(1250), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Ch\u00E8que"), typeEcriture: TypeEcriture.get(7), dossier: Dossier.get(2), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true).save()
					new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Ch\u00E8que"), typeEcriture: TypeEcriture.get(2), dossier: Dossier.get(2), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true).save()
					def tijari = CompteBancaire.findByLibelle('ATTIJARI')
					def cam = CompteBancaire.findByLibelle('CAM')
					7.times {
						new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(8), dossier: Dossier.get(2), montant: new BigDecimal(1500), dateValeur: new Date() - 2, dateMouvement: new Date(), compteBancaire: cih).save()
						new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(8), dossier: Dossier.get(2), montant: new BigDecimal(15000), dateValeur: new Date() - 2, dateMouvement: new Date(), compteBancaire: cih, marked: true).save()
						new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(8), dossier: Dossier.get(1), montant: new BigDecimal(2500), dateValeur: new Date() - 2, dateMouvement: new Date(), compteBancaire: tijari).save()
						new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(8), dossier: Dossier.get(1), montant: new BigDecimal(25000), dateValeur: new Date() - 2, dateMouvement: new Date(), compteBancaire: tijari, marked: true).save()
					}
					10.times {
						new Ecriture(pieceComptable: "piece comptable1", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Ch\u00E8que"), typeEcriture: TypeEcriture.get(9), montant: new BigDecimal(1880), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
						new Ecriture(pieceComptable: "piece comptable1", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(9), montant: new BigDecimal(20099), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
						new Ecriture(pieceComptable: "piece comptable1", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(10), montant: new BigDecimal(30099), dateValeur: new Date() - 2, dateMouvement: new Date()).save()
						new EcritureDossier(pieceComptable: "piece comptable?", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("En Cours"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(8), dossier: Dossier.get(2), montant: 51523f, dateValeur: new Date() - 2, dateMouvement: new Date()).save()
					}
					10.times {
						cih.addToEcritures(
								new Ecriture(pieceComptable: "piece comptable1", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(8), montant: new BigDecimal(1000), dateValeur: new Date() - 2, dateMouvement: new Date())).save()
						cih.addToEcritures(
								new Ecriture(pieceComptable: "piece comptable1", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(9), montant: new BigDecimal(1000), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true)).save()
					}
					10.times {
						tijari.addToEcritures(
								new Ecriture(pieceComptable: "piece comptable1", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Esp\u00E8ces"), typeEcriture: TypeEcriture.get(8), montant: new BigDecimal(123489), dateValeur: new Date() - 2, dateMouvement: new Date())).save()
						tijari.addToEcritures(
								new Ecriture(pieceComptable: "piece comptable1", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Virement"), typeEcriture: TypeEcriture.get(9), montant: new BigDecimal(1000), dateValeur: new Date() - 2, dateMouvement: new Date(), marked: true)).save()
					}
					10.times {
						cam.addToEcritures(
								new Ecriture(pieceComptable: "piece comptable1", commentaire: "bla bla", etat: EtatEcriture.findByLibelle("Valid\u00E9e"), moyenPaiement: MoyenPaiement.findByLibelle("Ch\u00E8que"), typeEcriture: TypeEcriture.get(8), montant: new BigDecimal(8948), dateValeur: new Date() - 2, dateMouvement: new Date())).save()
					}
					new Acte(dossier: Dossier.get(1), numRepertoire: 102, libelle: "ACTE 1", dateCreation: new Date()).save()
					new Acte(dossier: Dossier.get(1), numRepertoire: 103, libelle: "ACTE 2", dateCreation: new Date()).save()
					new Acte(dossier: Dossier.get(2), numRepertoire: 104, libelle: "ACTE 3", dateCreation: new Date()).save()
					new Acte(dossier: Dossier.get(2), numRepertoire: 105, libelle: "ACTE 4", dateCreation: new Date()).save()
					EcritureDossier.findAll().each { ecr -> new Activity(user: 'admin', opType: Activity.CREATE, controllerId: Activity.ECRITURE_DOSSIER, entityId: ecr.id).save() }
					Ecriture.findAll().each { ecr -> if (!(ecr instanceof EcritureDossier)) new Activity(user: 'admin', opType: Activity.CREATE, controllerId: Activity.ECRITURE, entityId: ecr.id).save() }
					Dossier.findAll().each { dossier -> new Activity(user: 'admin', opType: Activity.CREATE, controllerId: Activity.DOSSIER, entityId: dossier.id).save() }
					Acte.findAll().each { acte -> new Activity(user: 'admin', opType: Activity.CREATE, controllerId: Activity.ACTE, entityId: acte.id).save(); }
				} finally {

				}

				bootStrapService.populateSettingsForUsers()

				println "<<<<<<<<<<<<<<<<<<<<<<<<<DEVELOPMENT TEST DATA"     
			}
		}
	}
	def destroy = {
	}
} 
