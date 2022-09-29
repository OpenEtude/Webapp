<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title><etude:traduction name="Bien"/></title>
</head>
<body>
<div><g:link controller="typeDeBien" action="show" id="${bien?.typeDeBien?.id}" class="show">${bien?.typeDeBien}</g:link></div>
<div><etude:traduction name="operation" default="Operation" /> <etude:linkOperation operation="${bien.operation}"/></div>
<div><etude:traduction name="dossier" default="Dossier" /> <etude:linkDossier dossier="${bien.dossier}"/></div>
<g:each var="v" in="${bien?.valeurs}">
<div>
<b>${v.champ.libelle} : </b>
${v.contenu?.encodeAsHTML()}
</div>
</g:each>
</div>
</body>
</html>
