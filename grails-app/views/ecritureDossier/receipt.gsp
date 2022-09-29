  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
		<style type="text/css" media="print">
<!--
@media print {
	.logo {visibility:hidden;}
	.name, .value{font-size:13px;}
	.value{font-weight:bold;}
}
-->		</style>
        <title>Re&#231;u N&#176; <g:formatDate format="yy" date="${new Date()}"/>${ecritureDossier.dossier.id}-${ecritureDossier.id}</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste des Ecritures de Dossier</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouvelle Ecriture de Dossier</g:link></span>
        </div>
        <div class="body">
            <h1>Re&#231;u N&#176; <g:formatDate format="yy" date="${new Date()}"/>${ecritureDossier.dossier.id}-${ecritureDossier.id}</h1>
            <div class="dialog">
                <table>
                    <tbody>
						<g:if test="${null!=ecritureDossier.dossier}">
	                        <tr class="prop">
	                            <td valign="top" class="name">Dossier:</td>
	                            <td valign="top" class="value"><etude:linkDossier dossier="${ecritureDossier.dossier}"/></td>
	                        </tr>
						</g:if>
						<g:if test="${null!=ecritureDossier.acte}">
	                        <tr class="prop">
	                            <td valign="top" class="name">Acte:</td>
	                            <td valign="top" class="value">${ecritureDossier?.acte?.encodeAsHTML()}</td>
	                        </tr>
						</g:if>
                        <tr class="prop">
                            <td valign="top" class="name">Libell&eacute;:</td>
                            <td valign="top" class="value">${ecritureDossier?.typeEcriture?.libelle.encodeAsHTML()}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">Mode de r&eacute;glement:</td>
                            <td valign="top" class="value">${ecritureDossier?.moyenPaiement?.encodeAsHTML()}</td>
                        </tr>
						<g:if test="${null!=ecritureDossier.pieceComptable}">
                        <tr class="prop">
                            <td valign="top" class="name">Informations Paiement:</td>
                            <td valign="top" class="value">${ecritureDossier.pieceComptable?.encodeAsHTML()}</td>
                        </tr>
						</g:if>
                        <tr class="prop">
                            <td valign="top" class="name">Montant:</td>
                            <td valign="top" class="value"><g:formatNumber number="${ecritureDossier.montant}" format="###,##0.00 DH" /></td>
                        </tr>
                    
						<g:if test="${null!=ecritureDossier.dateValeur}">
	                        <tr class="prop">
	                            <td valign="top" class="name">Re&#231;u le:</td>
	                            <td valign="top" class="value"><g:formatDate format="dd MMM yyyy" date="${ecritureDossier.dateValeur}"/></td>
	                        </tr>
						</g:if>
						<g:if test="${null!=ecritureDossier.dateMouvement}">
	                        <tr class="prop">
	                            <td valign="top" class="name">Date d'encaissement:</td>
	                            <td valign="top" class="value"><g:formatDate format="dd MMM yyyy" date="${ecritureDossier.dateMouvement}"/></td>
	                        </tr>
						</g:if>
                        <tr class="prop">
                            <td valign="top" class="name"></td>
                            <td valign="top" class="value" style="padding-top:40px;padding-bottom:160px;padding-left:80px;">Fait le <g:formatDate format="dd MMMM yyyy" date="${new Date()}"/> &agrave; <etude:syssetting key="city"/> </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
