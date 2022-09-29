  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Nouvelle Affectation de Rôle</title>         
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Affectations de Rôles</g:link></span>
        </div>
        <div class="body">
            <h1>Nouvelle Affectation de Rôle</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${jsecUserRoleRel}">
            <div class="errors">
                <g:renderErrors bean="${jsecUserRoleRel}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='role'>Role:</label></td><td valign='top' class='value ${hasErrors(bean:jsecUserRoleRel,field:'role','errors')}'><g:select optionKey="id" from="${JsecRole.list()}" name='role.id' value="${jsecUserRoleRel?.role?.id}" ></g:select></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='user'>User:</label></td><td valign='top' class='value ${hasErrors(bean:jsecUserRoleRel,field:'user','errors')}'><g:select optionKey="id" from="${JsecUser.list()}" name='user.id' value="${jsecUserRoleRel?.user?.id}" ></g:select></td></tr>
                        
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
