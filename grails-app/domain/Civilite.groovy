class Civilite implements java.io.Serializable {
	String libelle
	static constraints = {
		libelle(blank:false)
	}
	String toString() {"$libelle"}
}