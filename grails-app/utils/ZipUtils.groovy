import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry

class ZipUtils{
	static zip(folder, zipfile,Closure filter={true}) {
		def zos = new ZipArchiveOutputStream(new BufferedOutputStream(new FileOutputStream(zipfile)))
		zos.setFallbackToUTF8(true);
		zos.setUseLanguageEncodingFlag(true);								
		zos.setCreateUnicodeExtraFields(ZipArchiveOutputStream.UnicodeExtraFieldPolicy.NOT_ENCODEABLE);
		zos.level = 9
		//assuming that there is a directory named inFolder (If there 
		//isn't create one) in the same directory as the one the code runs from, 
		//call the folder method 
		try {
			zipOneFolder(folder, null, zos,filter); 
		} finally{
			zos.close()
		}
		//close the stream 
		return zipfile
	}
	static zipOneFolder(folder, prefix, zos,Closure filter={true}) { 
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
						def anEntry = new ZipArchiveEntry((prefix ? prefix+'/' : '')+f.name); 
						//place the zip entry in the ZipArchiveOutputStream object 
						zos.putNextEntry(anEntry); 
						//now write the content of the file to the ZipArchiveOutputStream 
						while((bytesIn = fis.read(readBuffer)) != -1) { 
							zos.write(readBuffer, 0, bytesIn); 
						} 
						//close the Stream 
						fis.close(); 
					}
				} else {
					zipOneFolder(f, (prefix ? prefix+'/' : '')+f.name,zos, filter)
				}
			} 
	}
}