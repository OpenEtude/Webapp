class JsecRolePermissionRel {
    JsecRole role
    JsecPermission permission
    String target
    String actions

    static constraints = {
        actions(nullable: false, blank: false)
    }
	  static mapping = {
		  cache true
	  }
}
