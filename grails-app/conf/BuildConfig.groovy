grails.project.plugins.dir = 'plugins'
grails.project.dependency.resolution = {
    inherits "global" // inherit Grails' default dependencies
    log "error" // log level of Ivy resolver, either 'error',
               // 'warn', 'info', 'debug' or 'verbose'
    repositories {
        //grailsHome()
		// uncomment the below to enable remote dependency resolution // from public Maven repositories
		//mavenCentral()
		//mavenRepo "https://snapshots.repository.codehaus.org"
		//mavenRepo "https://repository.codehaus.org"
		mavenRepo "https://repo1.maven.org/maven2/"
		mavenRepo "https://download.java.net/maven/2/"
		mavenRepo "https://repository.jboss.com/maven2/"
	}
	dependencies { 
		// specify dependencies here under either 'build', 'compile', 
		// 'runtime', 'test' or 'provided' scopes, 
		compile 'org.apache.commons:commons-compress:1.3' 
		compile 'commons-codec:commons-codec:1.6' 
		compile 'org.apache.poi:poi:3.8-beta5'
		compile 'org.apache.poi:poi-scratchpad:3.8-beta5'
		compile 'org.apache.poi:poi-ooxml:3.8-beta5'
		compile 'org.postgresql:postgresql:42.2.5.jre7'
	} 
}
grails.project.war.file = 'target/etude.war'
