<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Administration</title>
    </head>
    <body>
        <div class="nav">
            
        </div>
        <div class="body">
<etude:tabPane>
	<etude:tab code="Param&egrave;tres de l'application"/>
	<etude:tab code="S&eacute;curit&eacute;"/>
	<etude:tab code="Avanc&eacute;"/>
</etude:tabPane>
<etude:tabContent code="Param&egrave;tres de l'application">
<jsec:hasPermission type="EtudePerm" target="TypeEcriture" actions="Liste">
	<p><g:link class="myButton" controller='typeEcriture' action='list'><span class="book"/>Libell&eacute;s des Ecritures</g:link></p>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="Compte" actions="Liste">
	<p><g:link class="myButton" controller='compte' action='list'><span class="book"/>Plan Comptable</g:link></p>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="Groupement" actions="Liste">
	<p><g:link class="myButton" controller="groupement" action="list"><span class="database_edit"/> Param&egrave;trage des Groupements</g:link></p>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="TypeDeBien" actions="Liste">
	<p><g:link class="myButton" controller="typeDeBien" action="list"><span class="database_edit"/> Param&egrave;trage des Biens</g:link></p>
</jsec:hasPermission>
</etude:tabContent>
<etude:tabContent code="S&eacute;curit&eacute;">
<jsec:hasPermission type="EtudePerm" target="JsecRole" actions="Liste">
	<p><g:link class="myButton" controller='jsecRole' action='list'><span class="roles"/>R&ocirc;les et permissions</g:link></p>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="JsecUser" actions="Liste">
	<p><g:link class="myButton" controller='jsecUser' action='list'><span class="group"/>Gestion des Utilisateurs</g:link></p>
</jsec:hasPermission>
</etude:tabContent>
<etude:tabContent code="Avanc&eacute;">
<jsec:hasPermission type="EtudePerm" target="Administration" actions="Modification">
	<p><g:link class="myButton" controller='admin' action='maintenance' ><span class="database_save"/>Maintenance</g:link></p>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="Setting" actions="Modification">
	<p><g:link class="myButton" controller='setting' action='syslist'><span class="basket_edit"/>Configuration avanc&eacute;e</g:link></p>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="Traduction" actions="Liste">
	<p><g:link class="myButton" controller='traduction' action='list'><span class="basket_edit"/>Affichage</g:link></p>
</jsec:hasPermission>
</etude:tabContent>
</div>
</body>
</html>