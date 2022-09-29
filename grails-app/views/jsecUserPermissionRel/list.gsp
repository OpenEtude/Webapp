  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Liste JsecUserPermissionRel</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau JsecUserPermissionRel</g:link></span>
        </div>
        <div class="body">
            <h1>Liste JsecUserPermissionRel</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="target" title="Target" />
                        
                   	        <g:sortableColumn property="actions" title="Actions" />
                        
                   	        <th>Permission</th>
                   	    
                   	        <th>User</th>
                   	    
                        	<td/>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${jsecUserPermissionRelList}" status="i" var="jsecUserPermissionRel">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${jsecUserPermissionRel.id}">${jsecUserPermissionRel.id?.encodeAsHTML()}</g:link></td>
                        
                            <td>${jsecUserPermissionRel.target?.encodeAsHTML()}</td>
                        
                            <td>${jsecUserPermissionRel.actions?.encodeAsHTML()}</td>
                        
                            <td>${jsecUserPermissionRel.permission?.encodeAsHTML()}</td>
                        
                            <td>${jsecUserPermissionRel.user?.encodeAsHTML()}</td>
                        
												<td><g:link action="show" id="${jsecUserPermissionRel.id}" class="noprint show">Afficher</g:link></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${JsecUserPermissionRel.count()}" />
            </div>
        </div>
    </body>
</html>
