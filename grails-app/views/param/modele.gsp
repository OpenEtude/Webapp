<html>
    <head>
		<title>Mod&egrave;les</title>
		<meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
    </head>
    <body>
        <div class="nav"></div>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}" style="position:absolute;width:500px;">${flash.message}</div>
            </g:if>
			<h1>Mod&egrave;les</h1>
    </body>
</html>
