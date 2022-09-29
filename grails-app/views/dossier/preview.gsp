<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>${dossier.libelle}</title>
</head>
<body>
<p>Cr&eacute;e <etude:relativeDate sentence="true" date="${dossier.dateCreation}"/><g:if test="${dossier?.operation}">, op&eacute;ration <etude:linkOperation operation="${dossier.operation}"/></g:if><jsec:hasRole name="Maitre"><g:if test="${dossier.modele==true}">, le mod&egrave;le <i><mymodal:createLink controller='dossier' action="edit" params='["modele":"true", "id":dossier?.id]' linkname="${dossier.nomModele}"/></i> est bas&eacute; sur ce dossier.</g:if></jsec:hasRole></p>
<g:if test="${!listeFrais?.empty}">
<g:set var="debitFrais" value="${0.0f}" />
<g:set var="creditFrais" value="${0.0f}" />
<g:each in="${listeFrais}" status="i" var="ecritureDossier">
<g:if test="${ecritureDossier.montant && !ecritureDossier?.typeEcriture?.credit}">
<g:set var="debitFrais" value="${debitFrais + ecritureDossier.montant}" />
</g:if>
<g:if test="${ecritureDossier.montant && ecritureDossier?.typeEcriture?.credit}">
<g:if test="${ecritureDossier?.etat.id==2}"><g:set var="creditFrais" value="${creditFrais + ecritureDossier.montant}" /></g:if>
</g:if>
</g:each>
<p><b>Solde Frais:<span style="font-size:12px;color:${creditFrais < debitFrais? 'red' : 'green'}">
<g:formatNumber number="${creditFrais - debitFrais}" format="###,##0.00 DH" />
</span></b></p>
</g:if>
<g:if test="${!listePrix?.empty}">
<g:set var="debitPrix" value="${0.0f}" />
<g:set var="creditPrix" value="${0.0f}" />
<g:each in="${listePrix}" status="i" var="ecritureDossier">
<g:if test="${ecritureDossier.montant && !ecritureDossier?.typeEcriture?.credit}">
<g:set var="debitPrix" value="${debitPrix + ecritureDossier.montant}" />
</g:if>
<g:if test="${ecritureDossier.montant && ecritureDossier?.typeEcriture?.credit}">
<g:if test="${ecritureDossier?.etat.id==2}"><g:set var="creditPrix" value="${creditPrix + ecritureDossier.montant}" /></g:if>
</g:if>
</g:each>
<p><b>Solde Prix:<span style="font-size:12px;color:${creditPrix < debitPrix? 'red' : 'green'}">
<g:formatNumber number="${creditPrix - debitPrix}" format="###,##0.00 DH" />
</span></b></p>
</g:if>
<ul>
<g:each var="acte" in="${actes}">
<li ><etude:linkActe acte="${acte}"/></li>
</g:each>
</ul>
<g:if test="${dossier?.operation}">
<ul>
<g:each var="bien" in="${biens}">
<li ><etude:linkBien bien="${bien}"/></li>
</g:each>
</ul>
</div>
</g:if>
<p style="margin:2px;">
${dossier?.description}
</p>
</div>
</body>
</html>
