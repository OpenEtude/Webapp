

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><g:message code="domain.Traduction" default="Traduction" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="house" href="${createLinkTo(dir:'')}"><g:message code="home" default="Acceuil" /></a></span>
            <span class="menuButton"><g:link action="list"><g:message code="domain.Traduction.list" default="Liste des Traductions" /><span class="database_table ico"></span></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="domain.Traduction" default="Traduction" /></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">${traduction.description}:</td>
                            
                            <td valign="top" class="value">${traduction.trad}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${traduction?.id}" />
                    <span class="button"><g:actionSubmit action="edit" value="${message(code:'edit', 'default':'Edit')}" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
