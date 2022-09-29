  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Affectation de Rôle : </title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Affectations de Rôles</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouvelle Affectation de Rôle</g:link></span>
        </div>
        <div class="body">
            <h1>Affectation de Rôle : </h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${jsecUserRoleRel.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Role:</td>
                            
                            <td valign="top" class="value"><g:link controller="jsecRole" action="show" id="${jsecUserRoleRel?.role?.id}">${jsecUserRoleRel?.role}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">User:</td>
                            
                            <td valign="top" class="value"><g:link controller="jsecUser" action="show" id="${jsecUserRoleRel?.user?.id}">${jsecUserRoleRel?.user}</g:link></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form accept-charset="UTF-8"   controller="jsecUserRoleRel">
                    <input type="hidden" name="id" value="${jsecUserRoleRel?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" action="delete" value="Supprimer" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
