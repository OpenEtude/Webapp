  
<html>
    <head>
		<jawr:style src="/style/${etude.theme()}.css" media=""/>
		<jawr:script src="/script/all.js"  />
		<link rel="shortcut icon" href="${createLinkTo(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
		<title>Installation de cl&eacute; de produit</title>         
<style type="text/css">h1{position:relative;}
	</style>    </head>
    <body style="background-image:none;">
		<center>
		<div style="margin-top:60px;width:600px;">
			<div class="body">
            <h1 style="margin-right:auto;color:555;">Installation de cl&eacute; de produit</h1>
            <g:if test="${flash.message}">
            <div class='message'>${flash.message}</div>
            </g:if>
            <g:if test="${flash.messageError}">
            <div class='error'>${flash.messageError}</div>
            </g:if>
			<div class="dialog">
			<br/>
            Bienvenue &agrave; &ldquo;<etude:syssetting key='etude'/>&rdquo;. Une cl&eacute; du produit doit &eacute;t&eacute; install&eacute;e pour activer l'application.<br/><br/><span class="tip" style="font-size:12px;">Veuillez effectuer une des op&eacute;rations suivantes :</span>
			<br/>
			<br/>
                <etude:tabPane>
                <etude:tab label="Demande de cl&eacute; de produit" code="demande"/>
                <etude:tab label="Installation de cl&eacute; de produit" code="installation"/>
                </etude:tabPane>
                <etude:tabContent code="demande">
					<fieldset>
						<legend class="tip" style="font-size:15px;"><b>Demande en ligne</b></legend>
					<label for="email">Je souhaite demander en ligne la cl&eacute; de produit et la recevoir sur cette addresse email (<i>n&eacute;cessite une connexion Internet</i>)</label><br/><br/>
					<form name="myForm" update="['success':'msg','failure':'toobad']" action="http://arkilog.appspot.com/rfl" method="POST">
						<g:hiddenField name="lrequest" value="${lrequest.encodeAsHTML()}" />
						<g:hiddenField name="who" value="AKLNBHBVTVTVD789" />
						<g:hiddenField name="comebackTo" value="" />
						<label for="email">Email de r&eacute;ception de la cl&eacute;:</label>
						<input id="email" type="text" name="email" value=""/>
						 <input type="submit" value="Demander en ligne">
					</form>
					</fieldset>
<script language="JavaScript">
$('comebackTo').value = location.href
</script>
					<fieldset style="margin-top:3em;">
						<legend class="tip" style="font-size:15px;"><b>Demande par email</b></legend>
				<g:form controller="lic" action="rfl" method="post" accept-charset="UTF-8">
					<label for="email2">Je ne suis pas connect&eacute; &agrave; Internet, je souhaite envoyer la demande de cl&eacute; de produit ult&eacute;rieurment par email et la recevoir sur cette addresse</label><br/><br/>
					<label for="email2">Email de r&eacute;ception de la cl&eacute;:</label>
					<input id="email2" type="text" name="email" value=""/>
					<input type="submit" value="T&eacute;l&eacute;charger la demande"/>
				</g:form>
					</fieldset>
                </etude:tabContent>
                <etude:tabContent code="installation">
					<fieldset>
						<legend class="tip" style="font-size:15px;"><b>Installation par fichier</b></legend>
								<g:form controller="lic" action="save" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
					<label>Je dispose d&eacute;j&agrave; d'un fichier de cl&eacute; de produit</label><br/><br/>
									<input type="file" name="myFile"/>
									<input type="submit" value="Installer la cl&eacute; de produit"/>
								</g:form>
					</fieldset>
					<fieldset style="margin-top:3em;">
						<legend class="tip" style="font-size:15px;"><b>Saisie directe</b></legend>
				<g:form controller="lic" action="save" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
					<label for="myLic">J'ai d&eacute;j&agrave; re&ccedil;u une cl&eacute; de produit</label><br/><br/>
					<textarea id="myLic" name="myLic"></textarea>
					<input type="submit" value="Enregistrer la cl&eacute; de produit"/>
					</g:form>
					</fieldset>
                </etude:tabContent>
				</div>
			</div>
        </div>
		</center>
    </body>
</html>
