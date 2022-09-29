  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Affectations de R&ocirc;les</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouvelle Affectation de R&ocirc;le</g:link></span>
        </div>
        <div class="body">
            <h1>Affectations de R&ocirc;les</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <th>Utilisateur</th>
                   	    
                   	        <th>R&ocirc;le</th>
                   	    
                        	<td/>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${jsecUserRoleRelList}" status="i" var="jsecUserRoleRel">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td>${jsecUserRoleRel.user?.encodeAsHTML()}</td>
                        
                            <td>${jsecUserRoleRel.role?.encodeAsHTML()}</td>
                        
												<td><g:link action="show" id="${jsecUserRoleRel.id}" class="noprint show">Afficher</g:link></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${JsecUserRoleRel.count()}" />
            </div>
        </div>
    </body>
</html>
