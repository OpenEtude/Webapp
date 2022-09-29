  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Liste Dossier</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau Dossier</g:link></span>
        </div>
        <div class="body">
            <h1>Liste Dossier</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="libelle" title="Libelle" />
                        
                   	        <g:sortableColumn property="description" title="Description" />
                        
                   	        <g:sortableColumn property="dateCreation" title="Date Creation" />
                        
                   	        <g:sortableColumn property="dateCloture" title="Date Cloture" />
                        
                   	        <th>Compte Attachement</th>
                   	    
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${dossierList}" status="i" var="dossier">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${dossier.id}">${dossier.id?.encodeAsHTML()}</g:link></td>
                        
                            <td>${dossier.libelle?.encodeAsHTML()}</td>
                        
                            <td>${dossier.description?.encodeAsHTML()}</td>
                        
                            <td class="dateCell"><etude:relativeDate sentence="true" date="${compte.dateCreation}"/></td>
                        
                            <td class="dateCell"><etude:relativeDate sentence="true" date="${compte.dateCloture}"/></td>
                        
                            <td>${dossier.compteAttachement?.encodeAsHTML()}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Dossier.count()}" />
            </div>
        </div>
    </body>
</html>
