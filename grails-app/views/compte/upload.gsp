  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Import de plan comptable</title> 
		<style type="text/css">
		div.tabbertab div.errors{margin:0px;}
		div.tabbertab .tight td{padding:0px;font-size:10px;width:5em;vertical-align:middle;}
		</style>
<g:javascript library="prototype" />
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
        </div>
        </g:if>
        <div class="body">
            <h1>Import de plan comptable</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <g:if test="${flash.messageError}">
            <div class='error'>${flash.messageError}</div>
            </g:if>
            <div id="progress" class="dialog hidden" style="padding:2em;"></div>
			<div class="dialog">
	<g:form action="doUpload" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
				<table>
					<tbody>
						<tr class="prop">
							<td valign="top" class="name">
								<span class="num">1</span><label for="modele"><etude:traduction name="modele" default="T&eacute;l&eacute;charger ce Mod&egrave;le" />:</label>
							</td>
							<td valign="top" class="value">
							
										<g:link class="xls" controller="compte" action="xlsTemplate">Mod&egrave;le</g:link>
							
							</td>
						</tr> 					
						<tr class="prop">
							<td valign="top" class="name">
								<span class="num">2</span><label for="operation"><etude:traduction name="operation" default="Saisir les libell&eacute;s dans ce mod&egrave;le" /></label>
							</td>
							<td valign="top" class="value ${hasErrors(bean:dossier,field:'operation','errors')}">
							
							</td>
						</tr> 					
						<tr class='prop'><td valign='top' class='name'><span class="num">3</span><label for='contenu'>Charger le fichier :</label></td>
							<td>
									<input type="file" name="myFile" class="button"/>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="buttons">
                    <input type="submit" value="Lancer l&apos;import"  class="button danger clientmsg" showin="progress" msg="Envoi du fichier en cours...Veuillez laisser cette fen&ecirc;tre ouverte jusqu'&agrave; la fin de l'envoi."/>
                </div>
				</g:form>
			</div>
			<g:if test="${rejects}">
			<br/>
			<div class="dialog">
					<h2>Il y a des rejets</h2>
					<br/><i>Le fichier n'a pas &eacute;t&eacute; import&eacute;.</i> Les erreurs suivantes doivent &ecirc;tre corrig&eacute;es pour que le fichier soit import&eacute; :<p>
					<etude:tabPane id="dossier_upload_rejects">
						<g:each in="${rejects}" status="i" var="entry">
							<etude:tab code="${entry.key}"/>
						</g:each>
					</etude:tabPane>
						<g:each in="${rejects}" status="i" var="entry">
							<etude:tabContent code="${entry.key}">
							<table class="tight">
								<tbody>
									<g:each in="${entry.value}" status="j" var="object">
									<tr><td><b>Ligne ${lineNumbers.get(object)}</b></td><td><g:hasErrors bean="${object}"><div class="errors"><g:renderErrors bean="${object}" as="list" /></div></g:hasErrors></td></tr>
									</g:each>
								</tbody>
							</table>
							</etude:tabContent>
						</g:each>
			</div>
			</g:if>
        </div>
    </body>
</html>
