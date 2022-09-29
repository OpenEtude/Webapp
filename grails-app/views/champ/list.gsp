

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><etude:traduction name="Champ.list" default="Liste des Champs"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
		<div class="searchbox">
			<g:form border="0" url='[controller: "champ", action: "search"]'   id="champSearch" name="champSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
						<etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Nom champ" lookup="true" controller="champ"/>
			</g:form>
		</div>
        <div class="nav">
                        
			<span class="menuButton"><g:link action="create"><g:message code="domain.Champ.new" default="Nouveau Champ" /><span class="database_add ico"></span></g:link></span>
			<g:if test="${params.mode=='select'}">
			<span class="menuButton"><g:link controller="${ParamUtils.class2prop(params.addTo)}" action="show" id="${params.id}"><etude:traduction name="${params.addTo}.backTo" default="Retour"/><span class="database_edit ico"></span></g:link></span>
			</g:if>
		</div>
		</g:if>
        <div class="body">
            <h1><g:if test="${params.mode!='select'}"><etude:traduction name="Champ.list" default="Liste des Champs"/></g:if><g:else><etude:traduction name="Champ.selectMany" default="Ajout de Champs"/></g:else></h1>

			<g:form accept-charset="UTF-8" controller="${ParamUtils.class2prop(params.addTo) ?: 'champ'}" method="post" >
			<g:if test="${params.mode=='select'}">
			<input type="hidden" name="listSize" value="${champList.size()}" />
			<input type="hidden" name="${ParamUtils.class2prop(params.addTo)}.id" value="${params.id}" />
			<div class="buttons">
				<div  style="width:100%;text-align:right;padding-right:20px">
				<span class="button">
				<span class="menuButton"><a href="#" class="selectall">S&eacute;lectionner Tout</a></span>&nbsp;|&nbsp;
				<span class="menuButton"><a href="#" class="selectnone">Aucune S&eacute;lection</a></span>&nbsp;|&nbsp;
				<g:actionSubmit class="validate" action="addManyChamp" value="Ajouter la s&eacute;lection" /></span>
				</div>
			</div>
			</g:if>

            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:if test="${!champList.empty}">
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="libelle" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="Libelle" titleKey="champ.libelle" />
                        
                   	        <g:sortableColumn property="settingType" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="Type de Donn&eacute;e" titleKey="champ.settingType" />
                        
                   	        <g:sortableColumn property="defaultValue" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="Default Value" titleKey="champ.defaultValue" />
                        
                   	        <g:sortableColumn property="description" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="Description" titleKey="champ.description" />
                        
                   	        <th><etude:traduction name="typeDeBien" default="Type De Bien" /></th>
                   	    
                   	        <g:sortableColumn property="ordre" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="Ordre" titleKey="champ.ordre" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${champList}" status="i" var="champ">
						<etude:tr ctrl="champ" id="${champ.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${champ.id}">${champ.libelle?.encodeAsHTML()}</g:link></td>
                        
                            <td>${g.message(code:('champ.settingType.' + champ.settingType))}</td>
                        
                            <td>${champ.defaultValue?.encodeAsHTML()}</td>
                        
                            <td>${champ.description?.encodeAsHTML()}</td>
                        
                            <td>${champ.typeDeBien?.toString().encodeAsHTML()}</td>
                        
                            <td>${champ.ordre.encodeAsHTML()}</td>
                        
							<g:if test="${params.mode=='select'}">
                   	        <td class="checkfix">
								<input type="hidden" name="id${i}" value="${champ.id}" />
								<g:checkBox name="check${i}" value="${false}"/>
							</td>
							</g:if>
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Champ.count()}" params="${paginateParams}" action="${params.q ? 'search' : 'list'}"/>
            </div>
	        </g:if>
			</g:form>
        </div>
    </body>
</html>
