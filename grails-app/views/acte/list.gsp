  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Liste des Actes</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouvel Acte</g:link></span>
        </div>
		</g:if>
    <g:if test="${params.nostyle!='true'}">
        <div class="searchbox">
            <g:form border="0" url='[controller: "acte", action: "search"]'   id="acteSearch" name="acteSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
                <etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Num ou Nom Acte" lookup="true" controller="acte"/>
            </g:form>
        </div>
    </g:if>
        <div class="body">
            <h1>Liste des Actes</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="numRepertoire" title="Num. R&eacute;pertoire" />
                        

                   	        <g:sortableColumn property="dossier" title="Dossier" />
                        
                   	        <g:sortableColumn property="dateCreation" title="Date Cr&eacute;ation" />
							
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${acteList}" status="i" var="acte">
						<etude:tr ctrl="acte" id="${acte.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
							<td><etude:linkActe acte="${acte}" display="${acte.numRepertoire?.encodeAsHTML()}"/></td>
							<td>${acte.dossier?.encodeAsHTML()}</td>
							<td class="dateCell"><etude:relativeDate date="${acte.dateCreation}"/></td>
						</etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${count}" params="${params}"/>
            </div>
        </div>
    </body>
</html>