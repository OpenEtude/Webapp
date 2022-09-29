import java.security.MessageDigest

class DataUtils{
	static def diff(obj){
		def names = obj.dirtyPropertyNames
		def result = [:]
		for (name in names) {
			def originalValue = obj.getPersistentValue(name)
			result."${name}" = ['old':obj.getPersistentValue(name),'new':obj."${name}"]
		}
		return result
	}
	static def eachDiff(obj,Closure f){
		def names = obj.dirtyPropertyNames
		for (name in names) {
			def originalValue = obj.getPersistentValue(name)
			f(name,obj.getPersistentValue(name),obj."${name}")
		}
	}
    static def count(bytes) {
        def unit = 1024
        if (bytes < unit) return bytes + " B"
        def exp = (int) (Math.log(bytes) / Math.log(unit))
        def pre = "KMGTPE".charAt(exp-1)
        return String.format("%.1f %sB", bytes / Math.pow(unit, exp), pre)
    }
    static def fingerPrint(f){
        def messageDigest = MessageDigest.getInstance("SHA1")
        f.eachByte(1024 * 1024) { byte[] buf, int bytesRead ->
          messageDigest.update(buf, 0, bytesRead);
        }
        new BigInteger(1, messageDigest.digest()).toString(16).padLeft( 40, '0' )
    }

}