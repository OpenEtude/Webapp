  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Saisie TypeEcritureGroupementRel</title>         
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste TypeEcritureGroupementRel</g:link></span>
        </div>
        <div class="body">
            <h1>Nouveau TypeEcritureGroupementRel</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${typeEcritureGroupementRel}">
            <div class="errors">
                <g:renderErrors bean="${typeEcritureGroupementRel}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <g:select optionKey="id" from="${Groupement.list()}" name='groupement.id' value="${typeEcritureGroupementRel?.groupement?.id}" ></g:select>
                        
                            <g:select optionKey="id" from="${TypeEcriture.list()}" name='typeEcriture.id' value="${typeEcritureGroupementRel?.typeEcriture?.id}" ></g:select>
                        
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
