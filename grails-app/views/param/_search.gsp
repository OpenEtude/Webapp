<g:if test="${params.controller != 'home'}">
<g:form border="0" url='[controller: "dossier", action: "search"]'   id="dossierSearch" name="dossierSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
			<div class="tip">Recherche de Dossier : </div>
			<etude:keyword id="dq" name="q" accesskey="s" value="${params.q}" hint='Num ou Nom Dossier' title="${'Numéro ou Nom de dossier'.encodeAsJavaScript()}" lookup="true" controller="dossier" xhrType="xml"/>
</g:form>
</g:if>
<g:form border="0" url='[controller: "acte", action: "search"]'   id="acteSearch" name="acteSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
			<div class="tip">Recherche d'acte : </div>
			<etude:keyword id="aq" name="q" accesskey="s" value="${params.q}" hint='Num ou Nom Acte' title="${'Numéro de répertoire ou Nom acte'.encodeAsJavaScript()}" lookup="true" controller="acte" xhrType="xml"/>
</g:form>
<jsec:hasPermission type="EtudePerm" target="Ecriture" actions="RapportDetail">
<g:form border="0" url='[controller: "ecriture", action: "simpleSearch"]'   id="ecritureSearch" name="ecritureSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
			<div class="tip">Recherche d'&eacute;critures : </div>
			<etude:keyword id="eq" name="q" accesskey="s" value="${params.q}" hint="${'Montant, Piece ou Commentaire'.encodeAsJavaScript()}"  controller="ecriture" />
</g:form>
</jsec:hasPermission>
