class Traduction {
    String name
    String description
    String trad
	  static mapping = {
		  cache true
	  }

    static constraints = {
        name(blank: false,unique: true)
        description(blank: false,unique: true)
        trad(blank: false)
    }
	String toString() {"$description"}
}
