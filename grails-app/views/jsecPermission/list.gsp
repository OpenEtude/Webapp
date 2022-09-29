  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Liste JsecPermission</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau JsecPermission</g:link></span>
        </div>
        <div class="body">
            <h1>Liste JsecPermission</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="type" title="Type" />
                        
                   	        <g:sortableColumn property="possibleActions" title="Possible Actions" />
                        
                        	<td/>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${jsecPermissionList}" status="i" var="jsecPermission">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${jsecPermission.id}">${jsecPermission.id?.encodeAsHTML()}</g:link></td>
                        
                            <td>${jsecPermission.type?.encodeAsHTML()}</td>
                        
                            <td>${jsecPermission.possibleActions?.encodeAsHTML()}</td>
                        
												<td><g:link action="show" id="${jsecPermission.id}" class="noprint show">Afficher</g:link></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${JsecPermission.count()}" />
            </div>
        </div>
    </body>
</html>
