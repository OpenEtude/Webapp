  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>JsecUserPermissionRel : </title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste JsecUserPermissionRel</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau JsecUserPermissionRel</g:link></span>
        </div>
        <div class="body">
            <h1>JsecUserPermissionRel : </h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${jsecUserPermissionRel.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Target:</td>
                            
                            <td valign="top" class="value">${jsecUserPermissionRel.target}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Actions:</td>
                            
                            <td valign="top" class="value">${jsecUserPermissionRel.actions}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Permission:</td>
                            
                            <td valign="top" class="value"><g:link controller="jsecPermission" action="show" id="${jsecUserPermissionRel?.permission?.id}">${jsecUserPermissionRel?.permission}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">User:</td>
                            
                            <td valign="top" class="value"><g:link controller="jsecUser" action="show" id="${jsecUserPermissionRel?.user?.id}">${jsecUserPermissionRel?.user}</g:link></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form accept-charset="UTF-8"   controller="jsecUserPermissionRel">
                    <input type="hidden" name="id" value="${jsecUserPermissionRel?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" action="delete" value="Supprimer" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
