  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier Ecriture</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste des Ecritures</g:link></span>
        </div>
        <div class="body">
            <h1><jsec:hasRole name="Maitre">${ecritureDossier.marked ? "(*) ":""}</jsec:hasRole>Modifier Ecriture</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${ecritureDossier}">
            <div class="errors">
                <g:renderErrors bean="${ecritureDossier}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   controller="ecriture" method="post" >
                <input type="hidden" name="id" value="${ecritureDossier?.id}" />
            <g:if test="${params.from}">
                <input type="hidden" name="from" value="${params.from}" />
            </g:if>
                <div class="dialog">
                    <table>
                        <tbody>
                        
                        <g:set var="remoteParams" value="'id='+this.options[this.selectedIndex].value+\'&ecriture.id=${ecritureDossier.id}\'"/>
				            <tr class='prop'><td valign='top' class='name'><label for='typeEcriture'>Libell&eacute;:</label></td><td valign='top' class='value ${hasErrors(bean:ecritureDossier,field:'typeEcriture','errors')}'><g:select optionKey="id" from="${TypeEcriture.executeQuery('from TypeEcriture te where te.categorieEcriture.id=3')}" name='typeEcriture.id' value="${ecritureDossier?.typeEcriture?.id}"   onChange="${remoteFunction(controller: 'typeEcriture', action: 'checkLibelle',method:'get', update: 'compteBancairesDiv',on500:'ohno',onComplete:'new Effect.Appear(\'ecrituresDiv\', 30);Modalbox.resizeToContent();$(\'spinner\').hide();',params:remoteParams)}"></g:select></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='montant'>Montant:</label></td><td valign='top' class='value ${hasErrors(bean:ecritureDossier,field:'montant','errors')}'><input type='text' id='montant' name='montant' value="${g.formatNumber(number:ecritureDossier?.montant,format:'###,##0.00')}"  title="Format de saisie : ${g.formatNumber(number:123456.78f,format:'###,##0.00')}"/></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='dateValeur'>Date D&eacute;p&ocirc;t:</label></td><td valign='top' class='value ${hasErrors(bean:ecritureDossier,field:'dateValeur','errors')}'><g:datePicker name='dateValeur' value="${ecritureDossier?.dateValeur}" precision ="day"></g:datePicker></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='dateMouvement'>Date Encaissement:</label></td><td valign='top' class='value ${hasErrors(bean:ecritureDossier,field:'dateMouvement','errors')}'><g:datePicker name='dateMouvement' value="${ecritureDossier?.dateMouvement}" noSelection="['':'']" precision ="day"></g:datePicker></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='etat'>Etat:</label></td><td valign='top' class='value ${hasErrors(bean:ecritureDossier,field:'etat','errors')}'><g:select optionKey="id" from="${EtatEcriture.list()}" name='etat.id' value="${ecritureDossier?.etat?.id}" ></g:select></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='commentaire'>Commentaire:</label></td><td valign='top' class='value ${hasErrors(bean:ecritureDossier,field:'commentaire','errors')}'><textarea id='commentaire' name='commentaire'>${ecritureDossier?.commentaire?.encodeAsHTML()}</textarea></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='moyenPaiement'>Mode de paiement:</label></td><td valign='top' class='value ${hasErrors(bean:ecritureDossier,field:'moyenPaiement','errors')}'><g:select optionKey="id" from="${MoyenPaiement.list()}" name='moyenPaiement.id' value="${ecritureDossier?.moyenPaiement?.id}" ></g:select></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='pieceComptable'>Piece Comptable:</label></td><td valign='top' class='value ${hasErrors(bean:ecritureDossier,field:'pieceComptable','errors')}'><input type="text" id='pieceComptable' name='pieceComptable' value="${ecritureDossier?.pieceComptable?.encodeAsHTML()}"/></td></tr>
                        
            <jsec:hasPermission type="EtudePerm" target="CompteBancaire" actions="Consultation">
							<tbody id="compteBancairesDiv">
            <g:if test="${ecritureDossier?.typeEcriture?.affectable}">
				            <tr class='prop'><td valign='top' class='name'><label for='compteBancaire'>Compte Bancaire:</label></td><td valign='top' class='value ${hasErrors(bean:ecritureDossier,field:'typeEcriture','errors')}'><g:select optionKey="id" from="${lovCompte}" name='compteBancaire.id' noSelection="['null':'']" value="${ecritureDossier?.compteBancaire?.id}" ></g:select></td></tr>
            </g:if></tbody>
			</jsec:hasPermission>
							</td></tr>
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit value="Enregistrer" action="update"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
