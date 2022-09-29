  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>TypeEcritureGroupementRel : </title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste TypeEcritureGroupementRel</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau TypeEcriture Groupement Rel</g:link></span>
        </div>
        <div class="body">
            <h1>TypeEcritureGroupementRel : </h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${typeEcritureGroupementRel.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Groupement:</td>
                            
                            <td valign="top" class="value"><g:link controller="groupement" action="show" id="${typeEcritureGroupementRel?.groupement?.id}">${typeEcritureGroupementRel?.groupement}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Libell&eacute;:</td>
                            
                            <td valign="top" class="value"><g:link controller="typeEcriture" action="show" id="${typeEcritureGroupementRel?.typeEcriture?.id}">${typeEcritureGroupementRel?.typeEcriture}</g:link></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form controller="typeEcritureGroupementRel">
                    <input type="hidden" name="id" value="${typeEcritureGroupementRel?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" action="delete" value="Supprimer" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
