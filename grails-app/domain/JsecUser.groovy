class JsecUser implements Comparable, java.io.Serializable  {
    String username
    String passwordHash
	static hasMany = [settings:Setting]
    static constraints = {
        username(nullable: false, blank: false)
    }
    
    String toString(){"$id - $username"}
	int compareTo(obj) {
		id.compareTo(obj.id)
	}

	  static mapping = {
		  cache true
	  }
}
