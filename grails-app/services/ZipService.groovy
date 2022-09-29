import org.apache.commons.compress.archivers.zip.ZipArchiveEntry

class ZipService {
	def zipOneFolder(folder, prefix, zos,Closure filter={true}) {
			//get a listing of the directory content 
			def dirList = folder.listFiles(); 
			def readBuffer = new byte[2156]; 
			int bytesIn = 0; 
			//loop through dirList, and zip the files 
			for(int i=0; i<dirList.length; i++) {
				def f = new File(folder, dirList[i].name); 
				//if we reached here, the File object f was not a directory 
				//create a FileInputStream on top of f 
				if (!f.directory) {
					if (filter(f)) {
						def fis = new FileInputStream(f); 
						//create a new zip entry 
						def anEntry = new ZipArchiveEntry(f,(prefix ? prefix+'/' : '')+f.name); 
						anEntry.size = f.length(); 
						//place the zip entry in the ZipArchiveOutputStream object 
						zos.putArchiveEntry(anEntry); 
						//now write the content of the file to the ZipArchiveOutputStream 
						while((bytesIn = fis.read(readBuffer)) != -1) { 
							zos.write(readBuffer, 0, bytesIn); 
						} 
						zos.closeArchiveEntry()
						//close the Stream 
						fis.close(); 
					}
				} else {
					zipOneFolder(f, (prefix ? prefix+'/' : '')+f.name,zos, filter)
				}
			} 
	}
}