import org.apache.log4j.MDC
import org.apache.commons.logging.Log
import org.apache.commons.logging.LogFactory

class UsageTrackingFilters {  
   private static final Log usagetrackingLog = LogFactory.getLog('ut')
   def filters = {
       all(controller: '*', action: '*') {
           before = {
               if (session.user) {
                   MDC.put('user', (session.user ?: "[ANONYMOUS]"))
               }
               usagetrackingLog.info("${request.method} ${request.forwardURI}")
               if (request.post){
                   def post = params.findAll{k,v->k!="password"}
                   usagetrackingLog.debug("${post}")
               }
           }
           after = {
           }
           afterView = {
               MDC.remove('user')
           }
       }
   }
 }