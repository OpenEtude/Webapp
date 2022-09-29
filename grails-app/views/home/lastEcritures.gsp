<g:if test="${!ecritureList?.empty}">
<p><span class="tip">r&eacute;centes : </span>
<ul><g:each in="${ecritureList}" status="i" var="entry">
<li class="${(i % 2) == 0 ? 'odd' : 'even'}" ${etude.addHover(ctrlName:'ecriture',id:entry.ecriture.id)}><span class="${etude.mpIcon(mp:entry.ecriture.moyenPaiement)}"></span><span class="${etude.etatIcon(etat:entry.ecriture.etat)}"></span><g:link controller="ecriture" action="show" id="${entry.ecriture?.id}" title="Compte :&nbsp;${entry.ecriture?.compteBancaire ? entry.ecriture?.compteBancaire?.encodeAsHTML() : '<Aucun>'}">${entry.ecriture?.encodeAsHTML()}</g:link><br/><span class="tip ellipsis60">${entry.ecriture?.commentaire?.encodeAsHTML()}</span>&nbsp;<g:if test="${entry.opType}"><i>(<g:message code="activity.opType.${entry.opType?.encodeAsHTML()}"/>)</i></g:if><etude:databar controller="ecriture" fields="${[id:entry.ecriture.id]}" style="min-width:none;min-height:none;margin-left:auto;margin-right:0;right:0;left:auto;top:auto;height:0.0em;width:5em;top:0px;margin-top:-1.4em;margin-bottom:1em;">
<g:actionSubmit class="link modal" modalwidth="1000" value="Modif." title="Modifier" action="edit"/>
<jsec:hasPermission type="EtudePerm" target="Ecriture" actions="Suppression">&nbsp;
<g:actionSubmit class="link danger" value="Suppr." title="Supprimer" action="delete"/>
</jsec:hasPermission>
</etude:databar>
</li>
</g:each></ul>
</g:if>
