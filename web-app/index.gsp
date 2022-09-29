<html>
    <head>
		<title>Accueil</title>
		<meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
		<style type="text/css">
			h3 {
				font-size:13px;
				font-weight: bold;
			}
		</style>
    </head>
    <body>
            <jsec:hasPermission type="EtudePerm" target="EcritureDossier" actions="Liste">
		<div class="searchbox">
			<g:form border="0" url='[controller: "dossier", action: "search"]'   id="dossierSearch" name="dossierSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
						<g:textField name="q" size="20" id="keybox" accesskey="s"
                               value="${params.q?params.q:'Num ou Nom Dossier'}" onfocus="this.value='';" />
						<button type="submit" class="searchbutton" title="Recherche">Recherche</button>
			</g:form>
		</div>
			</jsec:hasPermission>
        <div class="nav">
            <span class="menuButton">&nbsp;</span>
        </div>
		<g:render template="/param/menu"></g:render>
    </body>
</html>
