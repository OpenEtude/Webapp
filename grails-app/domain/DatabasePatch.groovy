class DatabasePatch {
    String name
    String description
    Integer majorVersion
    Integer midVersion
    Integer minorVersion
	Date dateCreated

    static constraints = {
        name(blank: false,unique: true)
        description(nullable: true)
    }
	String toString() {"[$name -> ${majorVersion}.${midVersion}.${minorVersion}]"}
}
