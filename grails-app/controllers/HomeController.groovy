class HomeController {

	def synthese = {
	def gp = ['nostyle':'true','etat.id':2,'format':'html']
	use (org.codehaus.groovy.runtime.TimeCategory) {
		def now = new Date() + 3.days
		ParamUtils.toParams(now -1.months,'debut',gp)
		ParamUtils.toParams(now,'fin',gp)
	}
	[groupementParams:gp]
	}
	def index = {
	}
	def lastActes = {
		def user = session?.user
		def data = [:]
		if (user) {
			def maxActe = 5
			//Actes
			def acteList = Acte.executeQuery("""
			select new map(acte as acte, ac.opType as opType, ac.dateCreated as dateCreated )
			from Activity ac, Acte acte
			where ac.entityId = acte.id
			and ac.controllerId = :controllerId
			and ac.user = :user
			order by ac.dateCreated desc
			""",[controllerId:Activity.ACTE,user:user],[max : maxActe])
			acteList = acteList.unique{it.acte.id}
		def remainActe = maxActe - acteList.size()
		if (remainActe > 0) Acte.withCriteria{
			if (!acteList.empty) not {
				'in'('id',acteList.collect{it.id})
			}
			maxResults(remainActe)
			order('dateCreation','desc')
		}.each{acteList << [acte:it, opType:null, dateCreated:null];}
		acteList = acteList.unique{it.acte.id}
		data = [acteList:acteList]
		}
		return data
	}
	def lastDossiers = {
		def user = session?.user
		def data = [:]
		if (user) {
			def maxDossier = 5
			//Dossiers
			def dossierList = Dossier.executeQuery("""
			select new map(dossier as dossier, ac.opType as opType, ac.dateCreated as dateCreated )
			from Activity ac, Dossier dossier
			where ac.entityId = dossier.id
			and ac.controllerId = :controllerId
			and ac.user = :user
			order by ac.dateCreated desc
			""",[controllerId:Activity.DOSSIER,user:user],[max : maxDossier])
		def remainDossier = maxDossier - dossierList.size()
		if (remainDossier > 0) Dossier.withCriteria{
			if (!dossierList.empty) not {
				'in'('id',dossierList.collect{it.id})
			}
			maxResults(remainDossier)
			order('dateCreation','desc')
		}.each{dossierList << [dossier:it, opType:null, dateCreated:null];}
		dossierList = dossierList.unique{it.dossier.id}
		data = [dossierList:dossierList]
		}
		return data
	}
	def lastEcritures = {
		def user = session?.user
		def data = [:]
		if (user) {
			def maxDossier = 5
			def maxEcriture = 5
			//Ecritures
			def ecritureList = Ecriture.executeQuery("""
			select new map(ed as ecriture, ac.opType as opType, ac.dateCreated as dateCreated )
			from Activity ac, Ecriture ed
			where ac.entityId = ed.id
			and ac.controllerId = :controllerId
			and ac.user = :user
			${SecUtils.maitreCrit('ed')}
			order by ac.dateCreated desc
			""",[controllerId:Activity.ECRITURE,user:user],[max : maxEcriture])
			ecritureList = ecritureList.unique{it.ecriture.id}
			def remainEcriture = maxEcriture - ecritureList.size()
			if (remainEcriture > 0) Ecriture.withCriteria{
				if (!SecUtils.maitre()) {
					or {
						eq('marked',false)
						isNull('marked')
					}
				}
				if (!ecritureList.empty) not {
					'in'('id',ecritureList.collect{it.id})
				}
				maxResults(remainEcriture)
				order('dateValeur','desc')
			}.each{ecritureList << [ecriture:it, opType:null, dateCreated:null];}
			ecritureList = ecritureList.unique{it.ecriture.id}
			data = [ecritureList:ecritureList]
		}
		return data
	}
	def lastEcrituresDossier = {
		def user = session?.user
		def data = [:]
		if (user) {
			def maxDossier = 5
			def maxEcriture = 5
			//Ecritures Dossier
			def ecritureDossierList = EcritureDossier.executeQuery("""
			select new map(ed as ecritureDossier, ac.opType as opType, ac.dateCreated as dateCreated )
			from Activity ac, EcritureDossier ed
			where ac.entityId = ed.id
			and ac.controllerId = :controllerId
			and ac.user = :user
			${SecUtils.maitreCrit('ed')}
			order by ac.dateCreated desc
			""",[controllerId:Activity.ECRITURE_DOSSIER,user:user],[max : maxEcriture])
			ecritureDossierList = ecritureDossierList.unique{it.ecritureDossier.id}
			def remainEcritureDossier = maxEcriture - ecritureDossierList.size()
			if (remainEcritureDossier > 0) EcritureDossier.withCriteria{
				if (!SecUtils.maitre()) {
					or {
						eq('marked',false)
						isNull('marked')
					}
				}
				if (!ecritureDossierList.empty) not {
					'in'('id',ecritureDossierList.collect{it.id})
				}
				maxResults(remainEcritureDossier)
				order('dateValeur','desc')
			}.each{ecritureDossierList << [ecritureDossier:it, opType:null, dateCreated:null];}
			ecritureDossierList = ecritureDossierList.unique{it.ecritureDossier.id}
			data = [ecritureDossierList:ecritureDossierList]
		}
		return data
	}
	def pending = {
		def user = session?.user
		def data = [pending:0]
		if (user && EtatEcriture.findByLibelle("En Cours")) {
			def encours = SecUtils.maitre() ? EcritureDossier.countByEtat(EtatEcriture.findByLibelle("En Cours")) : EcritureDossier.createCriteria().get{
				eq('etat',EtatEcriture.findByLibelle("En Cours"))
				or {
					eq('marked',false)
					isNull('marked')
				}
				projections { 
					countDistinct('id') 
				} 
			}
			data = [pending:encours]
		}
		return data
	}
    def critereSynthese = {
        [debut:ParamUtils.newDate()-90, fin:ParamUtils.newDate()]
    }

}

