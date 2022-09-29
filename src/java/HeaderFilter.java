import javax.servlet.FilterConfig;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.ServletException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import java.util.LinkedHashMap;

public class HeaderFilter implements Filter {  
  
    private FilterConfig filterConfig;  
      
    private Map<String, String> headersMap;  
  
    public void init(FilterConfig filterConfig) throws ServletException {  
        this.filterConfig = filterConfig;  
  
        String headerParam = filterConfig.getInitParameter("header");  
        if (headerParam == null) {  
            return;  
        }  
  
        // Init the header list :  
        headersMap = new LinkedHashMap<String, String>();  
  
        if (headerParam.contains("|")) {  
            String[] headers = headerParam.split("|");  
            for (String header : headers) {  
                parseHeader(header);  
            }  
  
        } else {  
            parseHeader(headerParam);  
        }  
  
    }  
  
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {  
        if (headersMap != null) {  
            // Add the header to the response  
            Set<Entry<String, String>> headers = headersMap.entrySet();  
            for (Entry<String, String> header : headers) {  
                ((HttpServletResponse) response).setHeader(header.getKey(), header.getValue());  
            }  
        }  
        // Continue  
        chain.doFilter(request, response);  
    }  
  
    public void destroy() {  
        this.filterConfig = null;  
        this.headersMap = null;  
    }  
  
    private void parseHeader(String header) {  
        String headerName = header.substring(0, header.indexOf(":"));  
        if (!headersMap.containsKey(headerName)) {  
            headersMap.put(headerName, header.substring(header.indexOf(":") + 1));  
        }  
    }  
}