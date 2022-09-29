class CompteBancaire implements java.io.Serializable {
	String libelle
	String rib
	String agence
	String telephone
	String fax
	String contact
	String commentaire
	Date dateCreation = new Date()
	Date dateCloture
	static hasMany = [ecritures:Ecriture]
	static mappedBy = [ecritures:"compteBancaire"]
	static constraints = {
		libelle(maxLength:50,blank:false,unique:true)
		rib(maxLength:30,nullable:true,blank:false,unique:true)
		dateCreation()
		dateCloture(nullable:true)
		agence(nullable:true)
		telephone(nullable:true)
		contact(nullable:true)
		fax(nullable:true)
		commentaire(nullable:true)
	}
	String toString() {"$id - $libelle"}
}
