  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Uniformiser les libell&eacute;s</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
        </div>
		</g:if>
        <div class="body">
            <h1>Uniformiser les libell&eacute;s</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
			<div class="dialog">
			<g:form accept-charset="UTF-8" controller="typeEcriture" action="uniformiser" method="post" >
				<div style="width:100%;text-align:right">
				<div  style="right:20px">
					<input type="submit" class="validate danger" value="Uniformiser les libell&eacute;s" />
				</div>
				</div>
				<div>
					<ul>
         <li><g:radio id="cap" name="methode" value="capitalize" checked="true"/><label for="cap">Commencer par une majuscule</label></li>
         <li><g:radio id="upp" name="methode" value="upper"/><label for="upp">Tout en majuscule</label></li>
         <li><g:radio id="low" name="methode" value="lower"/><label for="low">Tout en minuscule</label></li>
                    </ul>
				</div>
			</g:form>
			</div>
        </div>
    </body>
</html>
