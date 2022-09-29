<html>
    <head>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Libell&eacute; (${typeEcriture?.categorieEcriture?.encodeAsHTML()})</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste des Libell&eacute;s</g:link></span>
            <span class="menuButton"><g:link action="createAutre"><span class="database_add ico"></span>Nouveau Libell&eacute;</g:link></span>
            <span class="menuButton"><g:link action="createFrais"><span class="database_add ico"></span>Nouveau Libell&eacute; Frais</g:link></span>
            <span class="menuButton"><g:link action="createPrix"><span class="database_add ico"></span>Nouveau Libell&eacute; Prix</g:link></span>
        </div>
        <div class="body">
            <h1>Libell&eacute; (${typeEcriture?.categorieEcriture?.encodeAsHTML()})</h1>
            <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Libell&eacute;:</td>
                            
                            <td valign="top" class="value">${typeEcriture.libelle}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Type:</td>
                            
                            <td valign="top" class="value">${typeEcriture.credit?'Cr&eacute;dit':'D&eacute;bit'}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Affectable &agrave; Compte Bancaire:</td>
                            
                            <td valign="top" class="value">${typeEcriture.affectable?'Oui':'Non'}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Affich&eacute;e dans les op&eacute;rations:</td>
                            
                            <td valign="top" class="value">${g.message(code:'typeEcriture.afficheDansOperation.'+typeEcriture.afficheDansOperation)}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form accept-charset="UTF-8"   controller="typeEcriture">
                    <input type="hidden" name="id" value="${typeEcriture?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
					</g:form>
            </div>
        </div>
    </body>
</html>