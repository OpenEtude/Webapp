

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><etude:traduction name="Operation.list" default="Liste des Operations"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
                        
			<span class="menuButton"><g:link class="modal" controller="client" action="list"><span class="database_table ico"></span><g:message code="domain.Client.list" default="Clients" /></g:link></span>
			<span class="menuButton"><g:link class="modal" action="create"><span class="database_add ico"></span><g:message code="domain.Operation.new" default="Nouvelle Operation" /></g:link></span>
			<span class="menuButton"><g:link controller="client" action="create"><span class="database_add ico"></span><g:message code="domain.Client.new" default="Nouveau Client" /></g:link></span>
			<g:if test="${params.mode=='select'}">
			<span class="menuButton"><g:link controller="${ParamUtils.class2prop(params.addTo)}" action="show" id="${params.id}"><span class="database_edit ico"></span><etude:traduction name="${params.addTo}.backTo" default="Retour"/></g:link></span>
			</g:if>
		</div>
		</g:if>
        <div class="body">
            <h1><g:if test="${params.mode!='select'}"><etude:traduction name="Operation.list" default="Liste des Operations"/></g:if><g:else><etude:traduction name="Operation.selectMany" default="Ajout de Operations"/></g:else></h1>

			<g:form accept-charset="UTF-8" controller="${ParamUtils.class2prop(params.addTo) ?: 'operation'}" method="post" >
			<g:if test="${params.mode=='select'}">
			<input type="hidden" name="listSize" value="${operationList.size()}" />
			<input type="hidden" name="${ParamUtils.class2prop(params.addTo)}.id" value="${params.id}" />
			<div class="buttons">
				<div  style="width:100%;text-align:right;padding-right:20px">
				<span class="button">
				<span class="menuButton"><a href="#" class="selectall">S&eacute;lectionner Tout</a></span>&nbsp;|&nbsp;
				<span class="menuButton"><a href="#" class="selectnone">Aucune S&eacute;lection</a></span>&nbsp;|&nbsp;
				<g:actionSubmit class="validate" action="addManyOperation" value="Ajouter la s&eacute;lection" /></span>
				</div>
			</div>
			</g:if>

            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:if test="${!operationList.empty}">
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="libelle" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="Libelle" titleKey="operation.libelle" />
                        
                   	        <th><etude:traduction name="client" default="Client" /></th>
                   	    
                   	        <g:sortableColumn property="description" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="Description" titleKey="operation.description" />
                        
                   	        <g:sortableColumn property="dateCreation" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="Date Creation" titleKey="operation.dateCreation" />
                        
							<g:if test="${params.mode=='select'}">
							<th/>
							</g:if>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${operationList}" status="i" var="operation">
						<etude:tr ctrl="operation" id="${operation.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><etude:linkOperation operation="${operation}"/></td>
                        
                            <td>${operation.client?.encodeAsHTML()}</td>
                        
                            <td>${operation.description?.encodeAsHTML()}</td>
                        
                            <td><etude:relativeDate date="${operation.dateCreation}"/></td>
                        
							<g:if test="${params.mode=='select'}">
                   	        <td class="checkfix">
								<input type="hidden" name="id${i}" value="${operation.id}" />
								<g:checkBox name="check${i}" value="${false}"/>
							</td>
							</g:if>
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Operation.count()}" params="${paginateParams}" action="${params.q ? 'search' : 'list'}"/>
            </div>
	        </g:if>
			</g:form>
        </div>
    </body>
</html>
