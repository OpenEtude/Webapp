  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Liste TypeEcritureGroupementRel</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau TypeEcritureGroupementRel</g:link></span>
        </div>
        <div class="body">
            <h1>Liste TypeEcritureGroupementRel</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <th>Groupement</th>
                   	    
                   	        <th>Libell&eacute;</th>
                   	    
                        	<td/>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${typeEcritureGroupementRelList}" status="i" var="typeEcritureGroupementRel">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${typeEcritureGroupementRel.id}">${typeEcritureGroupementRel.id?.encodeAsHTML()}</g:link></td>
                        
                            <td>${typeEcritureGroupementRel.groupement?.encodeAsHTML()}</td>
                        
                            <td>${typeEcritureGroupementRel.typeEcriture?.encodeAsHTML()}</td>
                        
												<td><g:link action="show" id="${typeEcritureGroupementRel.id}" class="noprint show">Afficher</g:link></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${TypeEcritureGroupementRel.count()}" />
            </div>
        </div>
    </body>
</html>
