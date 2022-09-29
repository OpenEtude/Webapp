

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><etude:traduction name="TypeDeBien.list" default="Liste des Type De Biens"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
		<div class="searchbox">
			<g:form border="0" url='[controller: "typeDeBien", action: "search"]'   id="typeDeBienSearch" name="typeDeBienSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
						<etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Nom typeDeBien" lookup="true" controller="typeDeBien"/>
			</g:form>
		</div>
        <div class="nav">
                        
			<span class="menuButton"><g:link action="create"><g:message code="domain.TypeDeBien.new" default="Nouveau type de bien" /><span class="database_add ico"></span></g:link></span>
			<g:if test="${params.mode=='select'}">
			<span class="menuButton"><g:link controller="${ParamUtils.class2prop(params.addTo)}" action="show" id="${params.id}"><etude:traduction name="${params.addTo}.backTo" default="Retour"/><span class="database_edit ico"></span></g:link></span>
			</g:if>
		</div>
		</g:if>
        <div class="body">
            <h1><g:if test="${params.mode!='select'}"><etude:traduction name="TypeDeBien.list" default="Liste des Type De Biens"/></g:if><g:else><etude:traduction name="TypeDeBien.selectMany" default="Ajout de Type De Biens"/></g:else></h1>

			<g:form accept-charset="UTF-8" controller="${ParamUtils.class2prop(params.addTo) ?: 'typeDeBien'}" method="post" >
			<g:if test="${params.mode=='select'}">
			<input type="hidden" name="listSize" value="${typeDeBienList.size()}" />
			<input type="hidden" name="${ParamUtils.class2prop(params.addTo)}.id" value="${params.id}" />
			<div class="buttons">
				<div  style="width:100%;text-align:right;padding-right:20px">
				<span class="button">
				<span class="menuButton"><a href="#" class="selectall">S&eacute;lectionner Tout</a></span>&nbsp;|&nbsp;
				<span class="menuButton"><a href="#" class="selectnone">Aucune S&eacute;lection</a></span>&nbsp;|&nbsp;
				<g:actionSubmit class="validate" action="addManyTypeDeBien" value="Ajouter la s&eacute;lection" /></span>
				</div>
			</div>
			</g:if>

            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:if test="${!typeDeBienList.empty}">
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="libelle" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="Libelle" titleKey="typeDeBien.libelle" />
							<g:if test="${params.mode=='select'}">
                   	        <td/>
							</g:if>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${typeDeBienList}" status="i" var="typeDeBien">
						<etude:tr ctrl="typeDeBien" id="${typeDeBien.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${typeDeBien.id}">${typeDeBien.libelle?.encodeAsHTML()}</g:link></td>
                        
							<g:if test="${params.mode=='select'}">
                   	        <td class="checkfix">
								<input type="hidden" name="id${i}" value="${typeDeBien.id}" />
								<g:checkBox name="check${i}" value="${false}"/>
							</td>
							</g:if>
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${TypeDeBien.count()}" params="${paginateParams}" action="${params.q ? 'search' : 'list'}"/>
            </div>
	        </g:if>
			</g:form>
        </div>
    </body>
</html>
