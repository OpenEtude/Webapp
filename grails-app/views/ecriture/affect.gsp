  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Affectation d'&eacute;critures au compte ${compteBancaire}</title>
    </head>
    <body>

        <div class="nav">
            
            <span class="menuButton"><g:link controller="compteBancaire" action="synthese"><span class="database_table ico"></span>Situation des Comptes Bancaires</g:link></span>
            <span class="menuButton"><g:link controller="compteBancaire" action="detail" id="${compteBancaire.id}"><span class="database_table ico"></span>D&eacute;tail du compte ${compteBancaire}</g:link></span>
            <span class="menuButton"><g:link controller="ecriture" action="validate" id="${compteBancaire.id}"><span class="accept ico"></span>Rapprochement du compte ${compteBancaire}</g:link></span>
        </div>
		<div class="searchbox">
<g:form border="0" url='[controller: "ecriture", action: "affect"]'   id="ecritureSearch" name="ecritureSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
			<etude:keyword name="q" accesskey="s" id="keybox" value="${params.q}" hint="${'Montant, Piece ou Commentaire'.encodeAsJavaScript()}"/>
</g:form>
		</div>
        <div class="body">
			<h1>Affectation d'&eacute;critures au compte ${compteBancaire}</h1>
            <g:if test="${ecritureDossierMap.keySet().empty}">
				<i>Toutes les &eacute;critures sont d&eacute;j&agrave; affect&eacute;es</i>
            </g:if>
            <g:else>
				<i>${count} &eacute;critures non affect&eacute;es : </i>
			<g:form accept-charset="UTF-8" method="post" >
			<input type="hidden" name="listSize" value="${listSize}" />
			<input type="hidden" name="compteBancaire.id" value="${compteBancaire.id}" />
			<div class="buttons">
				<div  style="width:100%;text-align:right;padding-right:20px">
				<span class="button">
				<span class="menuButton"><a href="#" class="selectall">S&eacute;lectionner Tout</a></span>&nbsp;|&nbsp;
				<span class="menuButton"><a href="#" class="selectnone">Aucune S&eacute;lection</a></span>&nbsp;|&nbsp;
				<g:actionSubmit class="validate" onclick="return confirm('Etes-vous sur de vouloir affecter au compte ${' ' +compteBancaire}?');" action="submitToAffect" value="Affecter la s&eacute;lection" /></span>
				</div>
			</div>
            <g:if test="${flash.message}">
            <div class='message'>${flash.message}</div>
            </g:if>
            <g:if test="${flash.messageError}">
            <div class='error'>${flash.messageError}</div>
            </g:if>
			<br/>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                   	        <g:sortableColumn action="affect" id="${compteBancaire.id}" property="moyenPaiement" title="M.P"  params="${sortParams}"/>

							<g:sortableColumn action="affect" id="${compteBancaire.id}" property="typeEcriture" title="Libell&eacute;"  params="${sortParams}"/>
		
                   	        <g:sortableColumn action="affect" id="${compteBancaire.id}" property="montant" title="D&eacute;bit"  params="${sortParams}"/>
                        
                   	        <g:sortableColumn action="affect" id="${compteBancaire.id}" property="montant" title="Cr&eacute;dit"  params="${sortParams}"/>
                        
                   	        <g:sortableColumn action="affect" id="${compteBancaire.id}" property="dateValeur" title="Date D&eacute;p&ocirc;t"  params="${sortParams}"/>
                        
                   	        <g:sortableColumn action="affect" id="${compteBancaire.id}" property="dateMouvement" title="Date Encaissement"  params="${sortParams}"/>
                        
                   	        <g:sortableColumn action="affect" id="${compteBancaire.id}" property="pieceComptable" title="Pi&egrave;ce Comptable"  params="${sortParams}"/>
                   	    
                   	        <th></th>
                        </tr>
                    </thead>
					<g:set var="dat" value="${new java.text.SimpleDateFormat('dd/MM/yyyy')}" />
					<g:set var="i" value="${-1}" />
                    <tbody>
                    <g:each in="${ecritureDossierMap}" var="entry">
                     <tr class="tip">
                        <td colspan="8"><h2><g:if test="${entry.key instanceof Dossier}">
							<etude:linkDossier dossier="${entry.key}"/></g:if><g:else>Sans dossier</g:else></h2></td>
                     </tr>
                    <g:each in="${entry.value}" var="ecritureDossier">
						<% i++ %>
                        <tr class="${(ecritureDossier.typeEcriture?.categorieEcriture?.id==1?'frais': ecritureDossier.typeEcriture?.categorieEcriture?.id==2?'prix':'')}${(i % 2) == 0 ? 'odd' : 'even'}">
                        
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
                        
							<td class="checkfix"><input type="text" class="date" name="dateValeur${i}" value="${dat.format(ecritureDossier?.dateValeur)}"></td>
						
							<td class="checkfix"><input type="text" class="date" name="dateMouvement${i}" value="${dat.format(ecritureDossier?.dateMouvement)}"></td>
						
							<td class="checkfix"><input type="text" size="25" name="commentaire${i}" value="${ecritureDossier.pieceComptable?.encodeAsHTML()}"></td>
						
                   	        <td class="checkfix">
								<input type="hidden" name="id${i}" value="${ecritureDossier?.id}" />
								<g:checkBox name="check${i}" value="${false}"/>
							</td>

                        </tr>
                    </g:each>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate params="${paginateParams}" total="${count}" />
            </div>
			</g:form>
        </g:else>
        </div>
    </body>
</html>
