class GService {

   def grailsApplication

   def g

   def get() {
	if (!g){
      this.g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
	}
	return g
   }
}