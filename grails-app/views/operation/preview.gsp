<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
</head>
<body>
<g:if test="${!listeBiens.empty}">
<table class="reallysmall"><thead><th><etude:traduction name="bien" default="Bien" /></th><th><etude:traduction name="dossiers" default="Dossier affect&eacute;" /></th></thead><tbody>
<g:each var="bien" in="${listeBiens}" status="j">
<% ecritures  = bien.dossier ? ecrituresOperation.get(bien.dossier) :[] %>
<tr class="${(j % 2) == 0 ? 'odd' : 'even'}"><td style="white-space:nowrap"><etude:previewIcon id="bienop${bien.id}" icon="bien${bien.dossier ? 'affecte' : 'libre'}" title="Bien ${bien.libelle ?: 'non d&eacute;fini'}" controller="bien" id="${bien.id}"/><g:link class="modal" controller="bien" action="edit" params="['id':bien.id]">${bien.libelle}</g:link></td><td><g:if test="${bien.dossier}"><etude:linkDossier dossier="${bien.dossier}"/>
</g:if><ul><g:if test="${!ecritures?.empty}"><br/></g:if><g:each var="ecritureDossier" in="${ecritures}" status="i">
						<li class="${ecritureDossier.typeEcriture.categorieEcriture.id==1 ? 'frais':'prix'}${(i % 2) == 0 ? 'odd' : 'even'}"><span class="${etude.mpIcon(mp:ecritureDossier.moyenPaiement)}"></span><span class="${etude.etatIcon(etat:ecritureDossier.etat)}"></span><g:link controller="ecritureDossier" action="show" id="${ecritureDossier?.id}" title="Dossier :&nbsp;${ecritureDossier?.dossier?.encodeAsHTML()}">${ecritureDossier?.encodeAsHTML()}</g:link></li>
						</g:each></ul><g:if test="${bien.dossier}"><div style="text-align:right;"><b style="font-size:12px;">Solde Prix: <span style="font-size:12px;color:${dossierSoldesPrix.get(bien.dossier) < 0 ? 'red' : 'green'}"><g:formatNumber number="${dossierSoldesPrix.get(bien.dossier)}" format="###,##0.00 DH" /></span></b></div></g:if></td></tr>
</g:each></tbody>
</table>
</g:if>
<g:if test="${!listeDossiers.empty}">
<table class="reallysmall"><thead><th>Dossiers non affect&eacute;s</th></thead>
<g:each var="dossier" in="${listeDossiers}" status="i">
<tr class="${(i % 2) == 0 ? 'odd' : 'even'}"><td><etude:linkDossier dossier="${dossier}"/>
</g:each>
</table>
</g:if>
</body>
</html>
