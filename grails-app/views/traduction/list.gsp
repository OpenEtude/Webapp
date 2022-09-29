

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><g:message code="traduction.list" default="Traduction List" /></title>
    </head>
    <body>
        <div class="nav">
            
</span>
        </div>
        <div class="body">
            <h1>Param&egrave;tres</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="description" title="Description" titleKey="traduction.description" />
                        
                   	        <g:sortableColumn property="trad" title="Libell&eacute;" titleKey="traduction.trad" />

                   	        <th/>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${traductionList}" status="i" var="traduction">
						<etude:tr ctrl="traduction" id="${traduction.id}" actionName="edit" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td>${traduction.description}</td>
                            <td>${traduction.trad}</td>
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Traduction.count()}" />
            </div>
        </div>
    </body>
</html>
