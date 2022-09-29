class JsecRole implements Comparable, java.io.Serializable {
    String name
    static constraints = {
        name(nullable: false, blank: false, unique: true)
    }
	String toString(){"$name"}
	  static mapping = {
		  cache true
	}
	int compareTo(obj) {
		id.compareTo(obj.id)
	}

}
