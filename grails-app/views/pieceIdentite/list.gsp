  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Liste PieceIdentite</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau PieceIdentite</g:link></span>
        </div>
        <div class="body">
            <h1>Liste PieceIdentite</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="libelle" title="Libelle" />
                        
                        	<td/>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${pieceIdentiteList}" status="i" var="pieceIdentite">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${pieceIdentite.id}">${pieceIdentite.id?.encodeAsHTML()}</g:link></td>
                        
                            <td>${pieceIdentite.libelle?.encodeAsHTML()}</td>
                        
												<td><g:link action="show" id="${pieceIdentite.id}" class="noprint show">Afficher</g:link></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${PieceIdentite.count()}" />
            </div>
        </div>
    </body>
</html>
