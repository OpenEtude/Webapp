import org.codehaus.groovy.grails.commons.GrailsApplication

class ApplicationBootStrap {
	GrailsApplication grailsApplication
	AdminService adminService
	BootStrapService bootStrapService
	def dataSource
    def init = { servletContext ->
		log.info("Running on '${System.getProperty("os.name")}'...")
		bootStrapService.with{
			createDefaultData()
			patch("5.0.126","delete_old_setting_keys","Delete obsolete settings"){
				updateData("delete from setting where key ilike '%file%'")
				updateData("delete from setting where value ilike '%/etude%'")
				updateData("delete from setting where default_value ilike '%/etude%'")
				updateData("delete from setting where key ilike '%theme%'")
				updateData("delete from setting where key ilike '%SoftwareUpdate%'")
				updateData("delete from setting where key ilike '%CleanUp%'")
				updateData("delete from setting where key ilike '%Flush%'")
				updateData("delete from setting where category ilike '%suivi%'")
				updateData("delete from setting where category ilike '%acte%'")
				updateData("delete from setting where key ilike '%dst%'")
				favorite(1,'En Conservation','/dossier/list?typeEcriture=21',false)
				favorite(2,'En Enregistrement','/dossier/list?typeEcriture=19',false)
				favorite(3,'En Cours','/dossier/list?etat=1',false)
				favorite(10,'En Instance CF','/dossier/list?typeEcriture=19&exclude=21&minAmount=200&notTag=dossiers.tag1',false)
				favorite(11,'En Instance IR/PF','/dossier/list?typeEcriture=19&exclude=14&minAmount=200&notTag=dossiers.tag2&isNull=operation',false)
				delsetting('activate.autocompletion')
				delsetting('show.dossiers.at.home')
				delsetting('show.ecritures.at.home')
				delsetting('show.ecritures.dossiers.at.home')
				delsetting('show.actes.at.home')
				delsyssetting("actes.creation.editeur")
				delsyssetting("actes.modification.editeur")
				delsyssetting("actes.creation.scanner")
				delsyssetting("actes.modification.scanner")
				delsyssetting("actes.modification.import.word")
				delsyssetting("system.dst")
				delsyssetting("DbFlusherJob.enabled")
			}
			patch("5.0.75","drop_table_sw_update","Drop table software update"){
				def q = sql()
				println(q.execute("DROP TABLE IF EXISTS SOFTWARE_UPDATE"))
			}
			patch("5.0.65","delete_from_activity","Deleted acte pj from activity"){
				def q = sql()
				println(q.execute("DELETE FROM ACTIVITY WHERE (OP_TYPE = :ATTACH OR OP_TYPE = :DETACH) and ENTITY_ID=:ACTE",[ATTACH:5,DETACH:6,ACTE:3]))
			}
			patch("5.0.65","drop_acte_document","Drop acte document"){
				def q = sql()
				println(q.execute("ALTER TABLE ACTE DROP COLUMN IF EXISTS DOCUMENT"))
			}
			patch("5.0.16","fix_urls","Fix urls"){
				Setting.withTransaction{
					Setting.executeQuery('''
						from Setting s 
						where s.settingType = :stype
					''',[stype:'url']).each{s->
						log.info("FOUND ${s.defaultValue}")
						if (s.value?.startsWith('/etude')) {
							s.value = s.value[6..-1]
							s.defaultValue = s.value
							s.save(failOnError:true, flush:true)
						} else if (s.value?.startsWith('//')) {
							s.value = s.value[1..-1]
							s.defaultValue = s.value
							s.save(failOnError:true, flush:true)
						}
					}
				}
			}
			println ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>APP BOOTSTRAP"
			def maitreRole = roleDef("Maitre")
			def comptableRole = roleDef("Comptable")
			def stagiaireRole = roleDef('Stagiaire')
			def secretaireRole = roleDef('Secretaire')
			def technicienRole = roleDef('Technicien')
			def auditeurRole = roleDef('Auditeur')
			def visiteurRole = roleDef('Visiteur')
			syssetting("etude","Etude 365", "01-general")
			syssetting("id.enregistrement","11", "02-application/ecritures")
			syssetting("id.taxe.fonciere","12", "02-application/ecritures")
			syssetting("id.pmt.pret.engagement","13", "02-application/ecritures")
			syssetting("ecriture.verrouiller.validees",'boolean',true, "02-application/ecritures")
			syssetting("ecriture.verrouiller.validees.demarrage",'boolean',true, "02-application/ecritures")
			def verValidees = Setting.findByKey("ecriture.verrouiller.validees")
			verValidees.value = "true"
			verValidees.save(failOnError:true)
			syssetting("ecriture.verrouiller.validees.delai",'integer',"4", "02-application/ecritures")
			syssetting("city","Rabat", "01-general")
			jobParam("SendBackupJob","to",null)
			new TaggableGrailsPlugin(application:grailsApplication).doWithDynamicMethods()
			///////////////////////JSECURITY
			trad("bien.libelle","Titre foncier", "Titre foncier")
			trad("PieceIdentite","Piece d'identit&eacute;", "Piece d'identit&eacute;")
			trad("CategorieEcriture","Categorie d'&eacute;criture", "Categorie d'&eacute;criture")
			trad("Civilite","Civilit&eacute;", "Civilit&eacute;")
			trad("Client","Client", "Client")
			trad("JsecPermission","Permission", "Permission")
			trad("JsecUserPermissionRel","Permission utilisateur", "Permission utilisateur")
			trad("JsecRole","R&ocirc;les", "R&ocirc;les")
			trad("JsecUserRoleRel","R&ocirc;le utilisateur", "R&ocirc;le utilisateur")
			trad("JsecRolePermissionRel","R&ocirc;le permission", "R&ocirc;le permission")
			trad("Ecriture","Ecriture", "Ecriture")
			trad("JsecUser","Utilisateur", "Utilisateur")
			trad("EcritureDossier","Ecriture de Dossier", "Ecriture de Dossier")
			trad("Ecriture","Ecriture", "Ecriture")
			trad("CompteBancaire","Compte Bancaire", "Compte Bancaire")
			trad("EtatEcriture","Etat d'ecriture", "Etat d'ecriture")
			trad("Dossier","Dossier", "Dossier")
			trad("MoyenPaiement","Moyen de Paiement", "Moyen de Paiement")
			trad("TypeEcriture","Type d'&eacute;criture", "Type d'&eacute;criture")
			trad("Param","Param&egrave;trage", "Param&egrave;trage")
			trad("Acte","Acte", "Acte")
			trad("Traduction","Traduction", "Traduction")
			trad("Groupement","Groupement", "Groupement")
			trad("Bien","Bien", "Bien")
			trad("TypeDeBien","Type de Bien", "Type de Bien")
			trad("Champ","Champ", "Champ")
			trad("Valeur","Valeur", "Valeur")
			trad("Operation","Op&eacute;ration", "Op&eacute;ration")
			trad("Client","Client", "Client")
			trad("Activity","Journal d'activit&eacute;", "Journal d'activit&eacute;")
			trad("dossiers.tag1","Non soumis &agrave; TF", "Tag 1 des dossiers")
			trad("dossiers.tag2","Non soumis &agrave; IR/PF", "Tag 2 des dossiers")
			permDef(maitreRole,'Acte', 'Liste,Consultation,Creation,Modification,Suppression')
			permDef(comptableRole,'Acte', 'Liste,Consultation,Creation,Modification')
			permDef(stagiaireRole,'Acte', 'Liste,Consultation,Creation,Modification')
			permDef(secretaireRole,'Acte', 'Liste,Consultation,Creation')
			permDef(maitreRole,'Client', 'Liste,Consultation,Creation,Modification,Suppression')
			permDef(comptableRole,'Client', 'Liste,Consultation,Creation,Modification')
			permDef(stagiaireRole,'Client', 'Liste,Consultation,Creation,Modification')
			permDef(secretaireRole,'Client', 'Liste,Consultation,Creation')
			permDef(maitreRole,'Dossier', 'Liste,Consultation,Creation,Modification,ModificationMasse,Suppression,RapportDetail')									
			permDef(comptableRole,'Dossier', 'Liste,Consultation')							

			[auditeurRole,visiteurRole].each{permDef(it,'Dossier', 'Liste,Consultation')}							
			permDef(stagiaireRole,'Dossier', 'Liste,Consultation,Creation,Modification,RapportDetail')									
			permDef(secretaireRole,'Dossier', 'Liste,Creation')									
			permDef(maitreRole,'EcritureDossier', 'Liste,Consultation,Creation,Modification,Suppression,ModificationMasse,RapportDetail,RapportSynthese')									
			permDef(comptableRole,'EcritureDossier', 'Liste,Consultation,Creation,Modification,ModificationMasse,RapportDetail,RapportSynthese')									
			permDef(stagiaireRole,'EcritureDossier', 'Liste,Consultation,Creation')									
			permDef(secretaireRole,'EcritureDossier', 'Liste,Consultation,Creation')									
			permDef(maitreRole,'Ecriture', 'Liste,Consultation,Creation,Modification,Suppression,ModificationMasse,RapportDetail,RapportSynthese')									
			permDef(comptableRole,'Ecriture', 'Liste,Consultation,Creation,Modification,ModificationMasse')									
			permDef(stagiaireRole,'Ecriture', 'Liste,Consultation,Creation')									
			permDef(secretaireRole,'Ecriture', 'Liste,Consultation,Creation')
			permDef(maitreRole,'TypeEcriture', 'Liste,Consultation,Creation,Modification,Suppression,ModificationMasse')									
			permDef(comptableRole,'TypeEcriture', 'Liste,Consultation,Creation')									
			permDef(stagiaireRole,'TypeEcriture', 'Liste,Consultation,Creation')									
			permDef(secretaireRole,'TypeEcriture', 'Liste,Consultation')									
			permDef(maitreRole,'JsecUser', 'Liste,Consultation,Creation,Modification,Suppression')									
			permDef(maitreRole,'JsecUserRoleRel', 'Liste,Consultation,Creation,Modification,Suppression')									
			permDef(maitreRole,'JsecRole', 'Liste,Consultation,Creation,Modification,Suppression')									
			permDef(maitreRole,'Groupement', 'Liste,Consultation,Creation,Modification,Suppression')									
			permDef(maitreRole,'Acte', 'Liste,Consultation,Creation,Modification,Suppression')
			permDef(comptableRole,'Acte', 'Liste,Consultation,Creation,Modification')
			permDef(stagiaireRole,'Acte', 'Liste,Consultation,Creation,Modification')
			permDef(secretaireRole,'Acte', 'Liste,Consultation,Creation')
			
			permDef(maitreRole,'Compte', 'Liste,Consultation,Creation,Modification,Suppression,ModificationMasse,RapportDetail,RapportSynthese')
			permDef(comptableRole,'Compte', 'Liste,Consultation,Creation,Modification,Suppression,ModificationMasse,RapportDetail,RapportSynthese')
			
			['Setting'
			,'Operation'
			,'Client'
			,'Bien'
			,'TypeDeBien'
			,'Champ'
			,'Valeur'
			].each{
			permDef(maitreRole,it,'Liste,Consultation,Creation,Modification,Suppression,ModificationMasse,RapportDetail,RapportSynthese')
			permDef(comptableRole,it, 'Liste,Consultation,Creation,Modification')
			permDef(stagiaireRole,it, 'Liste,Consultation,Creation,Modification')
			permDef(secretaireRole,it, 'Liste,Consultation,Creation')
			perm(it)
			}
			['EcritureDossier','Dossier','Acte','Ecriture','TypeEcriture','Groupement',
			'CompteBancaire','JsecUser','JsecUserRoleRel','JsecRole','Param','Traduction',
			'Activity','Administration'].each{perm(it)}
			permDef(technicienRole,'Administration', 'Liste,Consultation,Creation,Modification,Suppression,ModificationMasse,RapportDetail,RapportSynthese')
			populateSettingsForUsers()
			bootStrapJobs()
			println "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<APP BOOTSTRAP"
		}
     }
     private sql(){
     	new groovy.sql.Sql(dataSource.connection)
     }
    def destroy = {
    }
} 
