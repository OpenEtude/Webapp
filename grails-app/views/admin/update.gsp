  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Mise &agrave; jour du logiciel</title>         
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
        </div>
        </g:if>
        <div class="body">
            <h1>Mise &agrave; jour du logiciel</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <div id="progress" class="dialog hidden" style="padding:2em;"></div>
			<div class="dialog">
				<table>
					<tbody>
					
						<tr class='prop'><td valign='top' class='name'><label for='contenu'>Envoi du fichier:</label></td>
							<td>
								<g:form action="doUpdate" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
									<input type="file" name="software" class="button"/>
									<input type="submit" warn="Etes-vous sur de vouloir mettre a jour le logiciel?" value="Envoyer" class="button danger clientmsg lockui" showin="progress" msg="Envoi du fichier en cours...Veuillez laisser cette fen&ecirc;tre ouverte jusqu'&agrave; la fin de l'installation."/>
								</g:form>
							</td>
						</tr>
					
					</tbody>
				</table>
			</div>
        </div>
    </body>
</html>
