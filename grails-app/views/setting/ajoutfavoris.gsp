  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Ajouter aux favoris</title>
    </head>
    <body>
		<g:if test="${!params.nostyle}">
        <div class="nav">
            
        </div>
		</g:if>
        <div class="body">
            <h1>Ajouter aux favoris</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
			<div class="dialog">
			<g:form accept-charset="UTF-8" controller="setting" action="doAjoutFavoris" method="post" >
				<div>
					<label for="label" class="property">Libell&eacute; du favoris:</label>
					<input id="label" name="label" type="text" style="width:200px;" value="${params.label?.replace("<span class=\"noprint\">",'').replace("</span>",'').replace("</b>",'').encodeAsHTML()}" />
					<g:hiddenField name="url" value="${params.url}" />
				</div>
				<div>
					<br/>
					<label class="property">Emplacement du favoris:</label>
					<ul>
					<g:each in="${favList}" var="i">
         <li class="clickable"><g:radio id="favoris.${i}.check" name="favoris" value="favoris.${i}" checked="${i==1}"/><label for="favoris.${i}.check"><etude:link key="favoris.${i}" class="database_table" show="true"></etude:link></label></li>
					</g:each>
                    </ul>
				</div>
				<div class="buttons">
					<input type="submit" class="validate" value="Ajouter" />
				</div>
			</g:form>
			</div>
        </div>
    </body>
</html>
