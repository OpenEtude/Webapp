class Acte implements java.io.Serializable, Comparable { 
	Integer numRepertoire
	String libelle
	Dossier dossier
	Date dateCreation
	Boolean modele
	static searchable = true
	
	static constraints = {
		numRepertoire(validator:{val, obj ->
			def check = !obj.id || (val && Acte.get(obj.id)?.numRepertoire != val)
			if (check && !Acte.executeQuery("""
				from Acte acte
				where acte.numRepertoire = :numRepertoire
				and DATE_PART('year', cast(acte.dateCreation as date)) - DATE_PART('year', cast(:dateCreation as date))=0
				""",[numRepertoire: val, dateCreation: obj.dateCreation]).empty) return ['default.not.unique.message']
				
				//hsql : and datediff('yy', acte.dateCreation, :dateCreation)= 0  
		})
		dossier()
		libelle(maxLength:255,blank:false)
		modele(nullable:true)
	}
	
	String toString() {"$numRepertoire - $libelle"}
	
	int compareTo(obj) {
		dateCreation.compareTo(obj.dateCreation)
	}

}	
