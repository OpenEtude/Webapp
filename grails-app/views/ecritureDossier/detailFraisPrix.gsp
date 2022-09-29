<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>D&eacute;tail Frais - Prix par dossier</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="summaryFraisPrix"><span class="database_table ico"></span>Synth&egrave;se Frais - Prix</g:link></span>
            <span class="menuButton"><g:link action="detailFraisPrix" params="[format:'xls',precision:params.precision]"><span class="xls ico"></span>Export</g:link></span>
        </div>
		<div class="searchbox">
			<g:form border="0" url='[action: "detailFraisPrix"]'   id="filtreDetailFraisPrix" name="filtreDetailFraisPrix"  accept-charset="UTF-8"  method="get" style="display:inline;">
						<etude:keyword name="precision" size="20" id="keybox" accesskey="f" value="${params.precision}" hint="Seuil du solde" title="Afficher les dossiers dont le solde est plus grand que ce seuil"/>
			</g:form>
		</div>
        <div class="body">
            <h1>D&eacute;tail Frais - Prix par dossier</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
							<th>Dossier</th>
							<th>Description</th>
                   	        <th>Frais</th>
                   	        <th>Prix</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${syn}" status="i" var="entry">
						<etude:tr ctrl="dossier" id="${entry.dossier.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><etude:linkDossier dossier="${entry.dossier}"/></td>
                            <td>${entry.dossier?.description?.encodeAsHTML()}</td>
                            <td class="moneyCell"><span style="font-size:12px;font-weight:bold;color:${entry.soldeFrais < 0.00f ? 'red' : 'green'}"><g:formatNumber number="${entry.soldeFrais}" format="###,##0.00 DH" /></span></td>
                            <td class="moneyCell"><span style="font-size:12px;font-weight:bold;color:${entry.soldePrix < 0.00f ? 'red' : 'green'}"><g:formatNumber number="${entry.soldePrix}" format="###,##0.00 DH" /></span></td>
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
