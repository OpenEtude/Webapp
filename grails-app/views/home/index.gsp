<html>
    <head>
		<title>Accueil</title>
		<meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
    </head>
    <body>
        <div class="nav"></div>
        <div class="body">
			<h1>Accueil</h1>
            <div id="content" style="align:center;position;relative;margin-top:6px;">
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}
                <g:if test="${flash.messageLink}"><a class="highlightedFeature" href="${flash.messageLink.href}" target="_blank" style="padding:0.3em;">${flash.messageLink.a}</a></g:if>
            </div>
            </g:if>
<table class="homegrid">
<tr>
<td class="mywidget">
<h2>Dossiers</h2>
<div class="mywidgetcontent">
<jsec:hasPermission type="EtudePerm" target="Dossier" actions="Creation">
    <p><g:link class="modal highlightedFeature" controller="dossier" action="create" title="Cr&eacute;er un Nouveau Dossier" modalwidth="600"><span class="database_add ico"></span>Nouveau Dossier</g:link></p>
<etude:remoteInclude id="lastDossiersDiv" controller="home" action="lastDossiers" busyClass="smallfont somespace"/>
</jsec:hasPermission>
    <jsec:hasPermission type="EtudePerm" target="Dossier" actions="Liste">
        <p id="listeDossiers"><g:link class="highlightedFeature" controller='dossier' action='list' title="Liste des dossiers">tous les dossiers <span class="database_save ico"></span></g:link></p>
    </jsec:hasPermission>
</div>
</td>
<td class="mywidget">
<h2>&Eacute;critures de dossiers</h2>
<div class="mywidgetcontent">
<jsec:hasPermission type="EtudePerm" target="EcritureDossier" actions="ModificationMasse">
<p><g:link class="highlightedFeature" controller='ecritureDossier' action='validate' title="Valider les &eacute;critures de dossier dont l&apos;&eacute;tat est en cours"><span class="accept ico"></span>A valider <etude:remoteInclude id="pendingSpan" controller="home" action="pending" container="span" pendingMsg="..." busyClass="smallfont"/></g:link></p>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="EcritureDossier" actions="Liste">
<etude:remoteInclude id="lastEcrituresDossierDiv" controller="home" action="lastEcrituresDossier" busyClass="smallfont somespace"/>
<p><g:link class="highlightedFeature" controller='ecritureDossier' action='list' title="Liste des &eacute;critures relatives aux dossiers">&eacute;critures de dossier<span class="database_save ico"></span></g:link></p>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="Ecriture" actions="Creation">
</div>
</td>
</tr>
<tr>
<td class="mywidget">
<h2>Actes</h2>
<div class="mywidgetcontent">
<jsec:hasPermission type="EtudePerm" target="Acte" actions="Liste">
<p><etude:remoteInclude id="lastActesDiv" controller="home" action="lastActes" busyClass="smallfont somespace"/>
<g:link class="highlightedFeature" controller='acte' action='list' title="Liste des actes">tous les actes<span class="database_save ico"></span></g:link>
</jsec:hasPermission>
</div>
</td>
<td class="mywidget">
<h2>Autres &eacute;critures</h2>
<div class="mywidgetcontent">
<p><g:link class="modal highlightedFeature" controller="ecriture" action="create" title="Cr&eacute;er une Nouvelle Ecriture non li&eacute;e &agrave; un dossier" modalwidth="600"><span class="database_add ico"></span>Nouvelle Ecriture</g:link></p>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="Ecriture" actions="Liste">
<etude:remoteInclude id="lastEcrituresDiv" controller="home" action="lastEcritures" busyClass="smallfont somespace"/>
<p><g:link class="highlightedFeature" controller='ecriture' action='list' title="Liste des &eacute;critures non li&eacute;es aux dossiers">autres &eacute;critures<span class="database_save ico"></span></g:link></p>
</jsec:hasPermission>
</div>
</td>
</tr>
</table>
			</div>
        </div>
		</div>
    </body>
</html>
