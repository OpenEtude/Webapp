 <html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>${title ?: (params.title ?: "Calendrier")}</title>
    </head>
    <body>
        <div class="nav">
            
        </div>

        <div class="body">
            <h1>${title ?: (params.title ?: "Calendrier")}</h1>
			<g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
