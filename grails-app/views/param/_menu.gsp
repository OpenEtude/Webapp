<div style="height:40em;">
<div id="leftContent">
	<jsec:hasPermission type="EtudePerm" target="Dossier" actions="Creation">
		<p><mymodal:createLink sclass="myButton" controller="dossier" action="create" title="Cr&eacute;er un Nouveau Dossier" linkname="Nouveau Dossier" width="600"><span class="database_add"/></mymodal:createLink></p>
	</jsec:hasPermission>
	<jsec:hasPermission type="EtudePerm" target="Acte" actions="Creation">
		<p><mymodal:createLink sclass="myButton"  controller="acte" action="create" title="Cr&eacute;er un Nouvel Acte" linkname="Nouvel Acte" width="600"><span class="database_add"/></mymodal:createLink></p>
	</jsec:hasPermission>
	<jsec:hasPermission type="EtudePerm" target="Ecriture" actions="Creation">
		<p><mymodal:createLink sclass="myButton"  controller="ecriture" action="create" title="Cr&eacute;er une Nouvelle Ecriture non li&eacute;e &agrave; un dossier" width="600"><span class="database_add"/>Nouvelle Ecriture</mymodal:createLink></p>
	</jsec:hasPermission>
	<jsec:hasPermission type="EtudePerm" target="EcritureDossier" actions="ModificationMasse">
		<p><g:link class="myButton" controller='ecritureDossier' action='validate' title="Valider les &eacute;critures de dossier dont l&apos;&eacute;tat est en cours"><span class="accept"/>Validation d'Ecritures de Dossier</g:link></p>
	</jsec:hasPermission>
	<jsec:hasPermission type="EtudePerm" target="Ecriture" actions="RapportDetail">
		<p><g:link class="myButton" controller='ecriture' action='search'><span class="search"/>Recherche Ecritures</g:link></p>
	</jsec:hasPermission>
</div>
<div id="centerleftcontent">
	<jsec:hasPermission type="EtudePerm" target="EcritureDossier" actions="Liste">
		<p><g:link class="myButton" controller='ecritureDossier' action='list' title="Liste des &eacute;critures relatives aux dossiers"><span class="database_table"/>Ecritures de Dossier</g:link></p>
	</jsec:hasPermission>
	<jsec:hasPermission type="EtudePerm" target="Ecriture" actions="Liste">
		<p><g:link class="myButton" controller='ecriture' action='list' title="Liste des &eacute;critures non li&eacute;es aux dossiers"><span class="database_table"/>Autres Ecritures</g:link></p>
	</jsec:hasPermission>
	<jsec:hasPermission type="EtudePerm" target="Dossier" actions="Liste">
		<p><g:link class="myButton" controller='dossier' action='list' title="Liste des dossiers"><span class="database_table"/>Dossiers</g:link></p>
	</jsec:hasPermission>
	<jsec:hasPermission type="EtudePerm" target="Acte" actions="Liste">
		<p><g:link class="myButton" controller='acte' action='list' title="Liste des actes"><span class="database_table"/>Actes</g:link></p>
	</jsec:hasPermission>
</div>
<div id="centerrightcontent">
	<jsec:hasRole name="Maitre">
		<p><g:link class="myButton" controller='compteBancaire' action='synthese' title="Situation des comptes bancaires"><span class="money"/>Comptes Bancaires</g:link></p>
		<p><mymodal:createLink sclass="myButton" controller="ecritureDossier" action="critereGroupement" title="Requ&ecirc;te sur les Groupements d&apos;Ecritures" linkname="Groupements d&apos;Ecritures" width="600"><span class="chart_pie"/></mymodal:createLink></p>
		<p><g:link class="myButton" controller='ecritureDossier' action='summaryFraisPrix' title="Synth&egrave;se des &eacute;critures frais prix"><span class="chart_bar"/>Synth&egrave;se Frais - Prix</g:link></p>
		<p><g:link class="myButton" controller='ecritureDossier' action='summary' title="Synth&egrave;se des &eacute;critures regroup&eacute;es par libell&eacute;s"><span class="application_view_list"/>Synth&egrave;se des Ecritures</g:link></p>
		<p><g:link class="myButton" controller='activity' action='list' title="Journal des &eacute;v&eacute;nements relatifs aux donn&eacute;es de l&apos;application"><span class="shield"/>Journal d'Activit&eacute;</g:link></p>
	</jsec:hasRole>
	<jsec:hasRole name="Comptable">
		<p><g:link class="myButton" controller='compteBancaire' action='synthese'><span class="money"/>Comptes Bancaires</g:link></p>
		<p><g:link class="myButton" controller='ecritureDossier' action='summaryFraisPrix'><span class="chart_bar"/>Synth&egrave;se Frais - Prix</g:link></p>
		<p><g:link class="myButton" controller='ecritureDossier' action='summary'><span class="application_view_list"/>Synth&egrave;se des Ecritures</g:link></p>
	</jsec:hasRole>
</div>
</div>
