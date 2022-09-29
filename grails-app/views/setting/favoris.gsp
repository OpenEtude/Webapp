  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Mes favoris</title>
    </head>
    <body>
		<g:if test="${!params.nostyle}">
        <div class="nav">
            
        </div>
		</g:if>
        <div class="body">
            <h1>Mes favoris</h1>
		<g:each in="${favList}" var="i">
		<p><etude:link key="favoris.${i}" class="myButton" icon="favoris"></etude:link></p>
		</g:each>
        </div>
    </body>
</html>
