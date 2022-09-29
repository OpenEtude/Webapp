


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><etude:traduction name="TypeDeBien"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
		<div class="searchbox">
			<g:form border="0" url='[controller: "typeDeBien", action: "search"]'   id="typeDeBienSearch" name="typeDeBienSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
						<etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Nom typeDeBien" lookup="true" controller="typeDeBien"/>
			</g:form>
		</div>
        <div class="nav">
            <span class="menuButton"><a href="${createLinkTo(dir:'')}"><span class="house"></span><g:message code="home" default="Acceuil" /></span><span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Types De Bien</g:link></span>
            <span class="menuButton"><g:link action="create"><g:message code="domain.TypeDeBien.new" default="Nouveau Type De Bien" /><span class="database_add ico"></span></g:link></span>
            <span class="menuButton"><mymodal:createLink sclass="database_add" controller='champ' params='["typeDeBien.id":typeDeBien?.id]' action='create' linkname="Ajout Champ"/></span>
			
        </div>
		</g:if>
        <div class="body">
            <h1><etude:traduction name="TypeDeBien"/> ${typeDeBien}</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

<tr class="prop">
<td valign="top" colspan="2" ><p><etude:traduction name="champs" default="Champs" />:</p><br/>
            <g:if test="${!listeChamps.empty}">
<div class="paginateButtons"></div>
<ul style="padding-left:0px;">
<g:each var="champ" in="${listeChamps}" status="i">
<li class="${(i % 2) == 0 ? 'odd' : 'even'}"><g:link controller="champ" action="show" id="${champ.id}">${champ}
</g:link><g:form accept-charset="UTF-8" style="display:inline">
<g:hiddenField name="id" value="${champ.id}"/>
<g:actionSubmit class="searchbutton database_delete" onclick="return confirm('Etes-vous sur de vouloir dissocier?');" title="Dissocier" value="delete" action="removeChamp"/><br/><span class="tip">${champ.description}</span></span>
</g:form></li>
</g:each>
</ul>
<div class="paginateButtons"></div>
</div>
						</g:if>
                            </td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${typeDeBien?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
