import org.codehaus.groovy.grails.commons.*;
import net.jawr.web.resource.bundle.locale.ResourceBundleMessagesGenerator;
import net.jawr.web.servlet.JawrGrailsServlet;

/**
 * This plugin adds Jawr (https://jawr.dev.java.net) functionality to grails applications. 
 * It expects jawr configuration to be set by means of the Config.groovy script. 
 * Using this config it will create bundles request handlers to serve 
 * javascript, CSS and CSS Images. 
 */
class JawrGrailsPlugin {
    // Plugin attributes
	def version = 2.8
	def grailsVersion = "1.0.2 > *"
    def dependsOn = [:]
	def author = "Jordi Hernández Sellés"
    def authorEmail = "jordihs@dev.java.net"
    def title = "adds Jawr (https://jawr.dev.java.net) functionality to Grails applications."
	def description = '''\
		Jawr is a tunable packaging solution for Javascript and CSS which allows for rapid development of resources 
		in separate module files. You can work with a large set of split javascript files in development mode, then
		Jawr bundles all together into one or several files in any way you define. By using a tag library, Jawr allows 
		you to use the same, unchanged GSP pages for development and production. Jawr also minifies and compresses the 
		files, resulting in reduced page load times. 
		'''
	def documentation = "https://jawr.dev.java.net"

    // Reference to the application context used for refreshing the config
    def appContext;    
    
    // Reference to the hashcode of Jawr config properties to know when to refresh the requestHandlers
    private int currentConfigHash;
    
	// Define the config as watched to reload the configuration when it changes. 
    def watchedResources =  "file:./grails-app/conf/Config.groovy";
   
  def doWithWebDescriptor = { webXml ->
		def conf =  ConfigurationHolder.config;
		Properties jawrProps = filterJawrProps(conf);
		
  	def servlets = webXml.servlet 
  	def servletMappings = webXml.'servlet-mapping' 
  	
		
		// Init the Javascript handler
  	if(conf.jawr.js){
  			def mapping = conf.jawr.js.mapping ? conf.jawr.js.mapping + "*" : "*.js";
	  		servlets[servlets.size()-1] + { 
	  			'servlet' { 
	  								'servlet-name' ("jawrJavascriptServlet") 
	  								'servlet-class' ("net.jawr.web.servlet.JawrGrailsServlet") 
	  								'load-on-startup' (2)
	  			} 
	  		} 
	  		servletMappings[servletMappings.size()-1] + { 
	  					'servlet-mapping' 
	  					{ 
	  						'servlet-name' ("jawrJavascriptServlet") 
	  						'url-pattern' (mapping) 
	  					} 
	  		} 
  	}
  	
  	// Init the CSS handler
  	if(conf.jawr.css){  		
  			def mapping = conf.jawr.css.mapping ? conf.jawr.css.mapping + "*" : "*.css";
	  		servlets[servlets.size()-1] + { 
	  			'servlet' { 
	  								'servlet-name' ("jawrCSSServlet") 
	  								'servlet-class' ("net.jawr.web.servlet.JawrGrailsServlet") 
	  								'init-param' { 'param-name' ('type')  
	  															 'param-value' ('css') }
	  								'load-on-startup' (3)
	  			} 
	  		} 
	  		servletMappings[servletMappings.size()-1] + { 
	  					'servlet-mapping' 
	  					{ 
	  						'servlet-name' ("jawrCSSServlet") 
	  						'url-pattern' (mapping) 
	  					} 
	  		} 
  	}
  	
  	// Init the Image handler
  	if(conf.jawr.img || conf.jawr.css.image.classpath.use.servlet){  		

  			servlets[servlets.size()-1] + { 
	  			'servlet' { 
	  								'servlet-name' ("jawrImgServlet") 
	  								'servlet-class' ("net.jawr.web.servlet.JawrGrailsServlet") 
	  								'init-param' { 'param-name' ('type')  
	  										'param-value' ('img') }
	  								'load-on-startup' (1)
	  			} 
	  		}
	  		
	  		def imgMappings
	  		def mapping
	  		if(conf.jawr.img.mapping){
	  			imgMappings = conf.jawr.img.mapping.split(';')
	  			if(imgMappings.length == 1){
	  				mapping = [ conf.jawr.img.mapping + "*" ]
	  			}else{
	  				mapping = imgMappings
	  			}
	  		}else{
	  			mapping = ["*.png", "*.gif", "*.jpg", "*.jpeg" ]
	  		}
	  		
	  		mapping.each{  itMapping ->
	  			servletMappings[servletMappings.size()-1] + { 
	  					'servlet-mapping' 
	  					{ 
	  						'servlet-name' ("jawrImgServlet") 
	  						'url-pattern' (itMapping.trim()) 
	  					} 
	  			}
	  		} 
  	}
  	
	}
	
