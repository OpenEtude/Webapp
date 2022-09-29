class EcritureDossier extends Ecriture implements Comparable {
	Dossier dossier
	Acte acte
	static belongsTo = [Dossier]
	static fetchMode = [typeEcriture:'eager',etat:'eager']
	static constraints = {
		dossier()
		typeEcriture()
		montant(min:new BigDecimal(0),scale:2,nullable:true)
		dateValeur()
		dateMouvement(nullable:true)
		etat(validator:{val, obj ->checkLocked(obj)})
		compteBancaire(nullable:true,validator:{val, obj ->
			if (val && !obj.typeEcriture?.affectable) {
				return ['pas.affectable']
			}
		})
		moyenPaiement(nullable:true)
		acte(nullable:true,validator:{val, obj ->
			def acte = val
			if (null!=acte && obj.dossier?.id !=acte.dossier?.id) {
				return ['acte.pas.attache.au.dossier']
			}
		})
		commentaire(nullable:true)
		pieceComptable(nullable:true)
		marked(nullable:true)
		modele(nullable:true)
	}
	String toString() {"$typeEcriture : ${montant ? new java.text.DecimalFormat('###,##0.00 DH').format(montant) : '-'}"}
}