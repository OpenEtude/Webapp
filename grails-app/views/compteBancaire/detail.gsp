  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
		<g:if test="${title}">
		<title>${title}</title>
		</g:if>
		<g:else>
		<title>D&eacute;tail du compte ${compteBancaire}</title>
		</g:else>
    </head>
    <body>
        <div class="nav">
            
			<span class="menuButton"><mymodal:createLink sclass="database_add" controller='ecriture' params='["compte.id":compteBancaire?.id]' action='create' title="Nouvelles &eacute;criture : compte bancaire ${' '+compteBancaire.libelle}" linkname="Nouvelle Ecriture" width="600"/></span>&nbsp;|&nbsp;
            <span class="menuButton"><g:link controller="compteBancaire" action="synthese"><span class="database_table ico"></span>Situation des Comptes Bancaires</g:link></span>
            <span class="menuButton"><g:link controller="ecriture" action="affect" id="${compteBancaire.id}"><span class="database_edit ico"></span>Affectation d'écritures</g:link></span>
            <span class="menuButton"><g:link controller="ecriture" action="validate" id="${compteBancaire.id}"><span class="accept ico"></span>Rapprochement</g:link></span>
            <g:if test="${!hasSoldeInitial}">
                <span class="menuButton"><g:link controller="ecriture" action="create" params="['type':'autre','etat.id':2,'typeEcriture.id':61,'compte.id':compteBancaire.id]"><span class="database_add ico"></span><g:message code="domain.CompteBancaire.addEcri" default="Définir solde initial" /></g:link></span>
            </g:if>
            <span class="menuButton"><g:link controller="compteBancaire" action="edit" id="${params.id}"><span class="database_edit ico"></span>Modifier le compte</g:link></span>

        </div>
		<div class="searchbox">
<g:form border="0" url='[controller: "compteBancaire", action: "detail"]'   id="ecritureSearch" name="ecritureSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
			<etude:keyword name="q" accesskey="s" id="keybox" value="${params.q}" hint="${'Montant, Piece ou Commentaire'.encodeAsJavaScript()}"/>
</g:form>
		</div>
    <div class="body">
            <g:if test="${title}">
            <h1>${title}</h1>
            </g:if>
            <g:else>
            <h1>D&eacute;tail du compte ${compteBancaire}</h1>
            </g:else>
            <g:if test="${tip}">
            <span class="tip">${tip}</span><br/><br/><br/>
            </g:if>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
			<g:if test="${!ecritureDossierMap.empty}">
            <div style="padding:10px 10px">
            <g:if test="${compteBancaire.agence}">
			<span><b>Agence :</b> ${compteBancaire.agence}</span>
            </g:if>
            <g:if test="${compteBancaire.rib}">
			<span><b>Rib :</b> ${compteBancaire.rib}</span>
            </g:if>
            <g:if test="${compteBancaire.contact}">
			<span><b>Contact :</b> ${compteBancaire.contact}</span>
            </g:if>
            <g:if test="${compteBancaire.telephone}">
			<span><b>T&eacute;l. :</b> ${compteBancaire.telephone}</span>
            </g:if>
            <g:if test="${compteBancaire.fax}">
			<span><b>Fax :</b> ${compteBancaire.fax}</span>
            </g:if>
            </div>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
							<g:sortableColumn property="moyenPaiement" title="M.P" params="${sortParams}"/>

							<g:sortableColumn property="typeEcriture" title="Libell&eacute;" params="${sortParams}"/>
		
							<g:sortableColumn property="montant" title="D&eacute;bit" params="${sortParams}"/>
						
							<g:sortableColumn property="montant" title="Cr&eacute;dit" params="${sortParams}"/>
						
                   	        <g:sortableColumn property="dateValeur" title="Date D&eacute;p&ocirc;t" params="${sortParams}"/>
                        
                   	        <g:sortableColumn property="dateMouvement" title="Date Encaissement" params="${sortParams}"/>
                        
                   	        <g:sortableColumn property="pieceComptable" title="Pi&egrave;ce Comptable" params="${sortParams}"/>
                   	    
                   	        <g:sortableColumn property="etat" title="Etat" params="${sortParams}"/>
                   	    
                        	<td class="noprint"/>
                        </tr>
                    </thead>
                    <tbody>
					<g:set var="i" value="${-1}" />
                    <tbody>
                    <g:each in="${ecritureDossierMap}" var="entry">
                     <tr class="tip">
                        <td colspan="8"><h2><g:if test="${entry.key instanceof Dossier}">
							<etude:linkDossier dossier="${entry.key}"/></g:if><g:else>Sans dossier</g:else></h2></td>
                     </tr>
                    <g:each in="${entry.value}" var="ecritureDossier">
						<% i++ %>
						<etude:tr ctrl="${ecritureDossier instanceof EcritureDossier ? 'ecritureDossier':'ecriture'}" id="${ecritureDossier.id}" class="${(ecritureDossier.typeEcriture?.categorieEcriture?.id==1?'frais': (ecritureDossier.typeEcriture?.categorieEcriture?.id==2 ? 'prix' : ''))+((i % 2) == 0 ? 'odd' : 'even')}">
                        
                            <td class="icon"><span class="${etude.mpIcon(mp:ecritureDossier.moyenPaiement)}">&nbsp;</span><span class="noshow">${ecritureDossier.moyenPaiement}</span></td>
                        
							<td><g:link action="edit" controller="${ecritureDossier instanceof EcritureDossier ? 'ecritureDossier':'ecriture'}"  id="${ecritureDossier.id}">${(ecritureDossier.marked ? "(*) ": "") + ecritureDossier.typeEcriture?.id} - ${ecritureDossier.typeEcriture?.libelle?.encodeAsHTML()}</g:link><g:if test="${ecritureDossier.commentaire}"><br/><span class="tip">${ecritureDossier.commentaire.encodeAsHTML()}</span></g:if></td>
                        
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
                        
                            <td>${ecritureDossier.pieceComptable?.encodeAsHTML()}</td>
                        
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
                <g:paginate total="${count}" params="${paginateParams}"/>
            </div>
            </g:else>
            </g:if>
            <g:else><span class="tip">Aucune &eacute;criture ne correspond &agrave; vos crit&egrave;res</span>
            </g:else>
        </div>
		</body>
</html>
