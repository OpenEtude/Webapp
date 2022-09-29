


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><etude:traduction name="Champ"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
		<div class="searchbox">
			<g:form border="0" url='[controller: "champ", action: "search"]'   id="champSearch" name="champSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
						<etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Nom champ" lookup="true" controller="champ"/>
			</g:form>
		</div>
        <div class="nav">
            <span class="menuButton"><a href="${createLinkTo(dir:'')}"><span class="house"></span><g:message code="home" default="Acceuil" /></span><span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Champs</g:link></span>
            <span class="menuButton"><g:link action="create"><g:message code="domain.Champ.new" default="Nouveau Champ" /><span class="database_add ico"></span></g:link></span>
        </div>
		</g:if>
        <div class="body">
            <h1><etude:traduction name="Champ"/> ${champ}</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

<tr class="prop">

<td valign="top" class="name"><etude:traduction name="libelle" default="Libelle" />:</td>


                            <td valign="top" class="value">${champ.libelle}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="settingType" default="Type de donn&eacute;es" />:</td>


                            <td valign="top" class="value">${g.message(code:'champ.settingType.'+champ.settingType)}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="ordre" default="Ordre d'affichage" />:</td>


                            <td valign="top" class="value">${champ.ordre}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="defaultValue" default="Default Value" />:</td>


                            <td valign="top" class="value">${champ.defaultValue}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="description" default="Description" />:</td>


                            <td valign="top" class="value">${champ.description}</td>
                            
                        </tr>
<td valign="top" class="name"><etude:traduction name="typeDeBien" default="Type De Bien" />:</td>


                            <td valign="top" class="value">${champ.typeDeBien}</td>
                            
                        </tr>
                    

                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${champ?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
