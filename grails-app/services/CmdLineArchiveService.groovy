class CmdLineArchiveService {
	def compress(folder, archiveFile,List exclude=[]) {
		new CmdLineArchiver(archive:archiveFile,directory:folder,exclude:exclude).compress()
	}
	def list(archiveFile) {
		new CmdLineArchiver(archive:archiveFile).list()
	}
	def extract(folder, archiveFile) {
		new CmdLineArchiver(archive:archiveFile,extractDirectory:folder).extract()
	}
	boolean checkEntries(file, files){
		def mandatoryFiles = files.collect{String.valueOf(it)}
		def entries = list(file)
		def result = entries.containsAll(mandatoryFiles)
		if (!result){println "Some of ${mandatoryFiles} NOT FOUND in ${file}\n->>>>>>>${entries}"}
		return result
	}

}