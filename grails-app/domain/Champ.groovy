class Champ implements Comparable, java.io.Serializable  { 
    String libelle
	String description
    String settingType
	String format
	String defaultValue
	Integer ordre
	static belongsTo = [typeDeBien:TypeDeBien]
    static constraints = {
        libelle(nullable: false, blank: false)
        settingType(inList:["string", "integer", "date", "time", "url", "object", "boolean", "amount", "lov"])
        defaultValue(nullable: true, blank: true)
        format(nullable: true, blank: true)
		description(nullable:true)
		ordre(unique:'typeDeBien')
    }
    String toString(){libelle}
	def parseValue(value){parseValue(this,value)}
	static def parseValue(obj,val){
			if (null!=val) {
	            switch (obj.settingType) {
					case "string"	: return val;
					case "integer"  : return new Integer(val);
					case "date"     : return new java.text.SimpleDateFormat('dd/MM/yyyy').parse(val);
					case "time"     : return new java.text.SimpleDateFormat('HH:mm').parse(val);
					case "url"      : return val;
					case "object"   : def m = val.matches(/[a-zA-Z]:[0-9]/);return ['controller':m.group(1),'id':m.group(2) ];
					case "boolean"	: return new Boolean(val);
					case "amount"	: return new BigDecimal(val);
					case "lov"	: return (Map) Eval.me(obj.format);
				}
			}
	}
	int compareTo(obj) {
		ordre.compareTo(obj.ordre)
	}
}	
