  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Groupements d'&eacute;critures</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau Groupement</g:link></span>
            <span class="menuButton"><g:link controller="ecritureDossier" action="critereGroupement"><span class="database_table ico"></span>Rapport de groupements d'Ecritures</g:link></span>
        </div>
        <div class="body">
            <h1>Groupements d'&eacute;critures</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                   	        <g:sortableColumn property="libelle" title="Libell&eacute;" />
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${groupementList}" status="i" var="groupement">
			<etude:tr ctrl="groupement" id="${groupement.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><g:link controller="groupement" action="show" id="${groupement.id}">${groupement.libelle?.encodeAsHTML()}</g:link></td>
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Groupement.count()}" />
            </div>
        </div>
    </body>
</html>
