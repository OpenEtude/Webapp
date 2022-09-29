class TypeDeBien implements Comparable, java.io.Serializable { 
	String libelle
	String toString(){"$libelle"}
	SortedSet champs
	static hasMany = [champs:Champ]
	static constraints = {
		libelle(unique:true,blank:false)
	}
	int compareTo(obj) {
		id.compareTo(obj.id)
	}
}	
