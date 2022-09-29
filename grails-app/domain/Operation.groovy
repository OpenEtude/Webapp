class Operation implements Comparable, java.io.Serializable { 
	String libelle
	Date dateCreation = ParamUtils.newDate()
	Client client
	String description
	SortedSet biens
	SortedSet dossiers
	static belongsTo = [Client]
	static hasMany = [dossiers:Dossier, biens : Bien]
	String toString(){"$libelle"}
	static constraints = {
		libelle(blank:false)
		client()
		description(nullable:true)
		dateCreation()
	}
	int compareTo(obj) {
		id.compareTo(obj.id)
	}
}	
