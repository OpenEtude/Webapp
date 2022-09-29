  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier CategorieEcriture</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste CategorieEcriture</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau CategorieEcriture</g:link></span>
        </div>
        <div class="body">
            <h1>Modifier CategorieEcriture</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${categorieEcriture}">
            <div class="errors">
                <g:renderErrors bean="${categorieEcriture}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   controller="categorieEcriture" method="post" >
                <input type="hidden" name="id" value="${categorieEcriture?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='libelle'>Libelle:</label></td><td valign='top' class='value ${hasErrors(bean:categorieEcriture,field:'libelle','errors')}'><input type="text" id='libelle' name='libelle' value="${categorieEcriture?.libelle?.encodeAsHTML()}"/></td></tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit value="Enregistrer" action="update"/></span>
                    <span class="button"><g:actionSubmit class="danger" action="delete" value="Supprimer" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
