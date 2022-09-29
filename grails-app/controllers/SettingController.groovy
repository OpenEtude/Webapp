import org.apache.commons.codec.digest.DigestUtils

import static ParamUtils.trad
import org.grails.taggable.Taggable
            
class SettingController {
    def index = { redirect(action:list,params:params) }
	AdminService adminService
	BootStrapService bootStrapService
    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST', updatePwd : 'POST']

    static accessControl = {
		permission(perm: new EtudePerm("Setting", [ 'Modification' ]), only: [ 'addTag','removeTag','listTags','syslist','xmppreset','backup'])
	}
	
    def ajoutfavoris = {
	[favList:(1..11)]
	}
    def favoris = {
	[favList:(1..11)]
	}
    def doAjoutFavoris = {
		Setting.withTransaction{
			def prefix = params.favoris
			def url = params.url
			def user = JsecUser.findByUsername(session.user)
			def sUrl = Setting.findByUserAndKey(user, prefix)
			def sCheck = Setting.findByUserAndKey(user, "${prefix}.check")
			def sName = Setting.findByUserAndKey(user, "${prefix}.name")
			if (sName) {
				sName.value = params.label
				sUrl.value = url
				sCheck.value = "true"
				[sName,sCheck,sUrl]*.save()
				flash.message = "Favoris [${params.label}] ajout&eacute;"
			}
			redirect(uri:url)
		}
	}
    def list = {
		if (!session.user){
			redirect(controller: 'auth', action:'login',params: [targetUri:'/monprofil'])
			return
		}
		def rawList = Setting.findAllByUser(JsecUser.findByUsername(session.user))
		if (params.prefix) {
			rawList = rawList.findAll{it.key == params.prefix || it.key.startsWith(params.prefix+".")}
		}
		def settingList = rawList.groupBy{it.category}.sort{it.key}
		def result = [:]
		settingList.each{k,v ->
			def level0 = [:]
			def split = v[0].category.split('/')
			def tabLabel = split[0]
			def categoryLabel = (split.size()<=1 ? "nocateg" : split[1])
			if (!result.get(tabLabel)) {
				result.put(tabLabel,[("$categoryLabel".toString()):v])
			} else {
				result.get(tabLabel).put(categoryLabel,v)
			}
		}
        [ settingList: result,comebackTo:(params.comebackTo),username: session.user]
    }
	def updatePwd = {
		if (params?.password1!=params?.password2) {
			flash.message = "Les mots de passes sont diff&eacute;rents"
		} else {
			def user = JsecUser.findByUsernameAndPasswordHash(params.username, DigestUtils.shaHex(params.password))
			if(user){
				user.passwordHash= DigestUtils.shaHex(params.password1)
				user.save()
				flash.message = "Mot de passe chang&eacute; avec succ&egrave;s."
			} else {
				flash.message = "Utilisateur ou Mot de Passe incorrect(s)"
			}
		}
		redirect(controller:'setting',action:'list')
	}
    def syslist = {
		println params.comebackTo
		def rawList = Setting.findAllByUserIsNull()
		if (params.prefix) {
			rawList = rawList.findAll{it.key == params.prefix || it.key.startsWith(params.prefix+".")}
		}
		def settingList = rawList.groupBy{it.category}.sort{it.key}
		def result = [:]
		settingList.each{k,v ->
			def level0 = [:]
			def split = v[0].category.split('/')
			def tabLabel = split[0]
			def categoryLabel = (split.size()<=1 ? "nocateg" : split[1].toString())
			if (!result.get(tabLabel)) {
				result.put(tabLabel,[:])
			}
			result.get(tabLabel).put(categoryLabel,v)
		}
        render(view:'list',model:[ settingList: result,comebackTo:(params.comebackTo)])
    }

    def update = {
		Setting.withTransaction{
			params.findAll{it.key.startsWith('rowid')}.each{
				def s = Setting.get(it.value)
				def val = params.get("setting_value"+it.value)
				s.value = (s.settingType == 'boolean' ? ( val != null ? 'true' : 'false') : val)
				s.save()
			}
		}
		def nofail = {task->try {task()}catch(Throwable t){}}
		if (params.from=="syslist"){
			nofail{adminService.enableDst(Setting.syssetting("system.dst"))}
			nofail{bootStrapService.bootStrapJobs()}
			flash.message = "Configuration enregistr&eacute;e."
		} else {
			flash.message = "Pr&eacute;f&eacute;rences mises &agrave; jour."
		}
		if (params.comebackTo){
			redirect(controller:'admin',action:(params.comebackTo))
		} else {
			redirect(controller:'home',action:'index')
		}
    }
	def addTag = {
		if (params.name && params.clazz && params.trad && params.hint) {
			def type = null
			try {
				type = grailsApplication.classLoader.loadClass(params.clazz)
				if (Taggable.class.isAssignableFrom(type)){
					type.createTag(params.name)
					trad(params.name, params.trad, params.hint)
					render(type.getAvailableTags().join("<br/>"))
				} else {
					render("<h5>Bad params [${params}]</h5>Clazz parameter is not taggable [${params.clazz}]")
				}
			} catch (ClassNotFoundException e) {
				render("<h5>Bad params [${params}]</h5>Class not found [${params.clazz}]")
			}
		} else {
			render("<h5>Bad params [${params}]</h5>Usage : addTag?name=TagName&clazz=DomainClass&trad=Label&hint=hint")
		}
	}
	def removeTag = {
		if (params.name && params.clazz) {
			def type = null
			try {
				type = grailsApplication.classLoader.loadClass(params.clazz)
				if (Taggable.class.isAssignableFrom(type)){
					type.getAvailableTags().find{it.name==params.name}?.delete()
					render(type.getAvailableTags().join("<br/>"))
				} else {
					render("<h5>Bad params [${params}]</h5>Clazz parameter is not taggable [${params.clazz}]")
				}
			} catch (ClassNotFoundException e) {
				render("<h5>Bad params [${params}]</h5>Class not found [${params.clazz}]")
			}
		} else {
			render("<h5>Bad params [${params}]</h5>Usage : removeTag?name=TagName&clazz=DomainClass")
		}
	}
	def listTags = {
		if (params.clazz) {
			def type = null
			try {
				type = grailsApplication.classLoader.loadClass(params.clazz)
				if (Taggable.class.isAssignableFrom(type)){
					render(type.getAvailableTags().join("<br/>"))
				} else {
					render("<h5>Bad params [${params}]</h5>Clazz parameter is not taggable [${params.clazz}]")
				}
			} catch (ClassNotFoundException e) {
				render("<h5>Bad params [${params}]</h5>Class not found [${params.clazz}]")
			}
		} else {
			render("<h5>Bad params [${params}]</h5>Usage : listTags?clazz=DomainClass")
		}
	}
}