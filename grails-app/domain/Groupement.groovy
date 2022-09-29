class Groupement  implements Comparable, java.io.Serializable { 
	String libelle
	SortedSet libelles
	static hasMany = [libelles:TypeEcritureGroupementRel]
	static mappedBy = [libelles:"groupement"]
	static constraints = {
		libelle(unique:true,blank:false)
	}
	int compareTo(obj) {
		id.compareTo(obj.id)
	}
	String toString() {"$libelle"}
}	
