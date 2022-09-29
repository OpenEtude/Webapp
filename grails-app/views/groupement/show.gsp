  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Groupement : ${groupement.libelle}</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste Groupement</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau Groupement</g:link></span>
            <span class="menuButton"><g:link controller="ecritureDossier" action="critereGroupement"><span class="database_table ico"></span>Rapport de groupements d'Ecritures</g:link></span>
        </div>
        <div class="body">
            <h1>Groupement : ${groupement.libelle}</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Libell&eacute;:</td>
                            
                            <td valign="top" class="value">${groupement.libelle}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
	            <div class="list">
	                <table>
	                    <thead>
	                        <tr>
								<g:sortableColumn property="typeEcriture" title="Libell&eacute;" />
			
	                   	        <th></th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                    <g:each in="${allLibelles}" status="i" var="typeEcriture">
	                        <tr class="${typeEcriture.categorieEcriture?.id==1?'frais':'prix'}${(i % 2) == 0 ? 'odd' : 'even'}">
	                        
								<td>${typeEcriture.encodeAsHTML()}</td>
	                        
	                   	        <td class="checkfix">
									<input type="hidden" name="id${i}" value="${typeEcriture?.id}" />
									<g:if test="${libelles.find{it.id==typeEcriture.id}}"><b>x</b></g:if>
								</td>

	                        </tr>
	                    </g:each>
	                    </tbody>
	                </table>
	            </div>
            </div>
            <div class="buttons">
                <g:form accept-charset="UTF-8"   controller="groupement" method="post">
                    <input type="hidden" name="id" value="${groupement?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" action="delete" value="Supprimer" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
