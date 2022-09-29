  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Saisie JsecRolePermissionRel</title>         
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste JsecRolePermissionRel</g:link></span>
        </div>
        <div class="body">
            <h1>Nouveau JsecRolePermissionRel</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${jsecRolePermissionRel}">
            <div class="errors">
                <g:renderErrors bean="${jsecRolePermissionRel}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='actions'>Actions:</label></td><td valign='top' class='value ${hasErrors(bean:jsecRolePermissionRel,field:'actions','errors')}'><input type="text" id='actions' name='actions' value="${jsecRolePermissionRel?.actions?.encodeAsHTML()}"/></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='permission'>Permission:</label></td><td valign='top' class='value ${hasErrors(bean:jsecRolePermissionRel,field:'permission','errors')}'><g:select optionKey="id" from="${JsecPermission.list()}" name='permission.id' value="${jsecRolePermissionRel?.permission?.id}" ></g:select></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='role'>Role:</label></td><td valign='top' class='value ${hasErrors(bean:jsecRolePermissionRel,field:'role','errors')}'><g:select optionKey="id" from="${JsecRole.list()}" name='role.id' value="${jsecRolePermissionRel?.role?.id}" ></g:select></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='target'>Target:</label></td><td valign='top' class='value ${hasErrors(bean:jsecRolePermissionRel,field:'target','errors')}'><input type="text" id='target' name='target' value="${jsecRolePermissionRel?.target?.encodeAsHTML()}"/></td></tr>
                        
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
