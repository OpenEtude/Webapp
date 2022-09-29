

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><etude:traduction name="Client.list" default="Liste des Clients"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
		<div class="nav">
			<span class="menuButton"><g:link action="create"><span class="database_add ico"></span><g:message code="domain.Client.new" default="Nouveau Client" /></g:link></span>
			<g:if test="${params.mode=='select'}">
				<span class="menuButton"><g:link controller="${ParamUtils.class2prop(params.addTo)}" action="show" id="${params.id}"><etude:traduction name="${params.addTo}.backTo" default="Retour"/><span class="database_edit ico"></span></g:link></span>
			</g:if>
		</div>
		<div class="searchbox">
			<g:form border="0" url='[controller: "client", action: "search"]'   id="clientSearch" name="clientSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
						<etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Nom client" lookup="true" controller="client"/>
			</g:form>
		</div>
		</g:if>
        <div class="body">
            <h1><g:if test="${params.mode!='select'}"><etude:traduction name="Client.list" default="Liste des Clients"/></g:if><g:else><etude:traduction name="Client.selectMany" default="Ajout de Clients"/></g:else></h1>

			<g:form accept-charset="UTF-8" controller="${ParamUtils.class2prop(params.addTo) ?: 'client'}" method="post" >
			<g:if test="${params.mode=='select'}">
			<input type="hidden" name="listSize" value="${clientList.size()}" />
			<input type="hidden" name="${ParamUtils.class2prop(params.addTo)}.id" value="${params.id}" />
			<div class="buttons">
				<div  style="width:100%;text-align:right;padding-right:20px">
				<span class="button">
				<span class="menuButton"><a href="#" class="selectall">S&eacute;lectionner Tout</a></span>&nbsp;|&nbsp;
				<span class="menuButton"><a href="#" class="selectnone">Aucune S&eacute;lection</a></span>&nbsp;|&nbsp;
				<g:actionSubmit class="validate" action="addManyClient" value="Ajouter la s&eacute;lection" /></span>
				</div>
			</div>
			</g:if>

            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:if test="${!clientList.empty}">
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <th><etude:traduction name="civilite" default="Civilite" /></th>
                   	    
                   	        <g:sortableColumn property="nom" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="Nom" titleKey="client.nom" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${clientList}" status="i" var="client">
						<etude:tr ctrl="client" id="${client.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${client.id}">${client.civilite?.encodeAsHTML()}</g:link></td>
                        
                            <td>${client.nom?.encodeAsHTML()}</td>
                        
							<g:if test="${params.mode=='select'}">
                   	        <td class="checkfix">
								<input type="hidden" name="id${i}" value="${client.id}" />
								<g:checkBox name="check${i}" value="${false}"/>
							</td>
							</g:if>
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Client.count()}" params="${paginateParams}" action="${params.q ? 'search' : 'list'}"/>
            </div>
	        </g:if>
			</g:form>
        </div>
    </body>
</html>
