import org.grails.taggable.Taggable

class Dossier  implements Comparable, java.io.Serializable, Taggable { 
	String numeroDossier
	String libelle
	String nomModele
	String description
	Operation operation
	Date dateCreation = new Date()
	Boolean cloture
	Boolean modele
	EtatEcriture etatModele
	Boolean keepMontant
	SortedSet ecritures
	SortedSet actes
	static hasMany = [ecritures:EcritureDossier,actes:Acte,biens:Bien]
	static belongsTo = [Operation]
	static mappedBy = [ecritures:"dossier",actes:"dossier",paiements:"dossier"]
	static constraints = {
		numeroDossier(unique:true,matches:'[0-9]+/[0-9]+')
		libelle(blank:false)
		description(nullable:true)
		operation(nullable:true)
		modele(nullable:true)
		nomModele(nullable:true)
		etatModele(nullable:true)
		keepMontant(nullable:true)
		cloture(nullable:true)
		dateCreation()
	}
	int compareTo(obj) {
		id?.compareTo(obj.id) ?: -1
	}

	void setNumero(Long num) {
	}
	
	Long getNumero() {
		if (numeroDossier) {
			def arr = numeroDossier.split("/")
			if (arr && arr.length > 0) {
				try {
					def num = Long.parseLong(arr[0])
					def year = Long.parseLong(arr[1])
					return num + (100000 * year)
				} catch (e) {}
			}
		}
		return -1
	}
	static searchable = true
	String toString() {"${numeroDossier ? numeroDossier + '-' : ''} $libelle"}
}	
