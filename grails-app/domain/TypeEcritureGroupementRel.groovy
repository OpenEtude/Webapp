class TypeEcritureGroupementRel  implements Comparable, java.io.Serializable { 
	Groupement groupement
	TypeEcriture typeEcriture
	int compareTo(obj) {
		id.compareTo(obj.id)
	}
	String toString() {"${groupement?.libelle} - ${typeEcriture?.libelle}"}
}	
