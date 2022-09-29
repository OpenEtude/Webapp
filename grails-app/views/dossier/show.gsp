<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}"/>
    <title>${dossier.libelle}</title>
</head>

<body>
<div class="nav">

    <span class="menuButton"><g:link controller='acte' params='["dossier.id": dossier?.id]' action='create'
                                     title="Nouvel acte : dossier ${dossier.numeroDossier}&nbsp;-&nbsp;${dossier.libelle}"><span class="database_add ico"></span>Ajout Acte</g:link></span>
    <span class="menuButton"><g:link class="modal" controller='ecritureDossier'
                                     params='["type": "prix", "dossier.id": dossier?.id, "from": "dossier"]'
                                     action='create'
                                     title="Nouvelle &eacute;criture prix : dossier ${dossier.numeroDossier}&nbsp;-&nbsp;${dossier.libelle}"
                                     modalwidth="1000"><span class="database_add ico"></span>Ajout Prix</g:link></span>
    <span class="menuButton"><g:link class="modal" controller='ecritureDossier'
                                     params='["type": "frais", "dossier.id": dossier?.id, "from": "dossier"]'
                                     action='create'
                                     title="Nouvelle &eacute;criture frais : dossier ${dossier.numeroDossier}&nbsp;-&nbsp;${dossier.libelle}"
                                     modalwidth="1000"><span class="database_add ico"></span>Ajout Frais</g:link></span>
    <span class="menuButton"><g:link class="modal" controller='ecritureDossier'
                                     params='["dossier.id": dossier?.id, "from": "dossier"]' action='createManyFrais'
                                     title="Nouvelles &eacute;critures frais group&eacute;s : dossier ${dossier.numeroDossier}&nbsp;-&nbsp;${dossier.libelle}"
                                     modalwidth="1000"><span class="database_add ico"></span>Frais Group&eacute;s</g:link>
    </span>
    <g:if test="${listePrix.find { it.typeEcriture == ppe && !it.typeEcriture.credit }}">&nbsp;|&nbsp;<span
        class="menuButton"><g:link controller='dossier' params='["format": "ppe", "id": dossier?.id]' action='show'
                                   title="Pr&eacute;l&eacute;vements Prix au format word"><span class="word ico"></span>Pr&eacute;l&eacute;v. Prix</g:link></span></g:if>
    <g:if test="${listeFrais.find { it.montant && !it.typeEcriture.credit }}"><span class="menuButton"><g:link
            controller='dossier' params='["format": "facture", "id": dossier?.id]' action='show'
            title="Facture au format word"><span class="word ico"></span>Facture</g:link></span></g:if>
    <jsec:hasPermission type="EtudePerm" target="Dossier" actions="RapportDetail"><span class="menuButton"><g:link
            controller='dossier' params='["format": "xls", "id": dossier?.id]' action='show'
            title="Export vers excel"><span class="xls ico"></span>Export</g:link></span></jsec:hasPermission>
    <jsec:hasRole name="Maitre">&nbsp;|&nbsp;<span class="menuButton"><g:if test="${dossier.modele != true}"><span class="menuButton"><g:link
            class="modal" controller='dossier' action="edit" modalwidth="600"
            params='["modele": "true", "id": dossier?.id]'
            title="Cr&eacute;er un nouveau mod&egrave;le de dossiers"><span class="database_edit ico"></span>Cr&eacute;er mod&egrave;le</g:link></span></g:if></span>
        <span class="menuButton"><g:link class="modal" controller="activity" action="history"
                                         params="['controller.id': Activity.DOSSIER, 'entity.id': dossier?.id, 'titre': dossier.toString()]"
                                         modalwidth="750" modalheight="500"
                                         title="Historique de l&apos;activit&eacute; du dossier ${dossier.numeroDossier}&nbsp;-&nbsp;${dossier.libelle}"><span class="database_table ico"></span>Historique</g:link></span></jsec:hasRole>
</div>

<div class="body">
    <h1>${dossier.numeroDossier} : ${dossier.libelle}</h1>
    <jsec:hasPermission type="EtudePerm" target="EcritureDossier" actions="Modification"><g:set var="canModif"
                                                                                                value="${true}"/></jsec:hasPermission>
    <jsec:hasPermission type="EtudePerm" target="EcritureDossier" actions="Suppression"><g:set var="canDelete"
                                                                                               value="${true}"/></jsec:hasPermission><g:if
        test="${flash.message}">
    <div class="${flash.messageType ? flash.messageType : 'message'}">${flash.message}</div>
