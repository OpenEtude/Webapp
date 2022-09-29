import grails.util.Environment

class ParamController {

    def emailerService 
    def adminService 
	
    static accessControl = {
    }
    def index = { redirect(action:configuration,params:params) }

    static allowedMethods = [changeProfile:'GET']

	def changeProfile = {
		[ username: session.user ]
	}
	def modele = {
		[ username: session.user ]
	}

	private gohome() {
		if (request.contextPath+"/"!= request.forwardURI){
			redirect(uri:"/")
		}else{
			render (flash.message ?: "")
		}
	}
	def error = {
		try{
		def exception  = request.exception
		def rootCause = exception?.cause
		while (rootCause?.cause != null){rootCause = rootCause?.cause}
		def subject = "[BUGREPORT] ${exception?.className}:${exception?.lineNumber} : ${rootCause?.getClass()?.simpleName} - ${rootCause?.message?.encodeAsHTML()}"
		def licInfo = ""
		adminService.licInfo().each{k,v->
			licInfo += "<b>$k :</b>$v<br/>"
		}
		def text = "<div><div style=\"border: 1px solid gray;font-size:12px;padding: 5px;background-color:#E9E9E9;\"><b>Message:</b> ${rootCause?.getClass()?.name} :  ${rootCause?.message?.encodeAsHTML()}<br /></div>"
		def roles = []
		if (session?.user){
		text +="<b>User:</b> ${session?.user} "
		 roles = JsecUserRoleRel.findAllByUser(JsecUser.findByUsername(session?.user)).collect{it.role}
		}
		 text +="${roles}<br /><b>Class:</b> ${exception?.className + ":" + exception?.lineNumber}<br/></div><b>Params:</b><ul>"
		params.each{k,v->text += "<li><b>$k :</b>$v</li>"}
		text +="</ul><pre style=\"color: #333333;font-size:11px;border: 1px solid gray;padding: 5px;\">${exception?.stackTraceText?.encodeAsHTML()}</pre></div>"
		try {
		switch(Environment.current) {
		    case Environment.DEVELOPMENT:
				render text
				return
		    break
		    case Environment.PRODUCTION:
		        emailerService.sendEmail([to:["support@arkilog.ma"],subject:subject,text:text])
				gohome()
		    break
		    default :
					gohome()
			break   
		}
		flash.message = "Un incident s'est produit, une description a &eacute;t&eacute; envoy&eacute;e au support technique."
		flash.messageType = "error"
		flash.messageLink = [a:"Donnez plus de d&eacute;tails",href:"mailto:support@arkilog.ma"]
		} catch (IllegalStateException ise){
			log.error("La messagerie n'est pas encore configur&eacute;e (Configuration avanc&eacute;e &gt; Suivi &gt; 'Compte Gmail' et 'Mot de passe Gmail').")
		flash.message = "Un incident s'est produit, la description n'a pas pu &eacute;t&eacute; envoy&eacute;e au support technique parce que le compte de messagerie n'est pas encore configur&eacute;!."
		flash.messageLink = [a:"Configurer",href:g.createLink(controller:'setting',action:'syslist',params:[prefix:'mail'])]
		flash.messageType = "error"
					gohome()
		}
		}catch(yetAnotherException){
			yetAnotherException.printStackTrace()
			log.error(yetAnotherException)
			gohome()
		}
	}

    def search = {
		render(template:'search')
	}
	def apropos = {
		def name = grailsApplication.metadata['app.name']
		name = name[0].toUpperCase() + name.substring(1, name.length())
		render(template:'apropos',model:[patches:DatabasePatch.list(),appName:name,appVersion:grailsApplication.metadata['app.version'], fwkVersion:grailsApplication.metadata['app.grails.version']])
	}
	def editAll = {
		[paramList:Traduction.list()]
	}
    // Send an email
    def email = {
        // Each "email" is a simple Map
        def email = [
            to: [ params.to ],        // "to" expects a List, NOT a single email address
            subject: params.subject,
            text: params.body         // "text" is the email body
        ]
        // sendEmails expects a List
        emailerService.sendEmails([email])
        render("done")
    }

}
