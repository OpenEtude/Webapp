

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier <etude:traduction name="Bien"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            <span class="menuButton"><a href="${createLinkTo(dir:'')}"><span class="house"></span><g:message code="home" default="Acceuil" /></span><span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Biens</g:link></span>
            <span class="menuButton"><g:link action="create"><g:message code="domain.Bien.new" default="Nouveau Bien" /><span class="database_add ico"></span></g:link></span>
        </div>
        </g:if>
        <div class="body">
            <h1>Modifier <etude:traduction name="Bien"/></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${bien}">
            <div class="errors">
                <g:renderErrors bean="${bien}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${bien?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="libelle"><etude:traduction name="bien.libelle" default="Titre foncier" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:bien,field:'libelle','errors')}">
                                    <input type="text" id="libelle" name="libelle" value="${fieldValue(bean:bien,field:'libelle')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="typeDeBien"><etude:traduction name="typeDeBien" default="Type De Bien" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:bien,field:'typeDeBien','errors')}">
                                    ${bien?.typeDeBien}
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="operation"><etude:traduction name="operation" default="Operation" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:bien,field:'operation','errors')}">
                                    ${bien?.operation}
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dossier"><etude:traduction name="dossier" default="Dossier" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:bien,field:'dossier','errors')}">
                                    <g:select optionKey="id" from="${Dossier.findAllByOperation(bien.operation)}" name="dossier.id" value="${bien?.dossier?.id}" noSelection="['null':'']"></g:select>
                                </td>
                            </tr> 
<g:each var="v" in="${bien?.valeurs}">
			<etude:edit 
			label="${v.champ.libelle}"  
			name="${'entry'+v.champ.id}"
			dbId="${v.champ.id}"
			type="${v.champ.settingType}"
			desc="${v.champ.description?.encodeAsJavaScript()}"
			value="${v.contenu}"
			defValue="${v.champ.defaultValue}"
			hideable="false"
			style='text-align:left'/>
</g:each>
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
