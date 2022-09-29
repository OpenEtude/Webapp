

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier <etude:traduction name="Valeur"/></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a href="${createLinkTo(dir:'')}"><span class="house"></span><g:message code="home" default="Acceuil" /></span><span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Valeurs</g:link></span>
            <span class="menuButton"><g:link action="create"><g:message code="domain.Valeur.new" default="Nouveau Valeur" /><span class="database_add ico"></span></g:link></span>
        </div>
        <div class="body">
            <h1>Modifier <etude:traduction name="Valeur"/></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${valeur}">
            <div class="errors">
                <g:renderErrors bean="${valeur}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${valeur?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="contenu"><etude:traduction name="contenu" default="Contenu" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:valeur,field:'contenu','errors')}">
                                    <input type="text" id="contenu" name="contenu" value="${fieldValue(bean:valeur,field:'contenu')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="bien"><etude:traduction name="bien" default="Bien" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:valeur,field:'bien','errors')}">
                                    <g:select optionKey="id" from="${Bien.list()}" name="bien.id" value="${valeur?.bien?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="champ"><etude:traduction name="champ" default="Champ" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:valeur,field:'champ','errors')}">
                                    <g:select optionKey="id" from="${Champ.list()}" name="champ.id" value="${valeur?.champ?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit action="update" value="Enregistrer" /></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
