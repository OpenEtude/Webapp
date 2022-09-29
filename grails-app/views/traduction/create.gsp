

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><g:message code="traduction.create" default="${message(code:className+'.new', 'default':'Nouveau '+className)}" /></title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><g:message code="traduction.list" default="Liste " /><span class="database_table ico"></span></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="domain.Traduction.create" default="Nouveau Traduction" /></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${traduction}">
            <div class="errors">
                <g:renderErrors bean="${traduction}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="traduction.name" default="Name" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:traduction,field:'name','errors')}">
                                    <input type="text" id="name" name="name" value="${fieldValue(bean:traduction,field:'name')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="traduction.description" default="Description" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:traduction,field:'description','errors')}">
                                    <input type="text" id="description" name="description" value="${fieldValue(bean:traduction,field:'description')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="trad"><g:message code="traduction.trad" default="Trad" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:traduction,field:'trad','errors')}">
                                    <input type="text" id="trad" name="trad" value="${fieldValue(bean:traduction,field:'trad')}"/>
                                </td>
                            </tr> 
                        
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
