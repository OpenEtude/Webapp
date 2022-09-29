class TypeEcriture implements java.io.Serializable, Comparable {
	CategorieEcriture categorieEcriture
	String libelle
	Boolean credit
	Boolean affectable
	Integer afficheDansOperation
	Compte compteACrediter
	Compte compteADebiter
	static Integer AFF_NON = 0
	static Integer AFF_PAGE_OP = 1
	static Integer AFF_PAGE_OP_XLS = 2
	static Integer AFF_XLS = 3

	static constraints = {
		categorieEcriture()
		libelle(validator:{val, obj ->
			if (val) {
				def other = TypeEcriture.list().find{it.libelle.toLowerCase() == val.toLowerCase()}
				if (other && other.id!= obj.id) {
					return ['default.not.unique.message']
				}
			}
		})
		credit()
		affectable(nullable:true)
		afficheDansOperation(nullable:true)
		compteADebiter(nullable:true)
		compteACrediter(nullable:true,validator:{val, obj ->
			if (val && val == obj.compteADebiter) {
				return ['compte.a.debiter.doit.etre.diff.compte.a.crediter']
			}
		})
	}
	static fetchMode = [categorieEcriture:'eager']
	static mapping = {
	  columns {
		  categorieEcriture lazy:false
	  }
	}
	String toString() {"$id - [${credit?'Cr\u00e9dit':'D\u00e9bit'} / $categorieEcriture] $libelle"}
	int compareTo(obj) {
		id.compareTo(obj.id)
	}
}