  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Affichage Dossier</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste Dossier</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau Dossier</g:link></span>
        </div>
        <div class="body">
            <h1>Show Dossier</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${dossier.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Libelle:</td>
                            
                            <td valign="top" class="value">${dossier.libelle}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Description:</td>
                            
                            <td valign="top" class="value">${dossier.description}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Date Creation:</td>
                            
                            <td valign="top" class="value">${dossier.dateCreation}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Clients:</td>
                            
                            <td valign="top" class="value">${dossier.clients}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Liste Frais:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="l" in="${dossier.listeFrais}">
                                    <li><g:link controller="frais" action="show" id="${l.id}">${l}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Liste Prix:</td>
								
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="l" in="${dossier.listePrix}">
                                    <li><g:link controller="prix" action="show" id="${l.id}">${l}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form accept-charset="UTF-8"   controller="dossier">
                    <input type="hidden" name="id" value="${dossier?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" action="delete" value="Supprimer" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
