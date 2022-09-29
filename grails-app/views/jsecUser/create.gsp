  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Nouvel Utilisateur</title>         
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste Utilisateurs</g:link></span>
        </div>
        <div class="body">
            <h1>Nouvel Utilisateur</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${jsecUser}">
            <div class="errors">
                <g:renderErrors bean="${jsecUser}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='username'>Nom de l'utilisateur:</label></td><td valign='top' class='value ${hasErrors(bean:jsecUser,field:'username','errors')}'><input type="text" id='username' name='username' value="${jsecUser?.username?.encodeAsHTML()}"/>
							    <input type="hidden" name="nbRoles" value="${allRoles.size()}" />
							</td></tr>
	                        <tr>
								<td valign="top" class="name">R&ocirc;les:</td>
							</tr>
	                    <g:each in="${allRoles}" var="role" status="i">
	                        <tr>
								<td></td>
	                            <td valign="top">
									<input type="hidden" name="role${i}" value="${role.id}" />
									<g:checkBox name="check${i}" value="${false}"/>
									<label for="check${i}">${role.name.encodeAsHTML()}</label>
								</td>
	                        </tr>
	                    </g:each>
                        
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
