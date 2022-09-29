  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Liste CategorieEcriture</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau CategorieEcriture</g:link></span>
        </div>
        <div class="body">
            <h1>Liste CategorieEcriture</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="libelle" title="Libelle" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${categorieEcritureList}" status="i" var="categorieEcriture">
						<etude:tr ctrl="categorieEcriture" id="${categorieEcriture.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${categorieEcriture.id}">${categorieEcriture.id?.encodeAsHTML()}</g:link></td>
                        
                            <td>${categorieEcriture.libelle?.encodeAsHTML()}</td>
                        
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${CategorieEcriture.count()}" />
            </div>
        </div>
    </body>
</html>
