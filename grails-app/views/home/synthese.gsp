<html>
    <head>
		<title>Rapport de synth&egrave;se</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
    </head>
    <body>
	<style type="text/css">h1{position:relative;color:#333;top:auto;margin-top:0;width:100%;min-height:1.8em;z-index:0;}</style>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link controller="ecritureDossier" action="detailFraisPrix"><span class="chart_bar ico"></span>D&eacute;tail Frais - Prix</g:link></span>
            <span class="menuButton"><g:link controller="ecritureDossier" action="summary"><span class="application_view_list ico"></span>Synth&egrave;se des Ecritures</g:link></span>
            <span class="menuButton"><mymodal:createLink sclass="database_table" controller="ecriture" action="export" title="Relev&eacute; de compte bancaire" linkname="Relev&eacute; de Compte" width="600"/></span>
            <span class="menuButton"><mymodal:createLink sclass="chart_pie" controller="ecritureDossier" action="critereGroupement" title="Requ&ecirc;te sur les Groupements d&apos;Ecritures" linkname="Groupements d&apos;Ecritures" width="600"/></span>
        </div>
		</g:if>
        <div class="body">
				<jsec:hasPermission type="EtudePerm" target="EcritureDossier" actions="RapportSynthese">
					<etude:remoteInclude id="tdbDisplayDiv"  controller="ecritureDossier" action="tdbDisplay" params="${groupementParams+['debut':params.debut,'fin':params.fin,periode:params.periode]}" pendingMsg="Synth&egrave;se Globale..."/>
				</jsec:hasPermission>
		</div>
	 </body>
</html>
