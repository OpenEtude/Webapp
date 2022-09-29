  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier TypeEcritureGroupementRel</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste TypeEcritureGroupementRel</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau TypeEcritureGroupementRel</g:link></span>
        </div>
        <div class="body">
            <h1>Modifier TypeEcritureGroupementRel</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${typeEcritureGroupementRel}">
            <div class="errors">
                <g:renderErrors bean="${typeEcritureGroupementRel}" as="list" />
            </div>
            </g:hasErrors>
            <g:form controller="typeEcritureGroupementRel" method="post" >
                <input type="hidden" name="id" value="${typeEcritureGroupementRel?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
				            <g:select optionKey="id" from="${Groupement.list()}" name='groupement.id' value="${typeEcritureGroupementRel?.groupement?.id}" ></g:select>
                        
				            <g:select optionKey="id" from="${TypeEcriture.list()}" name='typeEcriture.id' value="${typeEcritureGroupementRel?.typeEcriture?.id}" ></g:select>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit action="update" value="Enregistrer" /></span>
                    <span class="button"><g:actionSubmit class="danger" action="delete" value="Supprimer" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
