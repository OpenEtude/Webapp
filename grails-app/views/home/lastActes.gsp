<g:if test="${!acteList?.empty}">
<span class="tip">r&eacute;cents : </span>
<ul><g:each in="${acteList}" status="i" var="entry">
<li class="${(i % 2) == 0 ? 'odd' : 'even'}" ${etude.addHover(ctrlName:'acte',id:entry.acte.id)}><etude:linkActe class="ellipsis" acte="${entry.acte}" barstyle="min-width:none;min-height:none;margin-left:auto;margin-right:0;right:0;left:auto;top:auto;height:0.0em;width:5em;top:0px;margin-top:-1.4em;margin-bottom:1em;"/><br/><span class="noimg ico"></span><span class="tip ellipsis">Dossier :&nbsp;${entry.acte?.dossier?.encodeAsHTML()}</span><g:if test="${entry.opType}"><i>(<g:message code="activity.opType.${entry.opType?.encodeAsHTML()}"/>)</i></g:if></li>
</g:each></ul>
</g:if>
