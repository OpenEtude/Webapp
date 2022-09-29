

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><etude:traduction name="Valeur.list" default="Liste des Valeurs"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
		<div class="searchbox">
			<g:form border="0" url='[controller: "valeur", action: "search"]'   id="valeurSearch" name="valeurSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
						<etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Nom valeur" lookup="true" controller="valeur"/>
			</g:form>
		</div>
        <div class="nav">
                        
			<span class="menuButton"><g:link action="create"><g:message code="domain.Valeur.new" default="Nouveau Valeur" /><span class="database_add ico"></span></g:link></span>
			<g:if test="${params.mode=='select'}">
			<span class="menuButton"><g:link controller="${ParamUtils.class2prop(params.addTo)}" action="show" id="${params.id}"><etude:traduction name="${params.addTo}.backTo" default="Retour"/><span class="database_edit ico"></span></g:link></span>
			</g:if>
		</div>
		</g:if>
        <div class="body">
            <h1><g:if test="${params.mode!='select'}"><etude:traduction name="Valeur.list" default="Liste des Valeurs"/></g:if><g:else><etude:traduction name="Valeur.selectMany" default="Ajout de Valeurs"/></g:else></h1>

			<g:form accept-charset="UTF-8" controller="${ParamUtils.class2prop(params.addTo) ?: 'valeur'}" method="post" >
			<g:if test="${params.mode=='select'}">
			<input type="hidden" name="listSize" value="${valeurList.size()}" />
			<input type="hidden" name="${ParamUtils.class2prop(params.addTo)}.id" value="${params.id}" />
			<div class="buttons">
				<div  style="width:100%;text-align:right;padding-right:20px">
				<span class="button">
				<span class="menuButton"><a href="#" class="selectall">S&eacute;lectionner Tout</a></span>&nbsp;|&nbsp;
				<span class="menuButton"><a href="#" class="selectnone">Aucune S&eacute;lection</a></span>&nbsp;|&nbsp;
				<g:actionSubmit class="validate" action="addManyValeur" value="Ajouter la s&eacute;lection" /></span>
				</div>
			</div>
			</g:if>

            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:if test="${!valeurList.empty}">
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="contenu" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="Contenu" titleKey="valeur.contenu" />
                        
                   	        <th><etude:traduction name="bien" default="Bien" /></th>
                   	    
                   	        <th><etude:traduction name="champ" default="Champ" /></th>
                   	    
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${valeurList}" status="i" var="valeur">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${valeur.id}">${valeur.contenu?.encodeAsHTML()}</g:link></td>
                        
                            <td>${valeur.bien?.encodeAsHTML()}</td>
                        
                            <td>${valeur.champ?.encodeAsHTML()}</td>
                        
							<g:if test="${params.mode!='select'}">
                            <td><g:link action="show" class="noprint show" id="${valeur.id}">Afficher</g:link></td>
							</g:if>
							<g:else>
                   	        <td class="checkfix">
								<input type="hidden" name="id${i}" value="${valeur.id}" />
								<g:checkBox name="check${i}" value="${false}"/>
							</td>
							</g:else>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Valeur.count()}" params="${paginateParams}" action="${params.q ? 'search' : 'list'}"/>
            </div>
	        </g:if>
			</g:form>
        </div>
    </body>
</html>
