class MoyenPaiement implements java.io.Serializable, Comparable {
	String libelle
	static constraints = {
		libelle(blank:false)
	}
	String toString() {"$libelle"}

	int compareTo(obj) {
		id.compareTo(obj.id)
	}
}