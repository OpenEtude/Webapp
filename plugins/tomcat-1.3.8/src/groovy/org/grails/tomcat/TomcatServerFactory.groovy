package org.grails.tomcat

import grails.web.container.*

class TomcatServerFactory implements EmbeddableServerFactory {

	def pluginSettings
	
	EmbeddableServer createInline(String basedir, String webXml, String contextPath, ClassLoader classLoader) {
		return new InlineExplodedTomcatServer(basedir, webXml, contextPath, classLoader)
	}

	EmbeddableServer createForWAR(String warPath, String contextPath) {
		return new IsolatedWarTomcatServer(warPath, contextPath)
	}
}