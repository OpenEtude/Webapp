  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Affichage CategorieEcriture</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste CategorieEcriture</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau CategorieEcriture</g:link></span>
        </div>
        <div class="body">
            <h1>Affichage CategorieEcriture</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${categorieEcriture.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Libelle:</td>
                            
                            <td valign="top" class="value">${categorieEcriture.libelle}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form accept-charset="UTF-8"   controller="categorieEcriture">
                    <input type="hidden" name="id" value="${categorieEcriture?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" action="delete" value="Supprimer" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
