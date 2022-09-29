

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier <g:message code="domain.Traduction"/></title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list">Liste des <g:message code="Traduction"/><span class="database_table ico"></span>s</g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="traduction.edit" default="Modifier Traduction" /></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${traduction}">
            <div class="errors">
                <g:renderErrors bean="${traduction}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${traduction?.id}" />
                <input type="hidden" name="name" value="${traduction?.name}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="trad">${traduction?.description}:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:traduction,field:'trad','errors')}">
                                    <input type="text" id="trad" name="trad" value="${fieldValue(bean:traduction,field:'trad')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit action="update" value="${message(code:'update', 'default':'Update')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
