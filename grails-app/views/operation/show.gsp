<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}"/>
    <title><etude:traduction name="Operation"/> ${operation}</title>
</head>

<body>
<g:if test="${params.nostyle != 'true'}">
    <div class="nav">
        <span class="menuButton"><a href="${createLinkTo(dir: '')}"><span class="house ico"></span><g:message code="home" default="Acceuil"/></a></span>

        <span class="menuButton"><g:link action="list"><span
            class="database_table ico"></span>Op&eacute;rations</g:link></span>

        <span class="menuButton"><g:link class="modal" action="create"><span
                class="database_add ico"></span><g:message code="domain.Operation.new" default="Nouvelle Op&eacute;ration"/></g:link></span>
        <span class="menuButton"><g:link class="modal" controller='bien'
                                         params='["operation.id": operation?.id, "typeDeBien.id": 1]'
                                         action='create'><span class="database_add ico"></span>Ajout Bien</g:link>
        </span>
        <span class="menuButton"><g:link class="modal" controller='dossier' params='["operation.id": operation?.id]'
                                         action='create'><span class="database_add ico"></span>Ajout Dossier</g:link>
        </span>
        <jsec:hasPermission type="EtudePerm" target="Dossier" actions="RapportDetail">
            <span class="menuButton"><g:link controller='dossier'
                                             title="Exporter La liste des Dossiers sous le format excel"
                                             action='advSearch' params="['operation.id': operation.id]"><span
                        class="xls ico"></span>Export</g:link></span>
        </jsec:hasPermission>
    </div>
    <div class="searchbox">
        <g:form border="0" url='[controller: "dossier", action: "search"]' id="dossierSearch" name="dossierSearch"
                accept-charset="UTF-8" method="get" >
            <etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Nom dossier"
                           lookup="true" controller="dossier" white;" params="${['onlyOperation': operation.id]}"/>
        </g:form>
    </div>

