  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Saisie JsecPermission</title>         
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste JsecPermission</g:link></span>
        </div>
        <div class="body">
            <h1>Nouveau JsecPermission</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${jsecPermission}">
            <div class="errors">
                <g:renderErrors bean="${jsecPermission}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='type'>Type:</label></td><td valign='top' class='value ${hasErrors(bean:jsecPermission,field:'type','errors')}'><input type="text" id='type' name='type' value="${jsecPermission?.type?.encodeAsHTML()}"/></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='possibleActions'>Possible Actions:</label></td><td valign='top' class='value ${hasErrors(bean:jsecPermission,field:'possibleActions','errors')}'><input type="text" id='possibleActions' name='possibleActions' value="${jsecPermission?.possibleActions?.encodeAsHTML()}"/></td></tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input type="submit" value="Enregistrer"></input></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
