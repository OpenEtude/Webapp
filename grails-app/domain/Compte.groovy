class Compte implements Comparable, java.io.Serializable {
	String code
	String libelle
	String description
	static belongsTo = [compteDeRattachement:Compte]
	static hasMany = [debiteurs:TypeEcriture,crediteurs:TypeEcriture,comptes:Compte]
	static mappedBy = [debiteurs:"compteADebiter",crediteurs:"compteACrediter"]
	static constraints = {
		code(maxLength:50,blank:false,unique:true)
		libelle(maxLength:50,blank:false,unique:'compteDeRattachement')
		compteDeRattachement(nullable:true)
		description(nullable:true)
	}
	String toString() {"$code - $libelle"}
	int compareTo(obj) {
		code?.compareTo(obj.code)
	}

}
