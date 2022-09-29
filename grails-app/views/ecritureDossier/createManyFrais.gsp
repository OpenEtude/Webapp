<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Saisies de frais de dossier</title>         
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste des Ecritures de Dossier</g:link></span>
        </div>
        </g:if>
        <div class="body">
            <h1>Saisies de frais de dossier </h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${ecritureDossier}">
            <div class="errors">
                <g:renderErrors bean="${ecritureDossier}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   action="saveMany" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                            <tr>
							<td valign='top'><label for='pieceComptable'>Piece Comptable:</label></td><td valign='top'  class='value ${hasErrors(bean:ecritureDossier,field:'pieceComptable','errors')}'><input type="text" id='pieceComptable' name='pieceComptable' value="${ecritureDossier?.pieceComptable?.encodeAsHTML()}" size='35'/>
								<input type="hidden" name="dossier.id" value="${params.get('dossier.id')}"/>
								<input type="hidden" name="fraisSize" value="${manyFrais.size()}"/>
							</td>
							<td valign='top'><label for='typeEcriture'>Moyen de paiement:</label></td>
							<td valign='top'><g:select optionKey="id" from="${MoyenPaiement.list()}" name='moyenPaiement.id' value="${ecritureDossier?.moyenPaiement?.id}" ></g:select></td></tr>
							<tr>
							<td valign='top'><label for='etat'>Etat:</label></td>
							<td valign='top'><g:select optionKey="id" from="${EtatEcriture.list()}" name='etat.id' value="${ecritureDossier?.etat?.id}" ></g:select></td>
							<td><label for='compteBancaire' >Compte Bancaire:</label></td>
							<td valign='top' ><g:select optionKey="id" from="${lovCompteBancaire}" name='compteBancaire.id' value="${ecritureDossier?.compteBancaire?.id}" noSelection="['null':'']"></g:select></td>
							</tr>
                            <tr>
							<td valign='top' ><label for='dateValeur'>Date D&eacute;p&ocirc;t:</label></td>
							<td valign='top' ><g:datePicker name='dateValeur' value="${ecritureDossier?.dateValeur}" precision ="day"></g:datePicker>
							</td>
							<td valign='top' ><label for='dateMouvement'>Date Encaissement:</label></td>
							<td valign='top' ><g:datePicker name='dateMouvement' value="${ecritureDossier?.dateMouvement}" noSelection="['null':'']" precision ="day"></g:datePicker></td>
							</tr>
                            <tr>
							<td valign='top'><label for='acte'>Acte:</label></td>
							<td valign='top' colspan="3" class='value ${hasErrors(bean:ecritureDossier,field:'acte','errors')}' ><g:select optionKey="id" from="${lovActe}" name='acte.id' value="${ecritureDossier?.acte?.id}" noSelection="['null':'']"></g:select></td>
							</tr>
                        </tbody>
                    </table>
                    <table style="margin-bottom:30px">
                        <tbody>
                        
<g:each in="${manyFrais}" status="i" var="ecritureDossier">
                            <tr><td valign='top'><g:select optionKey="id" from="${listeFrais}" name='typeEcriture.id${i}' value="${ecritureDossier?.typeEcriture?.id}"  noSelection="['null':'']></g:select></td>
							<td valign='top' class='value ${hasErrors(bean:ecritureDossier,field:'montant','errors')}'><input type='text' id='montant${i}' name='montant${i}' value="${ecritureDossier?.montant}" size='10'  title="Format de saisie : ${g.formatNumber(number:123456.78f,format:'###,##0.00')}"/><span> DH</span></td>
							<td valign='top'><label for='commentaire'>Commentaire:</label></td><td valign='top' class='value ${hasErrors(bean:ecritureDossier,field:'commentaire','errors')}'><input type="text" id='commentaire${i}' name='commentaire${i}' size='20' value="${ecritureDossier?.commentaire?.encodeAsHTML()}"/></td>
							</tr>
</g:each>                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input type="submit" value="Enregistrer"></input></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
