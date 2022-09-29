// log4j configuration
log4j = {
	appenders {
		'null' name:'stacktrace'
	   console name: 'stdout', layout:pattern(conversionPattern: '%d{dd-MM-yyyy HH:mm:ss,SSS}|%p|%c{1}|%X{user}|%m%n'), threshold: org.apache.log4j.Level.INFO
	   	root {
        	info 'stdout'
    	} 
	}
	info "grails.app.controller.AuthController"
	info "grails.app.service.AdminService"
	info "grails.app.service.SmbService"
	debug "org.postgresql"
	info "ApplicationBootStrap"
	environments {
        development {
			info "grails.app"
			debug "task"
		}
	}
}
grails.mime.types = [  
                      text: 'text-plain',
                      js: 'text/javascript',
                      rss: 'application/rss+xml',
                      atom: 'application/atom+xml',
                      css: 'text/css',
                      csv: 'text/csv',
                      all: '*/*',
                      json: ['text/json','application/json'],
                      html: ['text/html','application/xhtml+xml']
                    ]
hibernate {
    cache.use_second_level_cache=true
    cache.use_query_cache=true
    cache.provider_class='org.hibernate.cache.EhCacheProvider'
}
SendBackupJobConfig.cron = "0 30 16 ? * 6"
// The following properties have been added by the Upgrade process...
grails.views.default.codec="none" // none, html, base64
grails.views.gsp.encoding="UTF-8"
grails.mime.file.extensions = false
jsecurity.legacy.filter.enabled = true
grails.enable.native2ascii = true
jawr.debug.on = false
jawr.gzip.on = true
jawr.gzip.ie6.on=false

jawr.js.bundle.basedir='/js/include'
jawr.css.bundle.basedir='/css'
jawr.js.factory.use.dirmapper=false
jawr.css.factory.use.dirmapper=false
jawr.config.reload.interval=4
jawr.js.mapping = '/script/'
jawr.css.mapping = '/style/'
environments {
	development {
		jawr.config.reload.interval=1
		jawr.debug.on = true
		grails.app.context = "/"
	}
}

// All files within /js/lib will be together in a bundle. 
// The remaining scripts will be served sepparately. 
jawr.js.bundle.names='all'
jawr.js.bundle.all.id='/script/all.js'
jawr.js.bundle.all.mappings='/richui/js/yui/yahoo-dom-event/yahoo-dom-event.js,/richui/js/yui/connection/connection-min.js,/richui/js/yui/animation/animation-min.js,/richui/js/yui/autocomplete/autocomplete.js,/js/include/prototype.js,/js/include/scriptaculous.js,/js/include/effects.js,/js/include/modalbox.js,/js/include/livepipe.js,/js/include/tabs.js,/js/prototip.js,/js/hopscotch.js,/js/application.js'

// The /bundles/lib.js bundle is global 
// (always imported before other scripts to pages using the taglib)
// CSS properties and mappings
jawr.css.bundle.names='classic,mobile'
jawr.css.bundle.classic.id='/style/classic.css'
jawr.css.bundle.classic.mappings='/css/hopscotch.css,/css/modalbox.css,/css/tabs.css,/css/main-classic.css,/css/sprite.css,/css/prototip.css'

jawr.css.bundle.mobile.id='/style/mobile.css'
jawr.css.bundle.mobile.mappings='/css/mobile.css'

jsecurity.authc.required = false
