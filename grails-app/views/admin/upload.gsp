  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Import d'une sauvegarde</title>         
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
        </div>
        </g:if>
        <div class="body">
            <h1>Import d'une sauvegarde</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <div id="progress" class="dialog hidden" style="padding:2em;"></div>
			<div class="dialog">
				<table>
					<tbody>
					
						<tr class='prop'><td valign='top' class='name'><label for='contenu'>Envoi du fichier:</label></td>
							<td>
								<g:form action="doUpload" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
									<input type="file" name="backup" class="button"/>
									<input type="submit" class="button danger clientmsg" showin="progress" msg="Envoi du fichier en cours...Veuillez laisser cette fen&ecirc;tre ouverte jusqu'&agrave; la fin de l'envoi."/>
								</g:form>
							</td>
						</tr>
					
					</tbody>
				</table>
			</div>
        </div>
    </body>
</html>
