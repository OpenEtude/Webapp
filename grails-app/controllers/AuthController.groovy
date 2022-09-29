import org.jsecurity.authc.AuthenticationException
import org.jsecurity.authc.UsernamePasswordToken
import org.jsecurity.SecurityUtils

class AuthController {

    static final String HC = "42"

    def jsecSecurityManager

    def adminService

    def index = { redirect(action: 'login', params: params) }

    def login = {
		if (session.user){
			redirect(uri:'/')
		} else {
			return [ username: params.username, rememberMe: (params.rememberMe != null), targetUri: params.targetUri ]
		}
    }

    def signIn = {
        def authToken = new UsernamePasswordToken(params.username, params.password as String, false)

        // Support for "remember me"
        if (params.rememberMe) {
            authToken.rememberMe = true
        }

        try{
            // Perform the actual login. An AuthenticationException
            // will be thrown if the username is unrecognised or the
            // password is incorrect.
            this.jsecSecurityManager.login(authToken)

            // If a controller redirected to this page, redirect back
            // to it. Otherwise redirect to the root URI.
            def targetUri = params.targetUri ?: "/"

            log.info "Redirecting to '${targetUri}'."
            session.user = params.username
            if (params.username != "admin") {
    			def activity = new Activity(user:session.user, opType:Activity.CONNECT, controllerId:Activity.ETUDE_USER, entityId:JsecUser.findByUsername(params.username)?.id)
    			activity.save()
            }
            log.info "Found user ${params.username}"
            redirect(uri: targetUri)
        }
        catch (AuthenticationException ex){
            // Authentication failed, so display the appropriate message
            // on the login page.
            if (!session.user){
				log.info "Authentication failure for user '${params.username}'."
				flash.message = message(code: "login.failed")
			}
            // Keep the username and "remember me" setting so that the
            // user doesn't have to enter them again.
            def m = [ username: params.username ]
            if (params.rememberMe) {
                m['rememberMe'] = true
            }

            // Remember the target URI too.
            if (params.targetUri) {
                m['targetUri'] = params.targetUri
            }

            // Now redirect back to the login page.
            redirect(action: 'login', params: m)
        }
    }

    def signOut = {
       try{ // Log the user out of the application.
			session?.user=null
			if(SecurityUtils.subject?.isAuthenticated()){
				SecurityUtils.subject?.logout()
			}
		} catch (e) {
		}
		chain(uri: '/')
    }

    def unauthorized = {
        redirect(uri: '/')
    }
    def hc = {
        render(HC)
    }
}
