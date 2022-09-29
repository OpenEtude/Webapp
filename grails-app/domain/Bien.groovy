class Bien implements Comparable, java.io.Serializable { 
	String libelle
	TypeDeBien typeDeBien
	Operation operation
	Dossier dossier
	static belongsTo = [Operation,Dossier]
	static hasMany = [valeurs:Valeur]
	String toString(){"$typeDeBien ${libelle ?:''} - $operation"}
	static mapping = {
	  columns {
		  typeDeBien lazy:false
	  }
	}
	static constraints = {
		libelle(unique:true,matches:'[0-9]+/[0-9a-zA-Z]+',nullable:false)
		typeDeBien()
		operation(nullable:false)
		dossier(nullable:true)
	}
	int compareTo(obj) {
		id.compareTo(obj.id)
	}
}	
