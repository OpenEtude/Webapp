  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Saisie Dossier</title>         
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste Dossier</g:link></span>
        </div>
        <div class="body">
            <h1>Create Dossier</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${dossier}">
            <div class="errors">
                <g:renderErrors bean="${dossier}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='libelle'>Libelle:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'libelle','errors')}'><input type="text" id='libelle' name='libelle' value="${dossier?.libelle?.encodeAsHTML()}"/></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='description'>Description:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'description','errors')}'><input type="text" id='description' name='description' value="${dossier?.description?.encodeAsHTML()}"/></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='dateCreation'>Date Creation:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'dateCreation','errors')}'><g:datePicker precision="day" name='dateCreation' value="${dossier?.dateCreation}" precision ="day"></g:datePicker></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='dateCloture'>Date Cloture:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'dateCloture','errors')}'><g:datePicker precision="day" name='dateCloture' value="${dossier?.dateCloture}" noSelection="['':'']" precision="day"></g:datePicker></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='compteAttachement'>Compte Attachement:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'compteAttachement','errors')}'><g:select optionKey="id" from="${Compte.list()}" name='compteAttachement.id' value="${dossier?.compteAttachement?.id}" noSelection="['':'']"></g:select></td></tr>
                        
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
