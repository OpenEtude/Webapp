class Client implements java.io.Serializable { 
	String nom
	String telephone
	String mobile
	String fax
	String email	
	String addresse1
	String addresse2
	String ville
	String commentaire
	Civilite civilite
	String numIdentite
	PieceIdentite pieceIdentite
	static hasMany = [operations:Operation]
	static constraints = {
		civilite()
		nom(maxLength:50,blank:false)
		numIdentite(nullable:true)
		pieceIdentite(nullable:true)
		addresse1(nullable:true)
		addresse2(nullable:true)
		ville(maxLength:50,nullable:true)
		commentaire(maxLength:255,nullable:true)
		telephone(maxLength:30,nullable:true)
		mobile(maxLength:30,nullable:true)
		fax(maxLength:30,nullable:true)
		email(email:true,nullable:true)
	}
	String toString() {"$nom" }
}	
