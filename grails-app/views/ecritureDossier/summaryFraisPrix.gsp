  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle!='true' ? 'main' : 'nostyle'}" />
        <title>Synth&egrave;se Frais - Prix</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="summary"><span class="database_table ico"></span>Synth&egrave;se des Ecritures de Dossier</g:link></span>
            <span class="menuButton"><g:link action="detailFraisPrix"><span class="database_table ico"></span>D&eacute;tail Frais - Prix</g:link></span>
            <span class="menuButton"><g:link action="summaryFraisPrix" params="[format:'xls']"><span class="xls ico"></span>Export</g:link></span>
        </div>
		</g:if>
        <div class="body">
            <h1>Synth&egrave;se Frais - Prix</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
							<th>Type de compte</th>
		
                   	        <th>Solde</th>

                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${syn}" status="i" var="entry">
                        <tr class="${entry.categorieEcriture?.id==1?'frais':'prix'}${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><span style="font-size:12px;font-weight:bold;">${entry.categorieEcriture?.encodeAsHTML()}</span></td>
                        
                            <td class="moneyCell"><span style="font-size:12px;font-weight:bold;color:${entry.solde < 0 ? 'red' : 'green'}"><g:formatNumber number="${entry.solde}" format="###,##0.00 DH" /></span></td>
							
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons"/>
        </div>
    </body>
</html>
