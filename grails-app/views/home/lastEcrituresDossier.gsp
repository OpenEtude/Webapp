<g:if test="${!ecritureDossierList?.empty}">
<p><span class="tip">r&eacute;centes : </span>
<ul><g:each in="${ecritureDossierList}" status="i" var="entry">
<li class="${entry.ecritureDossier.typeEcriture.categorieEcriture.id==1 ? 'frais':'prix'}${(i % 2) == 0 ? 'odd' : 'even'}"  ${etude.addHover(ctrlName:'ecritureDossier',id:entry.ecritureDossier.id)}><span class="${etude.mpIcon(mp:entry.ecritureDossier.moyenPaiement)}"></span><span class="${etude.etatIcon(etat:entry.ecritureDossier.etat)}"></span><g:link controller="ecritureDossier" action="show" id="${entry.ecritureDossier?.id}" title="Dossier :&nbsp;${entry.ecritureDossier?.dossier?.encodeAsHTML()}">${(entry.ecritureDossier.marked ? "(*) ": "") + entry.ecritureDossier?.encodeAsHTML()}</g:link><br/><span class="tip ellipsis60">${entry.ecritureDossier?.commentaire?.encodeAsHTML()}</span>&nbsp;<g:if test="${entry.opType}"><i>(<g:message code="activity.opType.${entry.opType?.encodeAsHTML()}"/>)</i></g:if>
<etude:databar controller="ecritureDossier" fields="${[id:entry.ecritureDossier.id]}" style="min-width:none;min-height:none;margin-left:auto;margin-right:0;right:0;left:auto;top:auto;height:0.0em;width:5em;top:0px;margin-top:-1.4em;margin-bottom:1em;">
<g:actionSubmit class="link modal" modalwidth="1000" value="Modif." title="Modifier" action="edit"/>
<jsec:hasPermission type="EtudePerm" target="EcritureDossier" actions="Suppression">&nbsp;
<g:actionSubmit class="link danger" value="Suppr." title="Supprimer" action="delete"/>
</jsec:hasPermission>
</etude:databar></li>
</g:each></ul>
</g:if>
