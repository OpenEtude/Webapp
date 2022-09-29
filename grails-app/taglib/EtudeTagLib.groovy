class EtudeTagLib {

    static namespace = "etude"
	
	def adminService
	static ext2icon = ['docx':'word','doc':'word','rtf':'word','xlsx':'xls','xls':'xls','csv':'xls']
	def traduction = { attrs -> 
		def name =attrs.remove('name')
		def defaultParam = attrs.'default'
		def t = Traduction.findByName(name)
		if (!t) {new Traduction(name:name, trad:defaultParam).save()}
		def value = t?.trad
		if (!value) {value=defaultParam;}
		out << value
    }
	def theme = { attrs ->
		def configPerso = Setting.syssetting('ui.theme.per.user')
		def perso = findByKey('ui.theme.personal')?.value
		if (perso == 'ui.theme.personal') {
			perso = null
		}
		def general = Setting.syssetting('ui.theme')
		def themeValue = (configPerso && perso ? perso : general) ?: "classic"
		out << themeValue
    }

	def syssetting = { attrs -> 
		out << Setting.syssetting(attrs.remove('key'))
    }
    
	def mpIcon = { attrs -> 
		def mp =attrs.remove('mp')
		def mpIconClass = ''
		switch (mp?.id) {
			case 1 : mpIconClass = 'cheque';
			break;
			case 2 : mpIconClass = 'coins';
			break;
			case 3 : mpIconClass = 'virement';
			break;
		}
		out << mpIconClass
    }

	def myLayout = { attrs -> 
		out << "<meta name=\"layout\" content=\"${params.nostyle ? 'nostyle' : 'main'}\" />"
    }
	

    
	def etatIcon = { attrs -> 
		def etat =attrs.remove('etat')
		def etatIconClass = ''
		switch (etat?.id) {
			case 2 : etatIconClass = 'checked';
			break;
			case 1 : etatIconClass = 'pending';
			break;
			case 3 : etatIconClass = 'rejected';
			break;
			case 4 : etatIconClass = 'noimg';
			break;
		}
		out << etatIconClass
    }
    
	def prop = { attrs -> 
		def label =attrs.remove('label')
		def value =attrs.remove('value')
		if (null != value) {
			out << "<b>$label</b> $value"
		}
    }
    
	static Map dates = [2:'before.yesterday',1:'yesterday',0:'today', (-1):'tomorrow', (-2) : 'after.tomorrow']

	def relativeDate = { attrs -> 
		def date =attrs.remove('date')
		if (date) {
			boolean time =attrs.remove('time')?.equals('true')
			boolean sentence =attrs.remove('sentence')?.equals('true')
			def format = g.message(code:"relative.date${sentence ? '.sentence' : ''}.format") //dd MMMM yyyy
			def now = new Date()
			boolean hardCoded = false
			
			use(org.codehaus.groovy.runtime.TimeCategory){
				def days = ParamUtils.getDaysBetween(now, date)
				def years = now.year - date.year
				def months = now.month - date.month
				if (years == 0) {
					if (months == 0) {
						def special = dates.get(days)
						if (special) {
							format = g.message(code:special)
							hardCoded = true
						} else if (days < 7 && days > 0) {
							format = g.message(code:"relative.date${sentence ? '.sentence' : ''}.same.week.format") //EEEE
						} else {
							format = g.message(code:"relative.date${sentence ? '.sentence' : ''}.same.month.format") //EEEE dd
						}
					} else {
						format = g.message(code:"relative.date${sentence ? '.sentence' : ''}.same.year.format") //dd MMMM
					}
				}
				//log.trace " [$date] -> days : $days, months: $months, years : $years"
			}
			def tip = g.formatDate(format:('dd/MM/yyyy'+(time ? g.message(code:'relative.date.time.long.format') : '')), date:date)?.encodeAsHTML()
			def formattedDate = ((hardCoded ? format: g.formatDate(format:format, date:date)) + (time ? g.formatDate(format:g.message(code:'relative.date.time.format'), date:date) : ''))?.encodeAsHTML()
			def output = (attrs.plain == true ? formattedDate : "<span class='noprint' title=\"$tip\">$formattedDate</span><span class='noshow'>${sentence ? 'le ' : ''}${tip}</span>")
			out << output
		}
    }
	def month = { attrs -> 
	def num = mandatory(attrs,'num')
	def format = optional(attrs,'format') ?: "MMMM"
	out << g.formatDate(format:format, date:(new java.text.SimpleDateFormat('MM').parse("${num}")))
	}
	def keyword = { attrs ->
        println attrs
		def hint = attrs.remove('hint')
		def value = attrs.remove('value')
		def specialParams = attrs.params ?: [:]
		String lookup = attrs.remove('lookup')
		attrs.onfocus = "if (this.value == '$hint') this.value='';"
		attrs.onblur = "if (this.value == '') this.value='$hint';"
		attrs.title = attrs.remove('title') ?: hint
		attrs.'class' = attrs.'class'
		attrs.id = (attrs['id'] ?: attrs['name'])
		if (lookup=='true') {
    		def filter = ""
            (specialParams+params).each{k,v-> if (!(k in ['controller','action','q','sort','order','max', 'offset', attrs['name']])){filter+="${k}=${v}&"}
            }
            if (filter != ""){
                attrs.filter = filter
            }
			attrs.controller = attrs.remove('controller') ?: controllerName
			//attrs.onItemSelect = attrs.onItemSelect
            attrs.'class' = attrs.'class' ?: ''
			attrs.'class' += ' autocomplete'
			attrs.value = hint
			out << g.textField(attrs)
		} else {
            attrs.'class' = attrs.'class' ?: ''
			attrs.value = value ?: (params.get(attrs['name']) ?: hint)
            if (!attrs.value){
                attrs.remove('value');
            }
			try {
                out << g.textField(attrs)
            }catch (ex){
                ex.printStackTrace()
            }
		}
		(specialParams+params).each{k,v-> if (!(k in ['controller','action','q','sort','order','max', 'offset', attrs['name']])){
            out << g.hiddenField(name:k, value:v) +'\n'
        }
        }
    }

    def hide = { attrs, body -> 
		def id = attrs.remove('id') ?: 'hidden'
		out << """
<div class="hidden"><div id="${id}">${body()}</div></div>
"""
    }
	boolean checkPref(key) {
		if (null==key) {throw new IllegalArgumentException("key should be specified.")}
		def pref = findByKey(key)
		def result = (true == pref?.parseValue())
		return result
	}
    def ifpref = { attrs, body -> 
		def key = attrs.remove('key')
		if (checkPref(key)) {
			out << body()
		}
    }

	boolean checkSysPref(key) {
		if (null==key) {throw new IllegalArgumentException("key should be specified.")}
		def pref = Setting.findByKeyAndUserIsNull(key)
		def result = (true == pref?.parseValue())
		return result
	}
    def ifsyspref = { attrs, body -> 
		def key = attrs.remove('key')
		if (checkSysPref(key)) {
			out << body()
		}
    }

    def ifpopup = { attrs, body -> 
		if (params.nostyle == 'true') {
			out << body()
		}
    }
    
    
	def syslink = { attrs -> 
		def key = attrs.remove('key')
		if (null==key) {throw new IllegalArgumentException("key should be specified.")}
		if (checkSysPref(key+".check")) {
			def setting = Setting.findByKeyAndUserIsNull(key)
			if (setting) {
				attrs.href = setting.value
				def name = Setting.findByKeyAndUserIsNull(key+".name")?.value ?: attrs.href
				def aString = "<a "
				attrs.each{aString += " ${it.key}=\"${it.value ?: ''}\""}
				aString +=">$name</a>"
				out << aString
			}
		}
	}

	def link = { attrs,body -> 
		def key = attrs.remove('key')
		def show = attrs.remove('show')
		def icon = attrs.remove('icon')
		def txtclass = attrs.remove('txtclass')
		def root = "/"
		def ctrlName = {url->
			def uri = url.split("/")
			def ctrl = (uri ? uri.getAt(0) : null)
			ctrl
		}
		if (null==key) {throw new IllegalArgumentException("key should be specified.")}
		if (checkPref(key+".check") || show) {
			def setting = findByKey(key)
			if (setting) {
				attrs.href = setting.value
				def ctrlIcon = ctrlName(attrs.href) ?: icon
				icon = ctrlIcon ? "<span class='${ctrlIcon} favoris'/>" : ""
				def name = findByKey(key+".name")?.value ?: attrs.href
				def aString = !show ? "<a " : name
				if (!show){
					attrs.each{aString += " ${it.key}=\"${it.value ?: ''}\""}
					aString +=">${icon}<span class=\"${txtclass}\">${name}</span></a>"
				}
				out << aString
				out << body()
			}
		}
	}
	
	def findByKey(key){
		def userName = session.user
		if (userName) {
			def user = JsecUser.findByUsername(userName)
			if (user){
				def setting = Setting.findByUserAndKey(user, key)
				if (setting?.permissionType) {
					def attrs = [type:setting.permissionType,target:setting.permissionTarget,actions:setting.permissionActions]
					def ok  = false
					jsec.hasPermission(attrs,{
						ok = true
					})
					return ok ? setting : null
				} else {
					return setting
				}
			}
		}
	}
	def updateNotification = {attrs,body->

	}
    def tabPane = { attrs, body -> 
		def clazz = attrs.remove('class') ? ' ' + attrs.remove('class') : ''
		out << "<ul class=\"tabs$clazz\">${body()}</ul>"
    }
	
    def tab = { attrs -> 
		def label = attrs.remove('label')
		def code = attrs.remove('code')
		if (code && !label) {label = g.message('code':code)}
		out << "<li class=\"tab\"><a href=\"#${code}\">${label}</a></li>"
    }
	
    def tabContent = { attrs, body -> 
		def code = attrs.remove('code')
		def clazz = attrs.remove('class') 
		clazz = clazz ? " class=\"$clazz\"" : ''
		out << "<div id=\"${code}\"$clazz>${body()}</div>"
    }
	
    def oldtabPane = { attrs, body -> 
		def clazz = attrs.remove('class') ? ' ' + attrs.remove('class') : ''
		def id = mandatory(attrs,'id')
		out << "<div class=\"tabber$clazz\" id=\"$id\">${body()}</div>"
    }
	
    def oldtab = { attrs, body -> 
		def label = attrs.remove('label')
		def code = attrs.remove('code')
		if (code) {label = g.message('code':code)}
		out << "<div class=\"tabbertab\"><h2>${label}</h2><p>"
		out << body() 
		out << "</p></div>"
    }
	
	def mandatory(attrs,name){
		def value=attrs.remove(name);
		if (!value){
			throw new IllegalArgumentException("Empty mandatory attribute : $name")
		} else {
			return value
		}
	}

	def optional(attrs,name,defValue = null){
		def value=attrs.remove(name);
		return value ?: defValue
	}

	def edit = {attrs, body ->
			def label = mandatory(attrs,'label')
			def name = mandatory(attrs,'name')
			def type = mandatory(attrs,'type')
			def value = optional(attrs,'value')
			def defValue = optional(attrs,'defValue')
			def dbId = optional(attrs,'dbId')
			def desc = optional(attrs,'desc')
			def style = optional(attrs,'style')
			def cssClass = optional(attrs,'class')?.replace('.','_') ?: 'wide'
			boolean hideable = (optional(attrs,'hideable') == 'true')
			out << """
									<tr>
										<td style="text-align:right;${style ?: ''}">
			"""
			if (hideable){
			out << """
				<input id="copy${dbId}" name="copy${dbId}" type='checkbox' checked="${true}"
				onclick="\$('compo_${name}').className = (this.checked ? 'normal' : 'hidden');" />
			"""
			}
            if (type != 'boolean') {
				out << """
				<label for="compo_${name}">${label} :</label>
				"""
			}
			out << "</td><td>"
			def hint=desc
            if (type == 'boolean') {
			out << """
				${g.checkBox(id:"compo_${name}",name:name, value:value == 'true' ? true : false)}
				<label for="compo_${name}" title="${hint ?: ''}" class="button">${label}</label>
			"""
			} else if (type == 'date' || type == 'time') {
				out << g.datePicker(id:"compo_${name}",name:name, value:value, precision:(type== 'date' ? "day" : "time"))
			} else {
				out << """
					<input type="text" id="compo_${name}" name="${name}" value="${value ?: ''}" size="${type!='integer'?(type!='amount'?60:30):5}" class="${cssClass}" title="${hint ?: ''}"/>
				"""
			}
			out << """
				<input type="hidden" id="rowid${dbId}" name="rowid${dbId}" value="${dbId}"/>
				</td>
				<td>
				<input type="hidden" id="default${dbId}" name="default${dbId}" value="${defValue ?: ''}"/>
			"""
			
            if (type != 'boolean' && defValue) {
			out << """
				<a href="#" class="tip noprint" onclick="javascript:\$('compo_${name}').value = \$('default${dbId}').value;" title="Retablir la valeur initiale">Retablir</a>
			"""
			}
			out << """
										</td>
									</tr>
			"""
	}
	def remoteInclude = {attrs,body->
		def ctrlName = mandatory(attrs,'controller')
		def actionName = mandatory(attrs,'action') 
		def id = mandatory(attrs,'id')
		def params = optional(attrs,'params') ?: [:]
		def errorHandler = "function(e){\$('ohno${id}').appear();}"
		def container = optional(attrs,'container') ?: "div"
		def pendingMsg = optional(attrs,'pendingMsg') ?: "Chargement en cours..."
		def busyClass = optional(attrs,'busyClass') ?: "busy"
		params += ['nostyle':true]
		def jsParams = ""
		params.each{k,v-> jsParams+="'${k}':'${v}',"}
		jsParams = jsParams[0..-2]
		jsParams = "{$jsParams}"
		def errorMsg = optional(attrs,'errorMsg') ?: "Ech&egrave;c de chargement!"
		def root = ParamUtils.root(true)
		root = root == "/" ? "" : root
		out << """<${container} id="spinner${id}">${pendingMsg}</${container}><span class="evaljs">new Ajax.Updater('${id}','${root}/${ctrlName}/${actionName}',{asynchronous:true,evalScripts:true,onLoading:function(e){\$('spinner${id}').className='${busyClass} tip';},onComplete:function(e){\$('spinner${id}').hide();\$('${id}').appear({ duration: 0.5 });ETUDE.hookEvents();},onException:${errorHandler},onFailure:${errorHandler},on404:${errorHandler},on405:${errorHandler},parameters:${jsParams},method:'get'});</span><${container} id="${id}" style="display:none;"></${container}><${container} id="ohno${id}" class="error" style="display:none;">${errorMsg}</${container}>"""
	}
	def fileIcon = {attrs->
		def file = mandatory(attrs,'file')
		if (file.directory){out << 'folder'}
		else {
			def ext = file.name.split("\\.").last()
			out << (ext2icon[ext] ?: 'acte')
		}
	}
	def tr = {attrs,body->
		def ctrlName = mandatory(attrs,'ctrl')
		def obj = optional(attrs,'obj')
		def disabled = (params.mode == 'select')
		def id = mandatory(attrs,'id')
		def actionName = optional(attrs,'actionName') 
		def params = optional(attrs,'params') 
		def domId = optional(attrs,'domId') 
		def databar = optional(attrs,'databar')
		params = params ?: [:]
		def paramStr = ""
		int i=0
		params.each{k,v->paramStr +="${(i++>=1?'&':'?')}${k?.encodeAsURL()}=${v?.encodeAsURL()}"}
		def clazz = optional(attrs,'class') 
		clazz = (clazz ? clazz + ' ' : '') + (disabled ? '' : "clickable")
		actionName = actionName ?: "show"
		def htmlAttrs = ""
		attrs.each{k,v-> htmlAttrs += " $k=\"$v\""}
		if (obj && flash.highlight?.find{it.id == obj.id}){clazz+=" highlight"}
		if (domId) htmlAttrs += " id=\"$domId\""
		if (databar) clazz += " databar"
		def str = "<tr${htmlAttrs} class=\"$clazz\""
		if (!disabled) {
			str += """ title="Afficher" url="/${ctrlName}/${actionName}/$id$paramStr" """
		}
		str += ">${body()}</tr>"
		out << str
	}
	def databar = {attrs,body ->
		def ctrlName = mandatory(attrs,'controller')
		def fields = optional(attrs,'fields')
		def style = optional(attrs,'style')
		style = style ? " style='${style}'" : ""
		out << "<div class=\"databar partiallyhidden\"${style}>"
		out << g.form('accept-charset':"UTF-8",'controller' : ctrlName, 'class':"pack"){
			out << hiddenFields('fields':fields)
			out << body()
		}
		out << "<div class=\"transparent\"><span>&nbsp;</span></div></div>"
	}
	def hiddenFields = {attrs ->
		def fields = mandatory(attrs,'fields')
		fields.each{key,value->
			out << g.hiddenField('name':key, 'value':value)
		}
	}
	def tip = {attrs,body ->
		def anchor = mandatory(attrs,'anchor')
		def id = mandatory(attrs,'id')
		def controller = mandatory(attrs,'controller')
		def title = mandatory(attrs,'title')
		def root = "/"+ParamUtils.root()+"/"
		root = root.length()==2 ? "/" : root
		def url = "${root}/$controller/show/$id?preview=true&nostyle=true"
		out << """<script type="text/javascript">new Tip('$anchor', {title: '$title', ajax: {url: '$url',options: {method:'get'}},closeButton: true,hideOn:'.close', className: 'etude',effect: 'appear',delay:1,viewport: true });</script>"""
	}
	def previewIcon = {attrs,body->
		def id = optional(attrs,'id')
		if (id) {
			def icon = mandatory(attrs,'icon')
			def controller = mandatory(attrs,'controller')
			out << """<span class="${icon} help">&nbsp;</span>"""
		}
	}
	def linkDossier = {attrs,body->
		def dossier = optional(attrs,'dossier')
		def display = optional(attrs,'display')
		def otherAttrs = attrs.findAll{k,v->!['dossier'].contains(k)}
		otherAttrs.'class'=optional(attrs,'class') ?: ''
		otherAttrs.'class'+=' preview'
		if (dossier) {
			out << """${etude.previewIcon(icon:"folder${dossier?.operation ? 'operation' : ''}", controller:"dossier", id:"${dossier.id}")} ${g.link([controller:'dossier', action:'show', id:dossier.id]+otherAttrs){display ?: dossier?.encodeAsHTML()}}"""
		}
	}
	def linkOperation = {attrs,body->
		def operation = optional(attrs,'operation')
		def otherAttrs = attrs.findAll{k,v->!['operation'].contains(k)}
		otherAttrs.'class'=optional(attrs,'class') ?: ''
		otherAttrs.'class'+=' preview'
		if (operation) {
			out << """${etude.previewIcon(icon:'operation', controller:"operation", id:"${operation.id}")} ${g.link([controller:'operation', action:'show', id:operation.id]+otherAttrs){operation?.encodeAsHTML()}}"""
		}
	}
	def linkBien = {attrs,body->
		def bien = optional(attrs,'bien')
		def fields = optional(attrs,'fields') ?: [:]
		def highlight = flash.highlight?.contains(bien) ? ' highlight': '' 
		def action = optional(attrs,'action') ?: 'show'
		def databarDisabled = (optional(attrs,'databarDisabled') == "true")
		fields.id = bien.id
		def ctrlName = 'bien'
		def otherAttrs = attrs.findAll{k,v->!['bien'].contains(k)}
		highlight += ' preview'
		if (bien) {
			out << """${etude.previewIcon(icon:"bien${bien.dossier ? 'affecte' : 'libre'}", controller:"bien", id:"${bien.id}")} ${g.link(['class':highlight, controller:'bien', action:action, id:bien.id]+otherAttrs){bien.libelle?.encodeAsHTML()}}"""
			if (!databarDisabled){
			out << etude.databar(controller:"bien", fields:fields,style:(attrs.barstyle ?: "min-width:none;min-height:none;margin-left:auto;margin-right:0;right:0;left:auto;top:auto;height:0.0em;width:5em;top:0px;margin-top:-1.4em;margin-bottom:1em;")){
				out << g.actionSubmit('class':"link", value:"Modif.", title:"Modifier", action:"edit")
				out << "&nbsp;"
				out << jsec.hasPermission(type:"EtudePerm", target:"Bien", actions:"Suppression"){g.actionSubmit('class':"link danger", value:"Suppr.", title:"Supprimer", action:"delete")}
			}
			}
		}
	}
	def linkActe = {attrs,body->
		def acte = mandatory(attrs,'acte')
		def fields = optional(attrs,'fields') ?: [:]
		fields.id = acte.id
		def ctrlName = 'acte'
		def otherAttrs = attrs.findAll{k,v->!['acte','anchor'].contains(k)}
		otherAttrs.'class'=optional(attrs,'class') ?: ''
		otherAttrs.'class'+=' preview'
		if (acte) {
			out << """${etude.previewIcon(icon:'acte', controller:"acte", id:"${acte.id}")} ${g.link([controller:'acte', action:'show', id:acte.id]+otherAttrs){"${acte?.encodeAsHTML()}"}} """
			if (controllerName=='dossier') {
				out << """<span class="tip">(${etude.relativeDate(sentence:"true", date:acte.dateCreation)})</span>"""
				out << etude.databar(controller:"acte", fields:fields,style:(attrs.barstyle ?: "min-width:none;min-height:none;margin-left:auto;margin-right:0;right:0;left:auto;top:auto;height:0.0em;width:5em;top:0px;margin-top:-1.4em;margin-bottom:1em;")){
					out << g.actionSubmit('class':"link", value:"Modif.", title:"Modifier", action:"edit")
					out << "&nbsp;"
					out << jsec.hasPermission(type:"EtudePerm", target:"Acte", actions:"Suppression"){g.actionSubmit('class':"link danger", value:"Suppr.", title:"Supprimer", action:"delete")}
				}
			}
		}
	}
	def addHover = {attrs->
		out << " class='dataactionbar' "
	}
	def linkObject = {attrs,body->
		def object = mandatory(attrs,'object')
		def icon = optional(attrs,'icon')
		def otherAttrs = attrs.findAll{k,v->!['object'].contains(k)}
		if (object) {
			def clazz = object?.getClass().simpleName
			def ctrlName = ParamUtils.class2prop(clazz)
			def iconMarkup = icon ? "<span class=\"${icon}\"/>" : ""
			out << """${g.link([controller:ctrlName, action:'show', id:object.id]+otherAttrs){iconMarkup+object?.encodeAsHTML()}}"""
		}
	}
	def layout = {attrs,body->
	out << """<meta name="layout" content="main" />"""
	}
	def lic = {attrs,body->
		out << body()
	}
	def up = {attrs,body->
		if (!adminService.shouldRestart) {
			out << body()
		} else {
			flash.message= "Red&eacute;marrage planifi&eacute;, veuillez patienter..."
			flash.etude_restarting = true
			out << body()
		}
	}
	def root = {attrs,body->
		out << """<div class="hidden" id="etude_root" data-value='${ParamUtils.root(true)}'></div>"""
	}
}
