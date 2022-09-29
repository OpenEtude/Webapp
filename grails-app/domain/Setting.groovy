class Setting { 

    String key

    String value

    String settingType
    
	String category

	String defaultValue
	
	JsecUser user
	
	String permissionType
	
	String editor
	
	String permissionTarget
	
	String permissionActions
	
	Integer rank = 0
	
	static mapping = {
	  cache true
	  sort rank:"asc"
	}

	static belongsTo = [JsecUser]

    static constraints = {
        key(unique:'user',nullable: false, blank: false)
        value(nullable: true, blank: true, validator: {val, obj ->
							try {
								parseValue(obj,val)
								return true
							} catch(ex) { 
								return "invalid.${obj.settingType}"
							}
							})
        settingType(inList:["string", "integer", "date", "time", "url", "object", "boolean"])
        defaultValue(nullable: true, blank: true)
        category(nullable: true, blank: true)
        user(nullable: true)
        editor(nullable: true)
        permissionType(nullable: true)
        permissionTarget(nullable: true)
        permissionActions(nullable: true)
		rank(nullable:true)
    }

    String toString(){key}

	static syssetting(key){Setting.findByKey(key)?.parseValue()}

	def parseValue(){parseValue(this,this.value)}

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
				}
			}
	}
}	
