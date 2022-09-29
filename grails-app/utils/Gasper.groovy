import java.net.InetAddress;
import java.net.NetworkInterface;

import java.security.MessageDigest;
import java.util.Arrays;
import java.util.prefs.Preferences

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import groovy.xml.MarkupBuilder

public class Gasper {

	Preferences prefs = Preferences.userNodeForPackage(Gasper.class)
	def deleteLic(id){
		prefs.remove(id)
	}
	
	boolean saveLic(lic,id){
		try {
			if (isLicOk(lic,id)){
				def xml = decrypt(toBinArray(decrypt(toBinArray(lic))))
				def requestInfo = new XmlSlurper().parseText(xml)
				setStringPref(id,lic)
				return true
			} else {
				return false
			}
		} catch (e){
			return false
		}
	}
	boolean checkLic(id){
		def lic = getStringPref(id,"")
		return isLicOk(lic,id)
	}
//	static main(args){println new Gasper().retrieveMac()}
	def retrieveMac(){
            def address = InetAddress.getLocalHost();
            NetworkInterface.getByInetAddress(address);
            def ni = NetworkInterface.getByInetAddress(address)
            if (!ni) {
            	ni = NetworkInterface.networkInterfaces.find{it.name.toLowerCase().contains("eth") || it.name.toLowerCase().contains("wlan")}
            }
//            println "Network interface [${ni}]"
		def result = ""
                byte[] mac = ni?.getHardwareAddress()
                if (!mac) {mac =  new byte[8];new Random().nextBytes(mac)}
                    for (int i = 0; i < mac.length; i++) {
                        result += String.format("%02X%s", mac[i], (i < mac.length - 1) ? ":" : "");
                    }
		return result
	}
	def createLicRequest(info){toHexString(encrypt(createRequestInfo(info)))}
	def createRequestInfo(info){
		def writer = new StringWriter()
		def xmlBuilder = new MarkupBuilder(writer)
		xmlBuilder.licReq{
			info.each{k,v->
				def clean = k.replaceAll("\\.",'')
				"$clean"("$v")
			}
		}
		def result = writer.toString()
		return result
	}
	def createLic(request){toHexString(encrypt(request))}
	boolean isLicOk(license,id){
		try {
			def xml = decrypt(toBinArray(decrypt(toBinArray(license))))
			println xml
			def requestInfo = new XmlSlurper().parseText(xml)
			boolean macOk = (requestInfo.mac.text() == retrieveMac())
			boolean idOk = (requestInfo.id.text() == id)
			println "!!!!!!!!!!!!!!!!!!!!!mac : ${macOk}, id : ${idOk}"
			return macOk && idOk
		} catch (e){
			return false
		}
	}
	def parseLicInfoFromPrefs(id){
		try {
			def xml = decrypt(toBinArray(decrypt(toBinArray(getStringPref(id,"")))))
			def requestInfo = new XmlSlurper().parseText(xml)
			def info = [:]
			 requestInfo.children().each{
				info.put(it.name(),it.text())
			 }
			return info
		} catch (e){
			return [:]
		}
	}
    public byte[] encrypt(String message) throws Exception {
        final MessageDigest md = MessageDigest.getInstance("md5");
        final byte[] digestOfPassword = md.digest("AH/LAND/ALOU/SYFE/HMOU/BE/LIC/HA/RA".getBytes("utf-8"));
        final byte[] keyBytes = Arrays.copyOf(digestOfPassword, 24);
		int j = 0
		int k = 16
        while (j < 8) {
                keyBytes[k++] = keyBytes[j++];
        }

        final SecretKey key = new SecretKeySpec(keyBytes, "DESede");
        final IvParameterSpec iv = new IvParameterSpec(new byte[8]);
        final Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key, iv);

        final byte[] plainTextBytes = message.getBytes("utf-8");
        final byte[] cipherText = cipher.doFinal(plainTextBytes);
        // final String encodedCipherText = new sun.misc.BASE64Encoder()
        // .encode(cipherText);

        return cipherText;
    }

    public String decrypt(byte[] message) throws Exception {
        final MessageDigest md = MessageDigest.getInstance("md5");
        final byte[] digestOfPassword = md.digest("AH/LAND/ALOU/SYFE/HMOU/BE/LIC/HA/RA".getBytes("utf-8"));
        final byte[] keyBytes = Arrays.copyOf(digestOfPassword, 24);
		int j = 0
		int k = 16
        while (j < 8) {
                keyBytes[k++] = keyBytes[j++];
        }

        final SecretKey key = new SecretKeySpec(keyBytes, "DESede");
        final IvParameterSpec iv = new IvParameterSpec(new byte[8]);
        final Cipher decipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
        decipher.init(Cipher.DECRYPT_MODE, key, iv);

        // final byte[] encData = new
        // sun.misc.BASE64Decoder().decodeBuffer(message);
        final byte[] plainText = decipher.doFinal(message);

        return new String(plainText, "UTF-8");
    }
	def setStringPref(String pref,String value,boolean cypher=false){
		if (cypher) {
			prefs.putByteArray(pref,encrypt(value))
		} else {
			prefs.put(pref,value)
		}
	}
	def getStringPref(String pref,String value,boolean cypher=false){
		if (cypher) {
			if (!value){
				value = "s3cret"
			}
			def array = prefs.getByteArray(pref,encrypt(value))
			decrypt(array)
		} else {
			prefs.get(pref,value)
		}
	}
public  static char[] hexChar = [ '0' , '1' , '2' , '3' ,
	        '4' , '5' , '6' , '7' ,
	        '8' , '9' , 'A' , 'B' ,
	        'C' , 'D' , 'E' , 'F' 
   ];
 
   
  public static String toHexString ( byte[] b ) {
    	
	    StringBuffer sb = new StringBuffer( b.length * 2 );
	    for ( int i=0; i<b.length; i++ ) {
	        // look up high nibble char
	        sb.append( hexChar [( b[i] & 0xf0 ) >>> 4] ); // fill left with zero bits
 
	        // look up low nibble char
	        sb.append( hexChar [b[i] & 0x0f] );
	    }
	    return sb.toString();
   }
	public static byte[] toBinArray( String hexStr ){
		def bArray = new Byte[hexStr.length()/2];  
		for(int i=0; i<(hexStr.length()/2); i++){
			byte firstNibble  = Byte.parseByte(hexStr.substring(2*i,2*i+1),16); // [x,y)
			byte secondNibble = Byte.parseByte(hexStr.substring(2*i+1,2*i+2),16);
			int finalByte = (secondNibble) | (firstNibble << 4 ); // bit-operations only with numbers, not bytes.
			bArray[i] = (byte) finalByte;
		}
		return bArray;
	}

}
