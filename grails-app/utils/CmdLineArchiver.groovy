class CmdLineArchiver {
	protected archive
	protected directory
	protected extractDirectory
	protected exclude
	protected archiveCmd(){["7z", "a", "-t7z", "-m0=lzma", "-mfb=64", "-ms=on", "-y", "${archive.canonicalPath}", "${directory.canonicalPath}/*"]}
	protected listCmd(){["7z", "l", "-y", "${archive.canonicalPath}"]}
	protected extractCmd(){["7z", "x", "-y", "${archive.canonicalPath}", "-o${extractDirectory.canonicalPath}"]}
	protected compressElements(output){filter(output, 13, 3, -2)}
	protected listElements(output){filter(output, 53, 4, -3)}
	protected extractElements(output){filter(output, 12, 3, -2)}
	private filter(output,start, y1,y2){
			output.split("\n").collect{
					it.length() >= start ? it[start..-1] : ""
			}.findAll{it}[y1..y2]
	}
	def runShell(shell){
			if (shell instanceof List){shell = shell.join(" ")}
			println "SHELL : [${shell}]"
			def sout = new StringBuffer()
			def serr = new StringBuffer()
			def p = shell.execute()
			p.waitForProcessOutput(sout, serr)
			if (serr) {System.err.println "ERR : ${serr}"}
			sout.toString()
	}
	def compress(){
			if (archive && directory.exists() && directory.directory) {
					def output = runShell(archiveCmd() + (exclude ? exclude.collect{"-x!${it}"} : []))
					if (archive.exists() && archive.length() > 0) {
							return compressElements(output)
					} else {
							throw new RuntimeException("Failed to compress archive : ${output}")
					}
			} else {
					throw new IllegalArgumentException("Not a valid archive name or bad directory")
			}
	}
	def list(){
		if (archive.exists()) {
			def output = runShell(listCmd())
			return listElements(output)
		} else {
			throw new FileNotFoundException("${archive.canonicalPath}")
		}
	}
	def extract(){
		if (archive.exists() && extractDirectory.exists() && extractDirectory.directory) {
			def output = runShell(extractCmd())
			return extractElements(output)
		} else {
			throw new IllegalArgumentException("Not a valid archive name or bad directory")
		}
	}
	static main(args){
		def archiver = new CmdLineArchiver(archive:new File(args[0]),directory:new File(args[1]),extractDirectory:new File(args[2]),exclude:["*.groovy","*.7z"])
		println "****************************COMPRESSION***************************"
		println archiver.compress().join("\n")
		println "****************************LISTING***************************"
		println archiver.list().join("\n")
		println "****************************EXTRACTION***************************"
		println archiver.extract().join("\n")
	}
}


