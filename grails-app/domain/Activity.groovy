class Activity implements java.io.Serializable, Comparable { 
	String user
	Integer opType
	Integer entityId
	Integer controllerId
	String msg
	static Integer CREATE = 1
	static Integer UPDATE = 2
	static Integer DELETE = 3
	static Integer VALIDATE = 4
	static Integer ATTACH = 5
	static Integer DETACH = 6
	static Integer AFFECT = 7
	static Integer IMPORT = 8
	static Integer RECEIPT = 9
	static Integer CONNECT = 10
	
	static Integer COMPTE = 1
	static Integer DOSSIER = 2
	static Integer ACTE = 3
	static Integer ECRITURE_DOSSIER = 4
	static Integer TYPE_ECRITURE = 5
	static Integer ECRITURE = 6
	static Integer COMPTE_BANCAIRE = 7
	static Integer OPERATION = 8
	static Integer BIEN = 9
	static Integer ETUDE_USER = 10
	static transients = ['gService']
	static mapping = {
        user column: "activity_user"
    }	
	Date dateCreated
	
	String toString() {"$dateCreated $user $opType $controllerId $entityId"}
	
	static constraints = {
		msg(nullable:true)
	}
	Activity leftShift(obj){
		def diffMap = DataUtils.diff(obj)
		def className = obj.'class'.simpleName
		diffMap.each{prop,diffEntry->
			boolean skipDiff = false
			def oldValue = diffEntry.old
			def newValue = diffEntry.'new'
			if ((oldValue && newValue) && (oldValue instanceof Date) && (0 == ParamUtils.getDaysBetween(oldValue, newValue))){
				skipDiff = true
			}
			if (!skipDiff) {
				if (!msg) msg = ""
				msg += "<b>${g().message(code:"${className}.${prop}",'default':prop)}</b>"
				oldValue = ParamUtils.format(g(),oldValue)
				newValue = ParamUtils.format(g(),newValue)
				msg += "(${oldValue ?: ''} <b>-&gt;</b> ${newValue ?: ''}) "
			}
		}
		return this
	}
	Activity plus(obj, proplist=grailsApplication.getDomainClass(obj.'class'.simpleName).persistentProperties.collect{it.name}){
		def className = obj.'class'.simpleName
		proplist.each{prop->
			def value = obj."${prop}"
			if (value){
				if (!msg) msg = ""
				value = ParamUtils.format(g(),value)
				msg += "<b>${g().message(code:"${className}.${prop}",'default':prop)}</b>:${value} "
			}
		}
		return this
	}
	int compareTo(obj) {
		dateCreated.compareTo(obj.dateCreated)
	}
	def grailsApplication
	def g
	def g() {
		if (!g){
			this.g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
		}
		return g
	}

}	
