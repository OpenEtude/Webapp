<li id="home"><a href="${createLinkTo(dir: '')}/"><span class="house"/>Accueil</a></li>
<li><g:link controller="param" modalwidth="250" class="modal" action="search" title="Recherche"><span
        class="search ico"/>Recherche</g:link></li>
<li style="padding: 0.5em;"><b class="tip tiny">DOSSIERS</b></li>
<g:each in="${(1..11)}" var="i">
    <li><etude:link key="favoris.${i}" icon="favoris" txtclass="ellipsis30"></etude:link></li>
</g:each>
<jsec:hasPermission type="EtudePerm" target="Operation" actions="Liste">
    <li><g:link controller='operation' class="operationlink" action='list' title="Opérations"><span
            class="database_table ico"/>Opérations</g:link></li>
</jsec:hasPermission>
<jsec:hasRole name="Maitre">
    <li style="padding: 0.5em;"><b class="tip tiny">RAPPORTS</b></li>
    <li><g:link controller="ecritureDossier" class="rapportgroupement" action="critereGroupement"
               title="Rapport de Groupements"><span
                class="money ico"/>&Eacute;critures</g:link></li>
</jsec:hasRole>
<jsec:hasPermission type="EtudePerm" target="Dossier" actions="RapportDetail">
    <li><g:link class="exportdossierlink" controller='dossier'
               title="Exporter La liste des Dossiers sous le format excel" action='advSearch'><span class="xls ico"/>Dossiers</g:link></li>
</jsec:hasPermission>
<jsec:hasAnyRole in="['Maitre', 'Comptable']">
    <li id="compteBancaires"><g:link controller='compteBancaire' action='synthese'
                                    title="Situation des comptes bancaires"><span
                class="money ico"/>Comptes</g:link></li>
    <li><g:link class="fraisPrix" controller='ecritureDossier' action='summaryFraisPrix'
               title="Synthese des Ecritures frais prix"><span
                class="chart_bar ico"/>Frais / Prix</g:link></li>
</jsec:hasAnyRole>
<jsec:hasPermission type="EtudePerm" target="Activity" actions="Liste">
    <li><g:link class="activitylink" controller='activity' action='list'
               title="Journal des événements relatifs aux données de l'application"><span
                class="shield ico"/>Activité</g:link></li>
</jsec:hasPermission>
<li style="padding: 0.5em;"><b class="tip tiny">PARAM&Egrave;TRES</b></li>
<li><g:link class="myprofilelink" controller='setting' action='list'><span class="group ico"/>Mon profil</g:link></li>
<jsec:hasPermission type="EtudePerm" target="JsecUser" actions="Liste">
    <li><g:link class="userslink" controller='jsecUser' action='list'><span class="group ico"/>Utilisateurs</g:link></li>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="TypeEcriture" actions="Modification">
    <li><g:link class="setupecritureslink" controller='typeEcriture' action='list'><span class="book ico"/>Ecritures</g:link></li>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="Groupement" actions="Modification">
    <li><g:link class="setupgroupementslink" controller="groupement" action="list"><span class="database_edit ico"/>Groupements</g:link></li>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="TypeDeBien" actions="Modification">
    <li><g:link class="setupbienslink" controller="typeDeBien" action="list"><span class="database_edit ico"/>Biens</g:link></li>
</jsec:hasPermission>
<jsec:hasPermission type="EtudePerm" target="JsecRole" actions="Modification">
    <li><g:link class="setupermisionslink" controller='jsecRole' action='list'><span class="roles ico"/>Sécurité</g:link></li>
</jsec:hasPermission>
<jsec:hasRole name="Maitre">
    <li><g:link class="backuplink" controller='admin' action='maintenance'><span class="database_save ico"/>Sauvegardes</g:link></li>
</jsec:hasRole>
<jsec:hasPermission type="EtudePerm" target="Setting" actions="Modification">
    <li><g:link class="setupadvancedlink" controller='setting' action='syslist'><span class="basket_edit ico"/>Avancé</g:link></li>
</jsec:hasPermission>
<li><a onclick=" hopscotch.startTour(hopscotchTourOnboarding);" href="#" class="helplink" title="Aide"><span
        class="information ico"/>Aide</a></li>
<li><g:link controller="auth" action="signOut" title="Quitter l'application"><span
        class="rejected ico"/>Déconnexion</g:link></li>