</g:if>
<div class="body">
    <h1><etude:traduction name="Operation"/> ${operation}</h1>
    <g:if test="${flash.message}">
        <div class="${flash.messageType ? flash.messageType : 'message'}"><g:message code="${flash.message}"
                                                                                     args="${flash.args}"
                                                                                     default="${flash.message}"/></div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <tr class="prop">
                <td><etude:traduction name="client" default="Client"/>:<g:link controller="client" action="show"
                                                                               id="${operation?.client?.id}"
                                                                               class="show">${operation?.client}</g:link> ${operation.description} cr&eacute;&eacute;e <etude:relativeDate
                        date="${operation.dateCreation}" sentence="true"/></td>
            </tr>


            <tr class="prop">
                <td>
                    <div class="noprint" >
                        <g:form name="addDossier" action="addDossier" method="post">
                            <g:link class="tip" controller="dossier" action="list"
                                    params="['mode': 'select', 'addTo': 'Operation', 'id': operation.id]">Ajouter des dossiers existants</g:link><br/>
                            <g:hiddenField name="operation.id" value="${operation.id}"/><g:hiddenField name="dossierId"
                                                                                                       id="dossierToAdd"/><etude:keyword name="dossier" title="Saisir le dossier pour ajout"

                                params="['addTo': 'Operation']" lookup="true" controller="dossier"/>
                        </g:form>
                    </div>
                    <etude:tabPane id="${ParamUtils.root()}opshow1_${operation.id}">
                        <etude:tab code="biens.associes.a.operation"/>
                        <etude:tab code="dossiers.non.affectes"/>
                    </etude:tabPane>
                    <etude:tabContent code="biens.associes.a.operation">
                        <g:if test="${!listeBiens.empty}">
                            <table class="list"><thead><th><etude:traduction name="bien"
                                                                                   default="Bien"/></th><th><etude:traduction
                                    name="dossiers" default="Dossier affect&eacute;"/></th></thead>
                                <g:each var="bien" in="${listeBiens}" status="j">
                                    <% ecritures = bien.dossier ? ecrituresOperation.get(bien.dossier) : [] %>
                                    <tr class="${(j % 2) == 0 ? 'odd' : 'even'}"><td

                                                                                       title="${bien}" modalwidth="800"
                                                                                       action="edit"
                                                                                       databarDisabled="true"/></td><td class="linktip">
                                <div class="prey"><g:if
                                            test="${bien.dossier}"><etude:linkDossier
                                                dossier="${bien.dossier}"/>&nbsp;<span
                                                class="tip">${bien.dossier.description}</span>
                                    </g:if><ul><g:if test="${!ecritures?.empty}"><br/></g:if><g:each
                                            var="ecritureDossier" in="${ecritures}" status="i">
                                        <li class="${ecritureDossier.typeEcriture.categorieEcriture.id == 1 ? 'frais' : 'prix'}${(i % 2) == 0 ? 'odd' : 'even'}"><span
                                                class="${etude.mpIcon(mp: ecritureDossier.moyenPaiement)}"></span><span
                                                class="${etude.etatIcon(etat: ecritureDossier.etat)}"></span><g:link
                                                controller="ecritureDossier" action="show" id="${ecritureDossier?.id}"
                                                title="Dossier :&nbsp;${ecritureDossier?.dossier?.encodeAsHTML()}">${ecritureDossier?.encodeAsHTML()}</g:link><br/><span
                                                class="tip">${ecritureDossier?.commentaire?.encodeAsHTML()}</span></li>
                                    </g:each></ul><g:if test="${bien.dossier}"><div ><b
                                            >Solde Prix: <span
                                                ><g:formatNumber
                                                    number="${dossierSoldesPrix.get(bien.dossier)}"
                                                    format="###,##0.00 DH"/></span></b></div></g:if></div></td></tr>
                                </g:each>
                            </table>
                        </g:if>
                        <g:else>
                            <div class="comment">Aucun bien n'a &eacute;t&eacute; associ&eacute; &agrave; l'op&eacute;ration.</div>
                        </g:else>
                    </etude:tabContent>
                    <etude:tabContent code="dossiers.non.affectes">
                        <g:if test="${!listeDossiers.empty}">
                            <table class="list">
                                <g:each var="dossier" in="${listeDossiers}" status="i">
                                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" ${etude.addHover(ctrlName: 'operation', id: dossier.id)}><td class="linktip">
                                        <div class="prey">
                                            <etude:linkDossier
                                                    dossier="${dossier}">${dossier}
                                            </etude:linkDossier>
                                            <span class="tip">${dossier.description}</span>
                                            <etude:databar
                                                    controller="operation" fields="${[id: dossier.id]}"
                                                    class="oplink">
                                                <g:actionSubmit class="link danger"
                                                                warn="\312tes-vous sur de vouloir dissocier?"
                                                                title="Dissocier le dossier de l'operation"
                                                                value="Dissocier" action="removeDossier"/>
                                                <g:link controller="bien" action="list" class="validate modal"
                                                        title="Affecter un bien au dossier"
                                                        params="['mode': 'select', 'addTo': 'Dossier', 'id': dossier.id, 'from': 'operation', 'fromId': operation.id]">Affecter</g:link>
                                            </etude:databar>
                                        </div>
                                    </td></tr>
                                </g:each>
                            </table>

                        </g:if>
                        <g:else>
                            <div class="comment">Aucun dossier non affect&eacute;.</div>
                        </g:else>
                    </etude:tabContent>
                    <div class="buttons">
                        <g:form>
                            <input type="hidden" name="id" value="${operation?.id}"/>
                            <g:actionSubmit class="default modal" value="Modifier" action="Edit" modalwidth="700"/>
                            <g:actionSubmit class="danger" value="Supprimer" action="delete"/>
                        </g:form>
                    </div>
    </div>
</body>
</html>
