<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Acte : ${acte?.libelle}</title>
</head>
<body>
<etude:linkDossier dossier="${acte.dossier}"/> (cr&eacute;e <i><etude:relativeDate sentence="true" date="${acte.dateCreation}"/></i>)
<g:if test="${listEcritures && ! listEcritures.empty}">
Ecritures :
<ul>
<g:each var="ecr" in="${listEcritures}">
<li><span class="${etude.mpIcon(mp:ecr.moyenPaiement)}"></span><g:link controller="ecritureDossier" action="show" id="${ecr.id}" title="${ecr.commentaire}">${ecr.typeEcriture?.libelle} : <g:formatNumber number="${ecr.montant}" format="###,##0.00 DH" /></g:link></li>
</g:each>
</ul>
</g:if>
</body>
</html>
