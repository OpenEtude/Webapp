  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Synth&egrave;se des Ecritures de Dossier</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="summaryFraisPrix"><span class="database_table ico"></span>Synth&egrave;se Frais - Prix</g:link></span>
            <span class="menuButton"><g:link action="summary" params="[format:'xls']"><span class="xls ico"></span>Export</g:link></span>
        </div>
		</g:if>
        <div class="body">
            <h1>Synth&egrave;se des Ecritures de Dossier</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
							<th>Libell&eacute;</th>
		
                   	        <th>Total</th>

                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${syn}" status="i" var="entry">
                        <tr class="${entry.typeEcriture?.categorieEcriture?.id==1?'frais':'prix'}${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><b>${entry.typeEcriture?.encodeAsHTML()}</b></td>
                        
                            <td class="moneyCell"><b><g:formatNumber number="${entry.solde}" format="###,##0.00 DH" /></b></td>
							
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${TypeEcriture.count()}"/>
            </div>
        </div>
    </body>
</html>
