  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
		<g:if test="${title}">
		<title>${title}</title>
		</g:if>
		<g:else>
		<title>Liste des Ecritures</title>
		</g:else>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><mymodal:createLink sclass="search" controller="ecriture" action="search" title="Nouvelle Recherche" linkname="Nouvelle Recherche" width="600"/></span>
        </div>
<jsec:hasPermission type="EtudePerm" target="Ecriture" actions="RapportDetail">
		<g:if test="${params.simple=='true'}">
		<div class="searchbox">
<g:form border="0" url='[controller: "ecriture", action: "simpleSearch"]'   id="ecritureSearch" name="ecritureSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
			<etude:keyword name="q" accesskey="s" id="keybox" value="${params.q}" hint="${'Montant, Piece ou Commentaire'.encodeAsJavaScript()}"/>
</g:form>
		</div>
		</g:if>
</jsec:hasPermission>
        <div class="body">
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <g:if test="${title}">
            <h1>${title}</h1>
            </g:if>
            <g:else>
            <h1>R&eacute;sultats de la recherche</h1>
            </g:else>
			<g:if test="${!ecritureDossierList.empty}">
            <span class="tip"><b>${count} &eacute;l&eacute;ments trouv&eacute;s</b>${(compteBancaire? ", Compte Bancaire : $compteBancaire": '')}${(typeEcriture? ", Libell&eacute; : $typeEcriture": '')}<g:if test="${montant}">, montant : <g:formatNumber number="${montant}" format="###,##0.00 DH" /></g:if>${(commentaire || !simple && commentaire? ", commentaire : $commentaire":'')}${(pieceComptable || !simple && pieceComptable? ", pi&egrave;ce comptable : $pieceComptable": '')}${(etat? ", &eacute;tat : $etat": '')} <g:if test="${!simple}">, entre le <g:formatDate format="dd MMMM yyyy" date="${debut}"/> et le <g:formatDate format="dd MMMM yyyy" date="${fin}"/> </g:if></span><br/><br/><br/>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
							<g:sortableColumn action="results" params="${sortParams}" property="moyenPaiement" title="M.P"/>

							<g:sortableColumn action="results" params="${sortParams}" property="typeEcriture" title="Libell&eacute;" />
		
							<g:sortableColumn action="results" params="${sortParams}" property="compteBancaire" title="Compte Bancaire" />
		
                   	        <g:sortableColumn action="results" params="${sortParams}" property="montant" title="D&eacute;bit" />
                        
                   	        <g:sortableColumn action="results" params="${sortParams}" property="montant" title="Cr&eacute;dit" />
                        
                   	        <g:sortableColumn action="results" params="${sortParams}" property="dateValeur" title="Date D&eacute;p&ocirc;t" />
                        
                   	        <g:sortableColumn action="results" params="${sortParams}" property="dateMouvement" title="Date Encaissement" />
                        
                   	        <g:sortableColumn action="results" params="${sortParams}" property="pieceComptable" title="Pi&egrave;ce Comptable" />
                        
                   	        <g:sortableColumn action="results" params="${sortParams}" property="etat" title="Etat" />
                   	    
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${ecritureDossierList}" status="i" var="ecritureDossier">
						<etude:tr ctrl="${ecritureDossier instanceof EcritureDossier ? 'ecritureDossier':'ecriture'}" id="${ecritureDossier.id}" class="${(ecritureDossier.typeEcriture?.categorieEcriture?.id==1?'frais': ecritureDossier.typeEcriture?.categorieEcriture?.id==2?'prix':'')+((i % 2) == 0 ? 'odd' : 'even')}">
                            <td class="icon"><span class="${etude.mpIcon(mp:ecritureDossier.moyenPaiement)}">&nbsp;</span><span class="noshow">${ecritureDossier.moyenPaiement}</span></td>
							<td><g:if test="${ecritureDossier instanceof EcritureDossier}">
							<etude:linkDossier dossier="${ecritureDossier.dossier}"/><br/></g:if>${(ecritureDossier.marked ? "(*) ": "") + ecritureDossier.typeEcriture?.libelle?.encodeAsHTML()}<g:if test="${ecritureDossier.commentaire}"><br/><span class="tip">${ecritureDossier.commentaire.encodeAsHTML()}</span></g:if></td>
                            <td><g:if test="${ecritureDossier?.compteBancaire}"><g:link controller="compteBancaire" action="detail" id="${ecritureDossier.compteBancaire?.id}">${ecritureDossier.compteBancaire?.libelle.encodeAsHTML()}</g:link></g:if></td>
							<td class="moneyCell">
							<g:if test="${!ecritureDossier?.typeEcriture?.credit}">
							<g:formatNumber number="${ecritureDossier.montant}" format="###,##0.00 DH" />
							</g:if>
							</td>
							<td class="moneyCell">
							<g:if test="${ecritureDossier?.typeEcriture?.credit}">
							<g:formatNumber number="${ecritureDossier.montant}" format="###,##0.00 DH" />
							</g:if>
							</td>
							<td><etude:relativeDate sentence="true" date="${ecritureDossier.dateValeur}"/></td>
							<td><etude:relativeDate sentence="true" date="${ecritureDossier.dateMouvement}"/></td>
                            <td>${ecritureDossier.pieceComptable?.encodeAsHTML()}</td>
							<td class="icon" title="${ecritureDossier.etat}"><span class="${etude.etatIcon(etat:ecritureDossier.etat)}">&nbsp;</span><span class="noshow">${ecritureDossier.etat}</span></td>
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${count}" params="${params}"/>
            </div>
            </g:if>
            <g:else><span class="tip"><b>${count} &eacute;l&eacute;ments trouv&eacute;s</b>${(compteBancaire? ", Compte Bancaire : $compteBancaire": '')}${(typeEcriture? ", Libell&eacute; : $typeEcriture": '')}<g:if test="${montant}">, montant : <g:formatNumber number="${montant}" format="###,##0.00 DH" /></g:if>${(commentaire || !simple && commentaire? ", commentaire : $commentaire":'')}${(pieceComptable || !simple && pieceComptable? ", pi&egrave;ce comptable : $pieceComptable": '')}${(etat? ", &eacute;tat : $etat": '')} <g:if test="${!simple}">, entre le <g:formatDate format="dd MMMM yyyy" date="${debut}"/> et le <g:formatDate format="dd MMMM yyyy" date="${fin}"/> </g:if></span><br/><br/><br/>
            </g:else>
        </div>
		</body>
</html>
