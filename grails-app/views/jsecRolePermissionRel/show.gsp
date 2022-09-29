  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>JsecRolePermissionRel : </title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste JsecRolePermissionRel</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau JsecRolePermissionRel</g:link></span>
        </div>
        <div class="body">
            <h1>JsecRolePermissionRel : </h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${jsecRolePermissionRel.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Actions:</td>
                            
                            <td valign="top" class="value">${jsecRolePermissionRel.actions}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Permission:</td>
                            
                            <td valign="top" class="value"><g:link controller="jsecPermission" action="show" id="${jsecRolePermissionRel?.permission?.id}">${jsecRolePermissionRel?.permission}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Role:</td>
                            
                            <td valign="top" class="value"><g:link controller="jsecRole" action="show" id="${jsecRolePermissionRel?.role?.id}">${jsecRolePermissionRel?.role}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Target:</td>
                            
                            <td valign="top" class="value">${jsecRolePermissionRel.target}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form accept-charset="UTF-8"   controller="jsecRolePermissionRel">
                    <input type="hidden" name="id" value="${jsecRolePermissionRel?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" action="delete" value="Supprimer" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
