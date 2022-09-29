class UrlMappings {
	static mappings = {
	   "/"(controller:"home")
	   "/monprofil"(controller:"setting",action: "list"){
		   pwdOnly = "true"
	   }
	  "/$controller/$action?/$id?"{
	      constraints {
		  }
	  }
	"500"(controller:"param",action:'error'){
	      constraints {
	      	
		  }
	}
	}
}
