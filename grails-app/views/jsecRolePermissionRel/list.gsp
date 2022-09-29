  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Liste JsecRolePermissionRel</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau JsecRolePermissionRel</g:link></span>
        </div>
        <div class="body">
            <h1>Liste JsecRolePermissionRel</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="actions" title="Actions" />
                        
                   	        <th>Permission</th>
                   	    
                   	        <th>Role</th>
                   	    
                   	        <g:sortableColumn property="target" title="Target" />
                        
                        	<td/>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${jsecRolePermissionRelList}" status="i" var="jsecRolePermissionRel">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${jsecRolePermissionRel.id}">${jsecRolePermissionRel.id?.encodeAsHTML()}</g:link></td>
                        
                            <td>${jsecRolePermissionRel.actions?.encodeAsHTML()}</td>
                        
                            <td>${jsecRolePermissionRel.permission?.encodeAsHTML()}</td>
                        
                            <td>${jsecRolePermissionRel.role?.encodeAsHTML()}</td>
                        
                            <td>${jsecRolePermissionRel.target?.encodeAsHTML()}</td>
                        
												<td><g:link action="show" id="${jsecRolePermissionRel.id}" class="noprint show">Afficher</g:link></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${JsecRolePermissionRel.count()}" />
            </div>
        </div>
    </body>
</html>
