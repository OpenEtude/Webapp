  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Liste des r&ocirc;les</title>
    </head>
    <body>
        <div class="nav">
            
        </div>
        <div class="body">
            <h1>Liste des r&ocirc;les</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="name" title="R&ocirc;le" />
                        
                        	<td/>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${jsecRoleList}" status="i" var="jsecRole">
                        <etude:tr ctrl="jsecRole" id="${jsecRole.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><g:link action="show" id="${jsecRole.id}" class="roles">${jsecRole.name?.encodeAsHTML()}</g:link><br/><span class="tip"><g:if test="${users.get(jsecRole).empty}">Aucun utilisateur</g:if>${users.get(jsecRole).join(', ')}</span></td>
							<td><g:link action="edit" id="${jsecRole.id}">Modifier</g:link></td>
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${JsecRole.count()}" />
            </div>
        </div>
    </body>
</html>