</g:if>
    <div class="dialog">
        <table>
            <tbody>
            <tr class="prop">
                <td valign="top" class="name">
                    <div style="display:inline">
                        ${dossier?.description} ${dossier?.description ? ', ' : ' '} cr&eacute;e <etude:relativeDate
                            sentence="true" date="${dossier.dateCreation}"/><g:if
                            test="${dossier?.operation}">, op&eacute;ration <etude:linkOperation
                                operation="${dossier.operation}"/></g:if><jsec:hasRole name="Maitre"><g:if
                            test="${dossier.modele == true}">, le mod&egrave;le <i><mymodal:createLink
                                controller='dossier' action="edit" params='["modele": "true", "id": dossier?.id]'
                                linkname="${dossier.nomModele}"/></i> est bas&eacute; sur ce dossier.</g:if></jsec:hasRole>
                        <tags:showTags object="${dossier}" clazz="Dossier"><br/><br/></tags:showTags>
                    </div>
                </td>

            </tr>
            <tr class="prop">
                <td valign="top" class="name"><div><h3>Frais :</h3></div>
                    <g:if test="${!listeFrais?.empty}">
                        <div class="list">
                            <g:set var="debitFrais" value="${0.0f}"/>
                            <g:set var="creditFrais" value="${0.0f}"/>
                            <table>
                                <thead>
                                <tr>
                                    <th>M.P</th>
                                    <th>Libell&eacute;</th>
                                    <th>D&eacute;bit</th>
                                    <th>Cr&eacute;dit</th>
                                    <th class="dateCell">Date D&eacute;p&ocirc;t</th>
                                    <th class="dateCell">Date Encaissement</th>
                                    <th>Etat</th>
                                </tr>
                                </thead>
                                <tbody>
                                <g:each in="${listeFrais}" status="i" var="ecritureDossier">
                                    <etude:tr databar="['post': ['edit', 'delete'], 'get': 'receipt']"
                                              title="${ecritureDossier.compteBancaire ? 'Compte Bancaire : ' + ecritureDossier.compteBancaire.libelle : 'Aucun Compte Bancaire'}"
                                              class="frais${(i % 2) == 0 ? 'odd' : 'even'}" align="middle" valign="top"
                                              ctrl="ecritureDossier" id="${ecritureDossier.id}"
                                              obj="${ecritureDossier}">
                                        <td class="icon"><span
                                                class="${etude.mpIcon(mp: ecritureDossier.moyenPaiement)}">&nbsp;</span><span
                                                class="noshow">${ecritureDossier.moyenPaiement}</span></td>
                                        <td class="linktip"><div class="prey">
                                            <g:link controller="ecritureDossier" action="show"
                                                    id="${ecritureDossier.id}">${(ecritureDossier.marked ? "(*) " : "") + ecritureDossier.typeEcriture?.libelle.encodeAsHTML()}</g:link><g:if
                                                    test="${ecritureDossier.commentaire}"><br/><span
                                                        class="tip">${ecritureDossier.commentaire.encodeAsHTML()}</span></g:if>
                                        </div>
                                        </td>
                                        <td class="moneyCell debit ${ecritureDossier.montant && !ecritureDossier?.typeEcriture?.credit ? '' :'noval'}">
                                            <g:if test="${ecritureDossier.montant && !ecritureDossier?.typeEcriture?.credit}">
                                                <g:formatNumber number="${ecritureDossier.montant}"
                                                                format="###,##0.00 DH"/>
                                                <g:set var="debitFrais"
                                                       value="${debitFrais + ecritureDossier.montant}"/>
                                            </g:if>
                                        </td>
                                        <td class="moneyCell credit ${ecritureDossier.montant && ecritureDossier?.typeEcriture?.credit ? '' : 'noval'}">
                                            <g:if test="${ecritureDossier.montant && ecritureDossier?.typeEcriture?.credit}">
                                                <g:formatNumber number="${ecritureDossier.montant}"
                                                                format="###,##0.00 DH"/>
                                                <g:if test="${ecritureDossier?.etat.id == 2}"><g:set var="creditFrais"
                                                                                                     value="${creditFrais + ecritureDossier.montant}"/></g:if>
                                            </g:if>
                                        </td>
                                        <td class="dateCell valeur"><etude:relativeDate
                                                date="${ecritureDossier.dateValeur}"/></td>
                                        <td class="dateCell mouvement"><etude:relativeDate
                                                date="${ecritureDossier.dateMouvement}"/></td>
                                        <td class="icon" title="${ecritureDossier.etat}"><span
                                                class="${etude.etatIcon(etat: ecritureDossier.etat)}"></span><span
                                                class="noshow">${ecritureDossier.etat}</span><etude:databar
                                                controller="ecritureDossier"
                                                fields="[from: 'dossier', id: ecritureDossier?.id]"
                                                style="margin-top:-0.5em;">
                                            <g:link modalwidth="1000" class="modal" title="Modifier ecriture de dossier"
                                                    controller="ecritureDossier" action="${canModif ? 'edit' : 'show'}"
                                                    params="['id': ecritureDossier?.id, 'from': 'dossier']">Modif.</g:link><g:if
                                                    test="${canDelete}">&nbsp;<g:actionSubmit class="link danger"
                                                                                              value="Suppr."
                                                                                              title="Supprimer"
                                                                                              action="delete"/></g:if>
                                            <g:if test="${ecritureDossier?.typeEcriture?.credit}">
                                                &nbsp;<g:link controller="ecritureDossier" class="tdform button"
                                                              title="Imprimer un re\347u" action="receipt"
                                                              id="${ecritureDossier.id}">Re&#231;u</g:link>
                                            </g:if>
                                        </etude:databar></td>
                                    </etude:tr>
                                </g:each>
                                </tbody>
                                <tfooter>
                                    <tr>
                                        <th>Total:</th>
                                        <th></th>
                                        <th class="moneyCell debit"><g:formatNumber number="${debitFrais}"
                                                                              format="###,##0.00 DH"/></th>
                                        <th class="moneyCell credit"><g:formatNumber number="${creditFrais}"
                                                                              format="###,##0.00 DH"/></th>
                                        <th></th>
                                        <th class="moneySummaryCell ${creditFrais < debitFrais ? 'debit' : 'credit'}"><span class="normal left">Solde: </span><span
                                                style="color:${creditFrais < debitFrais ? 'red' : 'green'}">
                                            <g:formatNumber number="${creditFrais - debitFrais}"
                                                            format="###,##0.00 DH"/>
                                        </span></th>
                                        <th></th>
                                    </tr>
                                </tfooter>
                            </table>
                        </div>
                    </g:if>
                    <g:else><i>Aucune &eacute;criture frais n'a &eacute;t&eacute; associ&eacute;e au dossier</i></g:else>
                </td>
            </tr>
            <tr class="prop">
                <td valign="top" class="name"><div><h3>Prix :</h3></div>
                    <g:if test="${!listePrix?.empty}">
                        <div class="list">
                            <g:set var="debitPrix" value="${0.0f}"/>
                            <g:set var="creditPrix" value="${0.0f}"/>
                            <table>
                                <thead>
                                <tr>
                                    <th>M.P</th>
                                    <th>Libell&eacute;</th>
                                    <th>D&eacute;bit</th>
                                    <th>Cr&eacute;dit</th>
                                    <th class="dateCell">Date D&eacute;p&ocirc;t</th>
                                    <th class="dateCell">Date Encaissement</th>
                                    <th>Etat</th>
                                </thead>
                                <tbody>
                                <g:each in="${listePrix}" status="i" var="ecritureDossier">
                                    <etude:tr databar="['post': ['edit', 'delete'], 'get': 'receipt']"
                                              title="${ecritureDossier.compteBancaire ? 'Compte Bancaire : ' + ecritureDossier.compteBancaire.libelle : 'Aucun Compte Bancaire'}"
                                              class="prix${(i % 2) == 0 ? 'odd' : 'even'}" align="middle" valign="top"
                                              ctrl="ecritureDossier" id="${ecritureDossier.id}"
                                              obj="${ecritureDossier}">
                                        <td class="icon"><span
                                                class="${etude.mpIcon(mp: ecritureDossier.moyenPaiement)}">&nbsp;</span><span
                                                class="noshow">${ecritureDossier.moyenPaiement}</span></td>
                                        <td class="linktip"><div class="prey">
                                            <g:link controller="ecritureDossier" action="show"
                                                    id="${ecritureDossier.id}">${(ecritureDossier.marked ? "(*) " : "") + ecritureDossier.typeEcriture?.libelle.encodeAsHTML()}</g:link><g:if
                                                test="${ecritureDossier.commentaire}"><br/><span
                                                        class="tip">${ecritureDossier.commentaire.encodeAsHTML()}</span></g:if></div>
                                        </td>
                                        <td class="moneyCell debit ${ecritureDossier.montant && !ecritureDossier?.typeEcriture?.credit ? '' : 'noval'}">
                                            <g:if test="${ecritureDossier.montant && !ecritureDossier?.typeEcriture?.credit}">
                                                <g:formatNumber number="${ecritureDossier.montant}"
                                                                format="###,##0.00 DH"/>
                                                <g:set var="debitPrix" value="${debitPrix + ecritureDossier.montant}"/>
                                            </g:if>
                                        </td>
                                        <td class="moneyCell credit ${ecritureDossier.montant && ecritureDossier?.typeEcriture?.credit ? '' : 'noval'}">
                                            <g:if test="${ecritureDossier.montant && ecritureDossier?.typeEcriture?.credit}">
                                                <g:formatNumber number="${ecritureDossier.montant}"
                                                                format="###,##0.00 DH"/>
                                                <g:if test="${ecritureDossier?.etat.id == 2}"><g:set var="creditPrix"
                                                                                                     value="${creditPrix + ecritureDossier.montant}"/></g:if>
                                            </g:if>
                                        </td>
                                        <td class="dateCell valeur"><etude:relativeDate
                                                date="${ecritureDossier.dateValeur}"/></td>
                                        <td class="dateCell mouvement"><etude:relativeDate
                                                date="${ecritureDossier.dateMouvement}"/></td>
                                        <td class="icon" title="${ecritureDossier.etat}"><span
                                                class="${etude.etatIcon(etat: ecritureDossier.etat)}">&nbsp;</span><span
                                                class="noshow">${ecritureDossier.etat}</span><etude:databar
                                                controller="ecritureDossier"
                                                fields="${[from: 'dossier', id: ecritureDossier?.id]}"
                                                style="margin-top:-0.5em;">
                                            <g:link modalwidth="1000" class="modal" title="Modifier ecriture de dossier"
                                                    controller="ecritureDossier" action="${canModif ? 'edit' : 'show'}"
                                                    params="['id': ecritureDossier?.id, 'from': 'dossier']">Modif.</g:link>
                                            <g:if test="${canDelete}">&nbsp;<g:actionSubmit class="link danger"
                                                                                            value="Suppr."
                                                                                            title="Supprimer"
                                                                                            action="delete"/></g:if>
                                            <g:if test="${ecritureDossier?.typeEcriture?.credit}">
                                                &nbsp;<g:link controller="ecritureDossier" class="tdform button"
                                                              title="Imprimer un re\347u" action="receipt"
                                                              id="${ecritureDossier.id}">Re&#231;u</g:link>
                                            </g:if>
                                        </etude:databar></td>
                                    </etude:tr>
                                </g:each>
                                </tbody>
                                <tfooter>
                                    <tr>
                                        <th>Total:</th>
                                        <th></th>
                                        <th class="moneyCell"><g:formatNumber number="${debitPrix}"
                                                                              format="###,##0.00 DH"/></th>
                                        <th class="moneyCell"><g:formatNumber number="${creditPrix}"
                                                                              format="###,##0.00 DH"/></th>
                                        <th></th>
                                        <th class="moneySummaryCell ${creditPrix < debitPrix ? 'debit' : 'credit'}"><span class="normal left">Solde: </span><span
                                                style="color:${creditPrix < debitPrix ? 'red' : 'green'}">
                                            <g:formatNumber number="${creditPrix - debitPrix}" format="###,##0.00 DH"/>
                                        </span></th>
                                        <th></th>
                                    </tr>
                                </tfooter>
                            </table>
                        </div>
                    </g:if>
                    <g:else><span
                            class="comment">Aucune &eacute;criture prix n'a &eacute;t&eacute; associ&eacute;e au dossier</span></g:else>
                </td>
            </tr>
            <tr class="prop">
                <td valign="top" class="name"><div><h3>Actes :</h3></div>
                    <ul>
                        <g:each var="acte" in="${actes}">
                            <li ${etude.addHover(ctrlName: 'acte', id: acte.id)}><etude:linkActe acte="${acte}"/></li>
                        </g:each>
                    </ul>
                    <g:if test="${actes?.empty}">
                        <span class="comment">Aucun acte n'a &eacute;t&eacute; associ&eacute; au dossier</span>
                    </g:if>
                </td>
            </tr>
            <g:if test="${dossier?.operation}">
                <tr class="prop">
                    <td valign="top" class="name"><div><h3>Biens :<g:link class="highlightedFeature noprint modal"
                                                                          controller="bien" action="list"
                                                                          params="['mode': 'select', 'addTo': 'Dossier', 'id': dossier.id, 'from': 'dossier']"
                                                                          style="max-width:-moz-max-content;"><span
                                class="database_add"></span>Ajouter des biens de l'op&eacute;ration ${dossier.operation}</g:link>
                    </h3></div>
                        <ul>
                            <g:each var="b" in="${biens}">
                                <li><etude:linkBien bien="${b}"/></li>
                            </g:each>
                        </ul>
                        <g:if test="${biens?.empty}">
                            <span class="comment">Aucun bien n'a &eacute;t&eacute; associ&eacute; au dossier</span>
                        </g:if>
                    </td>
                </tr>
            </g:if>
            </tbody>
        </table>
    </div>

    <div class="buttons">
        <g:form accept-charset="UTF-8" controller="dossier">
            <input type="hidden" name="id" value="${dossier?.id}"/>
            <g:actionSubmit class="default modal" value="Modifier" action="edit" modalwidth="700"/>
            <g:actionSubmit class="danger" value="Supprimer" action="delete"/>
        </g:form>
    </div>
</div>

</body>
</html>
