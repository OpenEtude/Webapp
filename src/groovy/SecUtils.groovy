import org.jsecurity.SecurityUtils as SU
import javax.net.ssl.HostnameVerifier
import javax.net.ssl.HttpsURLConnection
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager

class SecUtils {

	static boolean hasRole(roleName){SU.subject?.hasRole(roleName)}
	static boolean maitre(){hasRole('Maitre')}
	static String maitreCrit(lbl){maitre()?'':" and (${lbl}.marked is null or ${lbl}.marked = false) "}
	static String maitreCrit(){maitreCrit('ecr')}
	static withEverySSLHostAccepted(Closure doYourStuff) {
		def nullTrustManager = [
		    checkClientTrusted: { chain, authType ->  },
		    checkServerTrusted: { chain, authType ->  },
		    getAcceptedIssuers: { null }
		]

		def nullHostnameVerifier = [
		    verify: { hostname, session -> true }
		]

		def sc = SSLContext.getInstance("SSL")
		sc.init(null, [nullTrustManager as X509TrustManager] as TrustManager[], null)
		def oldDefaultSSLSocketFactory = HttpsURLConnection.defaultSSLSocketFactory
		def oldDefaultHostnameVerifier = HttpsURLConnection.defaultHostnameVerifier
		HttpsURLConnection.defaultSSLSocketFactory = sc.socketFactory
		HttpsURLConnection.defaultHostnameVerifier = (nullHostnameVerifier as HostnameVerifier)
		def result = doYourStuff()
		HttpsURLConnection.defaultSSLSocketFactory = oldDefaultSSLSocketFactory
		HttpsURLConnection.defaultHostnameVerifier = oldDefaultHostnameVerifier
		result
	}
}
