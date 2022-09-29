import java.security.MessageDigest
includeTargets << grailsScript("War")
def proc = 'git log -5'.execute()
def proc2 = 'grep -v "Author"'.execute()
changelog=((proc | proc2).text)

target (distribute:'''GENERATE DISTRIBUABLE PACKAGE
''') {
    depends(warMain)
    def warFile = grailsApp.config.grails.project.war.file ?: "target/etude.war"
    println "WAR FILE : $warFile"
    def f = new File(warFile)
    println "GENERATING DISTRIBUABLE PACKAGE FOR ${f.absolutePath}..."
    def version = grailsApp.metadata['app.version']
    int KB = 1024
    int MB = 1024*KB

    if (!f.exists() || !f.isFile()) {
      println "Invalid file $f provided"
      throw new IllegalArgumentException(warFile)
    }
    println("CALCULATING FINGERPRINT...")

    def messageDigest = MessageDigest.getInstance("SHA1")

    f.eachByte(MB) { byte[] buf, int bytesRead ->
      messageDigest.update(buf, 0, bytesRead);
    }
    def sha1Hex = new BigInteger(1, messageDigest.digest()).toString(16).padLeft( 40, '0' )
    println("CREATING DESCRIPTOR...")
    def updateDecriptor = new File("target/latest.xml")
    updateDecriptor.text = """<?xml version="1.0" encoding="UTF-8"?>
<update>
<size>${f.length()}</size>
<changelog><![CDATA[${changelog}]]>\n</changelog>
<tstamp>${System.currentTimeMillis()}</tstamp>
<version>${version}</version>
<fingerprint>$sha1Hex</fingerprint>
</update>"""
    def warCopy = new File(System.env['ETUDE_UPDATE_FOLDER'] ?: "${userHome}/Dropbox/Public/","${sha1Hex}.war").absolutePath
    ant.delete{
        fileset(dir:(new File(warCopy).parentFile.absolutePath)){
           include(name:"*.war")
           include(name:"latest.xml")
        }
    }
    println("COPYING WAR FILE TO ${warCopy}...")

    ant.copy(file:(warFile),tofile:warCopy)
    println("COPYING DESCRIPTOR...")
    ant.copy(file:"target/latest.xml",tofile:(new File(System.env['ETUDE_UPDATE_FOLDER'] ?: "${userHome}/Dropbox/Public/","latest.xml").absolutePath))
    println "DISTRIBUABLE PACKAGE GENERATED!!!"

}

setDefaultTarget('distribute')
