  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier MoyenPaiement</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste MoyenPaiement</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau MoyenPaiement</g:link></span>
        </div>
        <div class="body">
            <h1>Modifier MoyenPaiement</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${moyenPaiement}">
            <div class="errors">
                <g:renderErrors bean="${moyenPaiement}" as="list" />
            </div>
            </g:hasErrors>
            <g:form controller="moyenPaiement" method="post" >
                <input type="hidden" name="id" value="${moyenPaiement?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='libelle'>Libelle:</label></td><td valign='top' class='value ${hasErrors(bean:moyenPaiement,field:'libelle','errors')}'><input type="text" id='libelle' name='libelle' value="${moyenPaiement?.libelle?.encodeAsHTML()}"/></td></tr>
                        
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
