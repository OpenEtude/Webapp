  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Recherche Ecritures</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
        </div>
         </g:if>
<jsec:hasPermission type="EtudePerm" target="Ecriture" actions="RapportDetail">
		<div class="searchbox">
<g:form border="0" url='[controller: "ecriture", action: "simpleSearch"]'   id="ecritureSearch" name="ecritureSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
			<etude:keyword name="q" accesskey="s" id="keybox" value="${params.q}" hint="${'Montant, Piece ou Commentaire'.encodeAsJavaScript()}"/>
</g:form>
		</div>
</jsec:hasPermission>
        <div class="body">
            <h1>Recherche Ecritures</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <g:form accept-charset="UTF-8"   controller="ecriture" method="get" >
                <div class="dialog">
                    <table>
                        <tbody>
				            <tr class='prop'><td valign='top' class='name'><label for='libelle'>Libell&eacute;:</label></td><td valign='top' class='value'><g:select optionKey="id" from="${lovTypeEcriture}" name='typeEcriture.id' value="${typeEcriture?.id}"  noSelection="['null':'Tous']"></g:select></td></tr>

							<g:set var="extensions" value="${[['ext':'html','name':'Page Web'], ['ext':'xls','name':'Excel']]}"/>
				            <tr class='prop'><td valign='top' class='name'><label for='montant'>Montant:</label></td><td valign='top' class='value'><input type="text" id='montant' name='montant'/></td></tr>

				            <tr class='prop'><td valign='top' class='name'><label for='pieceComptable'>Pi&egrave;ce Comptable:</label></td><td valign='top' class='value'><input type="text" id='pieceComptable' name='pieceComptable'/></td></tr>
                                                
				            <tr class='prop'><td valign='top' class='name'><label for='etat'>Etat:</label></td><td valign='top' class='value'><g:select optionKey="id" from="${lovEtat}" name='etat.id' value="${etatEcriture?.id}"  noSelection="['null':'Tous']"></g:select></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='compteBancaire'>Compte Bancaire:</label></td><td valign='top' class='value'><g:select optionKey="id" from="${lovCompteBancaire}" name='compteBancaire.id' value="${compteBancaire?.id}"  noSelection="['null':'Tous']"></g:select></td></tr>

				            <tr class='prop'><td valign='top' class='name'><label for='debut'>D&eacute;but:</label></td><td valign='top' class='value'><g:datePicker name='debut' value="${debut}" precision="day"></g:datePicker></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='fin'>Fin:</label></td><td valign='top' class='value'><g:datePicker name='fin' value="${fin}" precision="day"></g:datePicker></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='groupement'>Afficher le r&eacute;sultat dans :</label></td><td valign='top' class='value'><g:select name="format" from="${['html', 'xls']}" valueMessagePrefix="result.format" /></td></tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit value="Rechercher" action="results"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
