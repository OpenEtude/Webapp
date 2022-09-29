  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Saisie JsecUserPermissionRel</title>         
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste JsecUserPermissionRel</g:link></span>
        </div>
        <div class="body">
            <h1>Nouveau JsecUserPermissionRel</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${jsecUserPermissionRel}">
            <div class="errors">
                <g:renderErrors bean="${jsecUserPermissionRel}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='target'>Target:</label></td><td valign='top' class='value ${hasErrors(bean:jsecUserPermissionRel,field:'target','errors')}'><input type="text" id='target' name='target' value="${jsecUserPermissionRel?.target?.encodeAsHTML()}"/></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='actions'>Actions:</label></td><td valign='top' class='value ${hasErrors(bean:jsecUserPermissionRel,field:'actions','errors')}'><input type="text" id='actions' name='actions' value="${jsecUserPermissionRel?.actions?.encodeAsHTML()}"/></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='permission'>Permission:</label></td><td valign='top' class='value ${hasErrors(bean:jsecUserPermissionRel,field:'permission','errors')}'><g:select optionKey="id" from="${JsecPermission.list()}" name='permission.id' value="${jsecUserPermissionRel?.permission?.id}" ></g:select></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='user'>User:</label></td><td valign='top' class='value ${hasErrors(bean:jsecUserPermissionRel,field:'user','errors')}'><g:select optionKey="id" from="${JsecUser.list()}" name='user.id' value="${jsecUserPermissionRel?.user?.id}" ></g:select></td></tr>
                        
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
