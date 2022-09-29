  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>JsecPermission : </title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste JsecPermission</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau JsecPermission</g:link></span>
        </div>
        <div class="body">
            <h1>JsecPermission : </h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${jsecPermission.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Type:</td>
                            
                            <td valign="top" class="value">${jsecPermission.type}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Possible Actions:</td>
                            
                            <td valign="top" class="value">${jsecPermission.possibleActions}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form accept-charset="UTF-8"   controller="jsecPermission">
                    <input type="hidden" name="id" value="${jsecPermission?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" action="delete" value="Supprimer" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
