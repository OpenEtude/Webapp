<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
<title>Etat du serveur</title>
</head>
<body>
<div id="userAction" class="noshow"><div class="nav"></div></div>
<div class="body">
<h1>Etat du serveur</h1>
<g:if test="${flash.message}">
<div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
</g:if>
<div class="dialog" style="padding:100px;">
<span class="serverstatus" monitorurl="${createLinkTo(dir:'admin/monitor')}" homeurl="${createLinkTo(dir:'/')}"/>
</div>
</div>
</body>
</html>
