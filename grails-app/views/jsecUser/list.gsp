  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Liste Utilisateurs</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouvel Utilisateur</g:link></span>
        </div>
        <div class="body">
            <h1>Liste Utilisateurs</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                   	        <g:sortableColumn property="username" title="Nom" />
                   	        <th>R&ocirc;les</th>
                        	<td/>
                        	<td/>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${jsecUserList}" status="i" var="jsecUser">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td>${jsecUser.username?.encodeAsHTML()}</td>
                        
                            <td>${roles[jsecUser]}</td>
                        
							<td><g:link action="show" id="${jsecUser.id}" class="noprint show">Afficher</g:link></td>
							<td><g:link action="edit" id="${jsecUser.id}">Modifier</g:link></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${JsecUser.count()}" />
            </div>
        </div>
    </body>
</html>
