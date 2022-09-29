  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Ecriture</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste des Ecritures de Dossier</g:link></span>
                        <span class="menuButton"><g:link controller='ecritureDossier' params='["type":"frais", "dossier.id":ecritureDossier?.dossier?.id]' action='create'><span class="database_add ico"></span>Ajout Frais</g:link></span>
                        <span class="menuButton"><g:link controller='ecritureDossier' params='["dossier.id":ecritureDossier?.dossier?.id]' action='createManyFrais'><span class="database_add ico"></span>Ajout Frais Group&eacute;s</g:link></span>&nbsp;|&nbsp;
                        <span class="menuButton"><g:link controller='ecritureDossier' params='["type":"prix", "dossier.id":ecritureDossier?.dossier?.id]' action='create'><span class="database_add ico"></span>Ajout Prix</g:link></span>
						<jsec:hasRole name="Maitre">&nbsp;|&nbsp;<span class="menuButton"><g:link controller="activity" action="history" params="['controller.id':Activity.ECRITURE_DOSSIER, 'entity.id':ecritureDossier?.id, 'titre':ecritureDossier.toString()]"><span class="database_table ico"></span>Historique</g:link></span></jsec:hasRole>
        </div>
<jsec:hasPermission type="EtudePerm" target="Ecriture" actions="RapportDetail">
		<div class="searchbox">
<g:form border="0" url='[controller: "ecriture", action: "simpleSearch"]'   id="ecritureSearch" name="ecritureSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
			<etude:keyword name="q" accesskey="s" id="keybox" value="${params.q}" hint="${'Montant, Piece ou Commentaire'.encodeAsJavaScript()}"/>
</g:form>
		</div>
</jsec:hasPermission>
            </g:if>
        <div class="body">
            <h1><jsec:hasRole name="Maitre">${ecritureDossier.marked ? "(*) ":""}</jsec:hasRole>Ecriture de dossier</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                        <!--(tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${ecritureDossier.id}</td>
                            
                        </tr -->
                    
                        <tr class="prop">
                            <td valign="top" class="name">Dossier:</td>
                            
                            <td valign="top" class="value"><etude:linkDossier dossier="${ecritureDossier.dossier}"/></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Libell&eacute;:</td>
                            
                            <td valign="top" class="value"><g:link controller="typeEcriture" action="show" id="${ecritureDossier?.typeEcriture?.id}">${ecritureDossier?.typeEcriture}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Montant:</td>
                            
                            <td valign="top" class="value"><g:formatNumber number="${ecritureDossier.montant}" format="###,##0.00 DH" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Date D&eacute;p&ocirc;t:</td>
                            
                            <td valign="top" class="value"><etude:relativeDate sentence="true" date="${ecritureDossier.dateValeur}"/></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Date Encaissement:</td>
                            
                            <td valign="top" class="value"><etude:relativeDate sentence="true" date="${ecritureDossier.dateMouvement}"/></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Etat:</td>
                            
                            <td valign="top" class="value">${ecritureDossier?.etat}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Commentaire:</td>
                            
                            <td valign="top" class="value">${ecritureDossier.commentaire?.encodeAsHTML()}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Mode de Paiement:</td>
                            
                            <td valign="top" class="value">${ecritureDossier.moyenPaiement?.encodeAsHTML()}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Piece Comptable:</td>
                            
                            <td valign="top" class="value">${ecritureDossier.pieceComptable}</td>
                            
                        </tr>
                    
            <jsec:hasPermission type="EtudePerm" target="CompteBancaire" actions="Consultation">
            <g:if test="${ecritureDossier?.typeEcriture?.affectable}">
                        <tr class="prop">
                            <td valign="top" class="name">Compte Bancaire:</td>
                            <td valign="top" class="value"><g:link controller="compteBancaire" action="detail" id="${ecritureDossier?.compteBancaire?.id}">${ecritureDossier?.compteBancaire}</g:link></td>
                        </tr>
            </g:if>
			</jsec:hasPermission>
                        <tr class="prop">
                            <td valign="top" class="name">Acte:</td>
                            <td valign="top" class="value"><g:link controller="acte" action="show" id="${ecritureDossier?.acte?.id}">${ecritureDossier?.acte}</g:link></td>
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form accept-charset="UTF-8"   controller="ecritureDossier">
                    <input type="hidden" name="id" value="${ecritureDossier?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
