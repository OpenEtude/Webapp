  
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
            
            <g:if test="${title}">
            <span class="menuButton"><g:link controller="compteBancaire" action="synthese"><span class="database_table ico"></span>Comptes Bancaires</g:link></span>
            <span class="menuButton"><mymodal:createLink sclass="database_table" controller="ecriture" action="export" title="Relev&eacute; de Compte Bancaire" linkname="Nouvelle Relev&eacute;" width="600"/></span>
            </g:if>
            <g:else>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouvelle Ecriture</g:link></span>
            </g:else>
        </div>
<jsec:hasPermission type="EtudePerm" target="Ecriture" actions="RapportDetail">
		<div class="searchbox">
<g:form border="0" url='[controller: "ecriture", action: "simpleSearch"]'   id="ecritureSearch" name="ecritureSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
			<etude:keyword name="q" accesskey="s" id="keybox" value="${params.q}" hint="${'Montant, Piece ou Commentaire'.encodeAsJavaScript()}"/>
</g:form>
		</div>
</jsec:hasPermission>
        <div class="body">
            <g:if test="${title}">
            <h1>${title}</h1>
            </g:if>
            <g:else>
            <h1>Liste des Ecritures</h1>
            </g:else>
            <g:if test="${tip}">
            <span class="tip">${tip}</span><br/><br/><br/>
            </g:if>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
			<g:if test="${!ecritureDossierMap.empty}">
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
							<g:sortableColumn property="moyenPaiement" title="M.P"/>

							<g:sortableColumn property="typeEcriture" title="Libell&eacute;" />
		
                   	        <g:sortableColumn property="montant" title="D&eacute;bit" />
                        
                   	        <g:sortableColumn property="montant" title="Cr&eacute;dit" />
                        
                   	        <g:sortableColumn property="dateValeur" title="Date D&eacute;p&ocirc;t" />
                        
                   	        <g:sortableColumn property="dateMouvement" title="Date Encaissement" />
                        
                   	        <g:sortableColumn property="etat" title="Etat" />
                        </tr>
                    </thead>
                    <tbody>
					<g:set var="i" value="${-1}" />
                    <g:each in="${ecritureDossierMap}" var="entry">
                     <tr class="tip">
                        <td colspan="7"><h2><g:if test="${entry.key}">
							<g:link controller="compteBancaire" action="detail" id="${entry.key.id}">${entry.key.libelle.encodeAsHTML()}</g:link></g:if><g:else>Sans compte bancaire</g:else></h2></td>
                     </tr>
                    <g:each in="${entry.value}" var="ecritureDossier">
						<% i++ %>
						<etude:tr ctrl="${ecritureDossier instanceof EcritureDossier ? 'ecritureDossier':'ecriture'}" id="${ecritureDossier.id}" class="${(ecritureDossier.typeEcriture?.categorieEcriture?.id==1?'frais': ecritureDossier.typeEcriture?.categorieEcriture?.id==2?'prix':'')+((i % 2) == 0 ? 'odd' : 'even')}">
                        
                            <td class="icon"><span class="${etude.mpIcon(mp:ecritureDossier.moyenPaiement)}">&nbsp;</span><span class="noshow">${ecritureDossier.moyenPaiement}</span></td>
                        
							<td>${(ecritureDossier.marked ? "(*) ": "") + ecritureDossier.typeEcriture?.libelle?.encodeAsHTML()}<g:if test="${ecritureDossier.commentaire}"><br/><span class="tip">${ecritureDossier.commentaire.encodeAsHTML()}</span></g:if></td>
                        
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
							<td class="dateCell"><etude:relativeDate date="${ecritureDossier.dateValeur}"/></td>
							<td class="dateCell"><etude:relativeDate date="${ecritureDossier.dateMouvement}"/></td>
							<td class="icon" title="${ecritureDossier.etat}"><span class="${etude.etatIcon(etat:ecritureDossier.etat)}">&nbsp;</span><span class="noshow">${ecritureDossier.etat}</span></td>
                        </etude:tr>
                    </g:each>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <g:if test="${nopaginate}">
            <div class="paginateButtons"/>
            </g:if>
            <g:else>
            <div class="paginateButtons">
                <g:paginate total="${count}" />
            </div>
            </g:else>
            </g:if>
            <g:else><span class="tip">Aucune ecriture ne correspond &agrave; vos crit&egrave;res</span>
            </g:else>
        </div>
		</body>
</html>
