class Valeur implements Comparable, java.io.Serializable  { 
    String contenu
	static belongsTo = [bien:Bien, champ:Champ]
    static constraints = {
        bien(nullable: false)
        champ(nullable: false)
        contenu(nullable: true, blank: true, validator :{val, obj ->
							try {
								println "<<<<<<<<<<<<<<<< VALIDATION >>>>>>>>>>>>>>>>  $obj ${obj?.champ?.settingType}"
								if (val != null && val.trim().size()!=0) {
									null != obj?.champ?.parseValue(val)
								}
							} catch(ex) { 
								ex.printStackTrace()
								return "invalid.${obj?.champ?.settingType}"
							}
							})
    }
    String toString(){"$champ : $contenu"}
	int compareTo(obj) {
		champ.compareTo(obj.champ)
	}
}	