	/**
	 * Initializes the Jawr requestHandler instances which will attend of javascript and CSS requests. 
	 */
    def doWithApplicationContext = { applicationContext ->
    	def conf =  ConfigurationHolder.config;
    	
    	if(conf.jawr) {    		
    		Properties jawrProps = filterJawrProps(conf);
    		currentConfigHash = jawrProps.hashCode();
    		applicationContext.servletContext.setAttribute(JawrGrailsServlet.JAWR_GRAILS_CONFIG_HASH,currentConfigHash);
    		applicationContext.servletContext.setAttribute(ResourceBundleMessagesGenerator.GRAILS_WAR_DEPLOYED,application.warDeployed);    		
    		
    		
    		// Init the Javascript handler
	    	if(conf.jawr.js){
		  		// Pass properties 
		  		def map = [type:"js",handlerName:'JavascriptJawrRequestHandler',(JawrGrailsServlet.PROPERTIES_KEY):jawrProps]
					if(conf.jawr.js.mapping)
						map.put('mapping',conf.jawr.js.mapping);
	    		applicationContext.servletContext.setAttribute(JawrGrailsServlet.JAWR_GRAILS_JS_CONFIG ,map);
	    	}
    		// Init the CSS handler
	    	if(conf.jawr.css){
	    		def map = [type:"css",handlerName:'CSSJawrRequestHandler',(JawrGrailsServlet.PROPERTIES_KEY):jawrProps]
	    		if(conf.jawr.css.mapping)
	    			map.put('mapping',conf.jawr.css.mapping);
	    		applicationContext.servletContext.setAttribute(JawrGrailsServlet.JAWR_GRAILS_CSS_CONFIG ,map);	    		
	    	}
		// Init the CSS handler
	    	if(conf.jawr.img){
	    		def map = [type:"img",handlerName:'ImgJawrRequestHandler',(JawrGrailsServlet.PROPERTIES_KEY):jawrProps]
	    		if(conf.jawr.img.mapping && conf.jawr.img.mapping.indexOf('*') == -1)
	    			map.put('mapping',conf.jawr.img.mapping);
	    		applicationContext.servletContext.setAttribute(JawrGrailsServlet.JAWR_GRAILS_IMG_CONFIG ,map);	    		
	    	}    
	    }
    	appContext = applicationContext;
    }

	/**
	 *  Gets a grails config object and extracts all Jawr properties from it, returning a Properties object 
	 *  with all of them. 
	 */
    def filterJawrProps = { config ->
		Properties props = config.toProperties();
		Properties rets = new Properties();
		props.each{ pair ->
			if(pair.key.startsWith('jawr'))
				rets.put(pair.key,pair.value);			
		}
		rets.put('jawr.charset.name',config.grails.views.gsp.encoding);
		return rets;		
	}
	
	/**
	 * Handles a configuration reloading event, refreshing jawr if needed. 
	 */
    def onChange = { event ->    	
    	if(ConfigurationHolder.config.jawr) {
    		// Check if Jawr properties have changed in this refresh
    		Properties jawrProps = filterJawrProps(ConfigurationHolder.config);
    		if(currentConfigHash != jawrProps.hashCode())
    			doWithApplicationContext(appContext);    		
    	}
    }
   
}