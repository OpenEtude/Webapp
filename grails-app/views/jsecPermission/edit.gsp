  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier JsecPermission</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste JsecPermission</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau JsecPermission</g:link></span>
        </div>
        <div class="body">
            <h1>Modifier JsecPermission</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${jsecPermission}">
            <div class="errors">
                <g:renderErrors bean="${jsecPermission}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   controller="jsecPermission" method="post" >
                <input type="hidden" name="id" value="${jsecPermission?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='type'>Type:</label></td><td valign='top' class='value ${hasErrors(bean:jsecPermission,field:'type','errors')}'><input type="text" id='type' name='type' value="${jsecPermission?.type?.encodeAsHTML()}"/></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='possibleActions'>Possible Actions:</label></td><td valign='top' class='value ${hasErrors(bean:jsecPermission,field:'possibleActions','errors')}'><input type="text" id='possibleActions' name='possibleActions' value="${jsecPermission?.possibleActions?.encodeAsHTML()}"/></td></tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit action="update" value="Enregistrer" /></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
