  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>S&eacute;lection d'&eacute;critures</title>
</head>
    <body>

        <div class="nav">
            
        </div>
        <div class="body">
			<h1>S&eacute;lection d'&eacute;critures</h1>
            <g:if test="${ecritureDossierList.empty}">
				<i>Aucune &eacute;criture &agrave; s&eacute;lectionner</i>
            </g:if>
            <g:else>
			<g:form accept-charset="UTF-8" controller="ecritureDossier" method="post" >
			<input type="hidden" name="encoursSize" value="${ecritureDossierList.size()}" />
			<div class="buttons" style="text-align:right;padding-right:10px">
				<span class="button">
				<a href="#" class="button" onclick="selectall(true)">S&eacute;lectionner Tout</a>&nbsp;|&nbsp;
				<a href="#" class="button" onclick="selectall(false)">Aucune S&eacute;lection</a>&nbsp;|&nbsp;
				<g:actionSubmit class="validate" action="doSelect" value="Marquer la s&eacute;lection" /></span>
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
                   	        <g:sortableColumn property="moyenPaiement" title="M.P" />

							<g:sortableColumn property="typeEcriture" title="Libell&eacute;" />
		
                   	        <g:sortableColumn property="dossier" title="Dossier" />
                   	    
                   	        <g:sortableColumn property="montant" title="Montant" />
                        
                   	        <g:sortableColumn property="dateValeur" title="Date D&eacute;p&ocirc;t" />
                        
                   	        <g:sortableColumn property="dateMouvement" title="Date Encaissement" />
                        
                   	        <g:sortableColumn property="pieceComptable" title="Pi&egrave;ce Comptable" />
                   	    
                   	        <th></th>
                        </tr>
                    </thead>
					<g:set var="dat" value="${new java.text.SimpleDateFormat('dd/MM/yyyy')}" />
                    <tbody>
                    <g:each in="${ecritureDossierList}" status="i" var="ecritureDossier">
                        <tr class="${ecritureDossier.typeEcriture?.categorieEcriture?.id==1?'frais':'prix'}${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td class="icon"><span class="${etude.mpIcon(mp:ecritureDossier.moyenPaiement)}">&nbsp;</span><span class="noshow">${ecritureDossier.moyenPaiement}</span></td>
                        
							<td><g:link action="edit" id="${ecritureDossier.id}">${ecritureDossier.typeEcriture?.encodeAsHTML()}</g:link><g:if test="${ecritureDossier.commentaire}"><br/><span class="tip">${ecritureDossier.commentaire.encodeAsHTML()}</span></g:if></td>
                        
                            <td><etude:linkDossier dossier="${ecritureDossier.dossier}"/></td>
                        
                            <td class="moneyCell"><g:formatNumber number="${ecritureDossier.montant}" format="###,##0.00 DH" /></td>
                        
							<td class="dateCell"><etude:relativeDate sentence="true" date="${ecritureDossier.dateValeur}"/></td>
						
							<td class="dateCell"><etude:relativeDate sentence="true" date="${ecritureDossier.dateMouvement}"/></td>
                        
							<td class="icon" title="${ecritureDossier.etat}"><span class="${etude.etatIcon(etat:ecritureDossier.etat)}">&nbsp;</span><span class="noshow">${ecritureDossier.etat}</span></td>

                   	        <td class="checkfix">
								<input type="hidden" name="id${i}" value="${ecritureDossier?.id}" />
								<g:checkBox name="check${i}" value="${ecritureDossier?.marked}"/>
							</td>

                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${count}" />
            </div>
			</g:form>
        </g:else>
        </div>
    </body>
</html>
