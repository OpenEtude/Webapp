


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><etude:traduction name="Valeur"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
		<div class="searchbox">
			<g:form border="0" url='[controller: "valeur", action: "search"]'   id="valeurSearch" name="valeurSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
						<etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Nom valeur" lookup="true" controller="valeur"/>
			</g:form>
		</div>
        <div class="nav">
            <span class="menuButton"><a href="${createLinkTo(dir:'')}"><span class="house"></span><g:message code="home" default="Acceuil" /></span><span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Valeurs</g:link></span>
            <span class="menuButton"><g:link action="create"><g:message code="domain.Valeur.new" default="Nouveau Valeur" /><span class="database_add ico"></span></g:link></span>
        </div>
		</g:if>
        <div class="body">
            <h1><etude:traduction name="Valeur"/> ${valeur}</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

<tr class="prop">

<td valign="top" class="name"><etude:traduction name="contenu" default="Contenu" />:</td>


                            <td valign="top" class="value">${valeur.contenu}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="bien" default="Bien" />:</td>


                            <td valign="top" class="value"><g:link controller="bien" action="show" id="${valeur?.bien?.id}" class="show">${valeur?.bien}</g:link></td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="champ" default="Champ" />:</td>


                            <td valign="top" class="value"><g:link controller="champ" action="show" id="${valeur?.champ?.id}" class="show">${valeur?.champ}</g:link></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${valeur?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
