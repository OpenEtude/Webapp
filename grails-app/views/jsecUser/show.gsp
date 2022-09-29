  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Utilisateur : ${jsecUser.username}</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste Utilisateurs</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouvel Utilisateur</g:link></span>
        </div>
        <div class="body">
            <h1>Utilisateur : ${jsecUser.username}</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Nom de l'utilisateur :</td>
                            
                            <td valign="top" class="value">${jsecUser.username}</td>
                            
                        </tr>
                        <tr colspan="2">
							<td valign="top" class="name">R&ocirc;les Affect&eacute;s:</td>
						</tr>
	                    <g:each in="${roles}" var="roleRel">
	                        <tr>
	                            <td valign="top" class="name"></td>
	                            <td valign="top" class="value">
								<g:link controller="jsecRole" action="show" id="${roleRel.role.id}">${roleRel.role.name.encodeAsHTML()}</g:link></td>
	                        </tr>
	                    </g:each>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form accept-charset="UTF-8"   controller="jsecUser">
                    <input type="hidden" name="id" value="${jsecUser?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" action="delete" value="Supprimer" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
