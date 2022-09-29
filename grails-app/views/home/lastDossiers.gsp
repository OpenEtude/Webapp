<g:if test="${!dossierList?.empty}">
<p><span class="tip">r&eacute;cents : </span>
<ul><g:each in="${dossierList}" status="i" var="entry">
<li class="${(i % 2) == 0 ? 'odd' : 'even'}" ${etude.addHover(ctrlName:'dossier',id:entry.dossier.id)}><etude:linkDossier class="ellipsis" dossier="${entry.dossier}" /><br/><span class="tip ellipsis">${entry.dossier?.description?.encodeAsHTML()} ${entry.dossier?.operation ? " - op&eacute;ration " + entry.dossier?.operation?.encodeAsHTML() : ''}</span> <g:if test="${entry.opType}"><i>(<g:message code="activity.opType.${entry.opType?.encodeAsHTML()}"/>)</i></g:if>
<etude:databar controller="dossier" fields="${[id:entry.dossier.id]}" style="min-width:none;min-height:none;margin-left:auto;margin-right:0;right:0;left:auto;top:auto;height:0.0em;width:5em;top:0px;margin-top:-1.4em;margin-bottom:1em;">
<g:actionSubmit class="link modal" modalwidth="600" value="Modif." title="Modifier" action="edit"/>
</etude:databar></li>
</g:each></ul>
</g:if>
