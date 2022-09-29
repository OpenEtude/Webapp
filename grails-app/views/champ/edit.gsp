

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier <etude:traduction name="Champ"/></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a href="${createLinkTo(dir:'')}"><span class="house"></span><g:message code="home" default="Acceuil" /></span><span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Champs</g:link></span>
            <span class="menuButton"><g:link action="create"><g:message code="domain.Champ.new" default="Nouveau Champ" /><span class="database_add ico"></span></g:link></span>
        </div>
        <div class="body">
            <h1>Modifier <etude:traduction name="Champ"/></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${champ}">
            <div class="errors">
                <g:renderErrors bean="${champ}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${champ?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="libelle"><etude:traduction name="libelle" default="Libelle" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:champ,field:'libelle','errors')}">
                                    <input type="text" id="libelle" name="libelle" value="${fieldValue(bean:champ,field:'libelle')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="ordre"><etude:traduction name="ordre" default="Ordre d'affichage" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:champ,field:'ordre','errors')}">
								
		                                    <input type="text" id="ordre" name="ordre" value="${fieldValue(bean:champ,field:'ordre')}"/>
								
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="settingType"><etude:traduction name="settingType" default="Type de donn&eacute;e" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:champ,field:'settingType','errors')}">
                                    <g:select id="settingType" name="settingType" from="${champ.constraints.settingType.inList.collect{it.encodeAsHTML()}}" value="${fieldValue(bean:champ,field:'settingType')}" valueMessagePrefix="champ.settingType" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="defaultValue"><etude:traduction name="defaultValue" default="Default Value" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:champ,field:'defaultValue','errors')}">
                                    <input type="text" id="defaultValue" name="defaultValue" value="${fieldValue(bean:champ,field:'defaultValue')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><etude:traduction name="description" default="Description" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:champ,field:'description','errors')}">
                                    <textarea id="description" name="description">${fieldValue(bean:champ,field:'description')}</textarea>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="typeDeBien"><etude:traduction name="typeDeBien" default="Type De Bien" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:champ,field:'typeDeBiens','errors')}">
										${champ.typeDeBien?.encodeAsHTML()}
                                </td>
                            </tr> 
                        
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
