class Ecriture implements java.io.Serializable, Comparable {
	TypeEcriture typeEcriture
	BigDecimal montant
	CompteBancaire compteBancaire
	MoyenPaiement moyenPaiement
	Date dateValeur = ParamUtils.newDate()
	Date dateMouvement = ParamUtils.newDate() + 2
	Date dateValidation
	EtatEcriture etat
	String commentaire
	String pieceComptable
	Boolean marked
	Boolean modele
	static searchable = true
	static belongsTo = [CompteBancaire]
	
	static constraints = {
		typeEcriture()
		montant(min:new BigDecimal(0),scale:2,nullable:true)
		dateValeur()
		moyenPaiement(nullable:true)
		compteBancaire(nullable:true,validator:{val, obj ->
			if (val && !obj.typeEcriture?.affectable) {
				return ['pas.affectable']
			}
		})
		dateMouvement(nullable:true)
		modele(nullable:true)
		etat(validator:{val, obj ->checkLocked(obj)})
		commentaire(nullable:true)
		pieceComptable(nullable:true)
		dateValidation(nullable:true)
		marked(nullable:true)
	}
	def beforeInsert = {
		checkDateValidation()
	}
	def beforeUpdate = {
		checkDateValidation()
	}
	def checkDateValidation(){
		def oldEtat = this.getPersistentValue('etat')
		def newEtat = this.etat
		if (newEtat.id == 2 && (!oldEtat || newEtat.id != oldEtat.id)) {
			dateValidation = ParamUtils.newDate()
		}
	}
	static checkLocked(obj){
		def oldEtat = obj?.getPersistentValue('etat')
		def newEtat = obj?.etat
		def today = ParamUtils.newDate()
		if (oldEtat?.id == 2 && Setting.syssetting("ecriture.verrouiller.validees") && (!obj.dateValidation || (obj.dateValidation + (Setting.syssetting("ecriture.verrouiller.validees.delai") ?: 4) <= today))) {
			return ['ecriture.verrouillee']
		}
	}
	def canBeDeleted(){
		return (null == checkLocked(this))
	}
	static fetchMode = [typeEcriture:'eager',etat:'eager']
	static mapping = {
		dossier index : 'dossier_idx'
		typeEcriture index : 'typeEcriture_idx'
	}
	
	int compareTo(obj) {
		dateValeur.compareTo(obj.dateValeur)
	}
	
	String toString() {"$typeEcriture : ${montant ?  new java.text.DecimalFormat('###,##0.00 DH').format(montant) : '-'}"}
}
