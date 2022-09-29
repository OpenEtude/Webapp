<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>${(actionName=="list") ? "Mes Pr&eacute;f&eacute;rences" : "Configuration avanc&eacute;e"}</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
        </div>
		</g:if>
        <div class="body">
            <h1>${(actionName=="list") ?(params.pwdOnly ? "Mot de passe" :  "Mes Pr&eacute;f&eacute;rences") : "Configuration avanc&eacute;e"}</h1>
            <g:if test="${flash.message}">
                <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <g:if test="${actionName=='list'}">
                <div class="main">
                    <div class="dialog">
                        <h2>Changement de Mot de Passe</h2>
                        <g:form accept-charset="UTF-8" action="updatePwd" method="post" >
                            <input type="hidden" name="targetUri" value="${targetUri}" />
                            <table cellspacing="0">
                                <tbody>
                                <tr>
                                    <td colspan="2"></td>
                                </tr>
                                <tr class='prop'>
                                    <td style="padding-top:20px">Utilisateur:</td>
                                    <td style="padding-top:20px">${username}</td>
                                    <input type="hidden" name="username" value="${username}" />
                                </tr>
                                <tr class='prop'>
                                    <td>Ancien Mot de Passe:</td>
                                    <td><input type="password" name="password" value="" /></td>
                                </td>
                                <tr class='prop'>
                                    <td>Nouveau Mot de Passe:</td>
                                    <td><input type="password" name="password1" value="" /></td>
                                </td>
                                <tr class='prop'>
                                    <td>R&eacute;peter le Nouveau Mot de Passe:</td>
                                    <td><input type="password" name="password2" value="" /></td>
                                </td>
                                </tbody>
                            </table>
                            <div class="buttons">
                                <span class="button"><input type="submit" value="Valider le changement" /></span>
                            </div>
                        </g:form>
                    </div>
                </div>
            </g:if>
            <g:if test="${!params.pwdOnly}">
                <g:form name="prefs" id="prefs" method="post" >
                    <g:hiddenField name="user.id" value="${setting?.user?.id}"/>
                    <g:if test="${actionName=='syslist'}">
                        <g:hiddenField name="from" value="syslist"/>
                    </g:if>
                    <g:if test="${comebackTo}">
                        <g:hiddenField name="comebackTo" value="${comebackTo}"/>
                    </g:if>
                    <div class="dialog">
                        <h2>Mes préferences</h2>
                        <etude:tabPane>
                            <g:each in="${settingList}" var="entry">
                                <etude:tab code="${entry.key?.toString()}"/>
                            </g:each>
                        </etude:tabPane>
                        <g:each in="${settingList}" status="i" var="entry">
                            <etude:tabContent code="${entry.key?.toString()}" class="dialog setting">
                                <table>
                                    <tbody>
                                    <g:each in="${entry.value}" status="j" var="categEntry">
                                        <fieldset>
                                            <legend class="tip"><b><g:message code="${categEntry.key.toString()}" default="${categEntry.key}"/></b></legend>
                                            <table>
                                                <tbody>
                                                <g:each in="${categEntry.value}" status="k" var="setting">
                                                    <g:set var="canEdit" value="${false}" />
                                                    <g:if test="${setting.permissionType}">
                                                        <jsec:hasPermission type="${setting.permissionType}" target="${setting.permissionTarget}" actions="${setting.permissionActions}">
                                                            <g:set var="canEdit" value="${true}" />
                                                        </jsec:hasPermission>
                                                    </g:if>
                                                    <g:else>
                                                        <g:set var="canEdit" value="${true}" />
                                                    </g:else>
                                                    <g:set var="canEdit" value="${canEdit && (g.message(code:setting?.key)!=setting?.key)}" />
                                                    <g:if test="${canEdit == true}">
                                                        <etude:edit
                                                                label="${g.message(code:fieldValue(bean:setting,field:'key').toString())}"
                                                                name="setting_value${setting?.id}"
                                                                dbId="${setting.id}"
                                                                type="${setting.settingType}"
                                                                value="${fieldValue(bean:setting,field:'value')}"
                                                                desc="${g.message(code:setting.key+'.hint',encodeAs:'JavaScript','default':'')}"
                                                                defValue="${setting.defaultValue}" style="width:250px;vertical-align:middle;"
                                                                class="${setting.key}"/>
                                                    </g:if>
                                                </g:each>
                                                </tbody>
                                            </table>
                                        </fieldset>
                                    </g:each>
                                    </tbody>
                                </table>
                            </etude:tabContent>
                        </g:each>
                        <div class="buttons">
                            <span class="button"><g:actionSubmit value="Enregistrer" action="update"/></span>
                        </div>
                    </div>
                </g:form>
            </g:if>
          </div>
    </body>
</html>
