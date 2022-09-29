


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><etude:traduction name="Bien"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            <span class="menuButton"><span class="house"></span><a href="${createLinkTo(dir:'')}"><g:message code="home" default="Acceuil" /></span><span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Biens</g:link></span>
            <span class="menuButton"><g:link action="create"><g:message code="domain.Bien.new" default="Nouveau Bien" /><span class="database_add ico"></span></g:link></span>
            <span class="menuButton"><mymodal:createLink sclass="database_add" controller='valeur' params='["bien.id":bien?.id]' action='create' linkname="Ajout Valeur"/></span>
			
        </div>
		</g:if>
        <div class="body">
            <h1><etude:traduction name="Bien"/> ${bien}</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

<tr class="prop">
					
<td valign="top" class="name"><etude:traduction name="bien.libelle" default="Titre foncier" />:</td>


                            <td valign="top" class="value">${bien.libelle}</td>
                            
                        </tr>
                    

<tr class="prop">
					
<td valign="top" class="name"><etude:traduction name="typeDeBien" default="Type De Bien" />:</td>


                            <td valign="top" class="value"><g:link controller="typeDeBien" action="show" id="${bien?.typeDeBien?.id}" class="show">${bien?.typeDeBien}</g:link></td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="operation" default="Operation" />:</td>


                            <td valign="top" class="value"><etude:previewIcon icon="database_table" title="${bien.operation}" controller="operation" id="${bien.operation?.id}"/><g:link controller="operation" action="show" id="${bien?.operation?.id}" class="show">${bien?.operation}</g:link></td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="dossier" default="Dossier" />:</td>


                            <td valign="top" class="value"><etude:linkDossier dossier="${bien.dossier}"/></td>
                            
                        </tr>
                    
<tr class="prop">


<g:each var="v" in="${bien?.valeurs}">
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="valeurs">${v.champ.libelle}:</label>
                                </td>
                                <td valign="top" class="value">
                                    <label for="valeurs">${v.contenu?.encodeAsHTML()}</label>
                                </td>
                            </tr> 
</g:each>
                            </td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${bien?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
