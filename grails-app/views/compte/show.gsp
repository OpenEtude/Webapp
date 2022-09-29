

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'compte.label', default: 'Compte')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="house" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link action="list"><g:message code="default.list.label" args="[entityName]" /><span class="database_table ico"></span></g:link></span>
            <span class="menuButton"><g:link action="create"><g:message code="default.new.label" args="[entityName]" /><span class="database_add ico"></span></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.show.label" args="[compteInstance]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compte.code.label" default="Code" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: compteInstance, field: "code")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compte.libelle.label" default="Libelle" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: compteInstance, field: "libelle")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compte.compteDeRattachement.label" default="Compte De Rattachement" /></td>
                            
                            <td valign="top" class="value"><g:link controller="compte" action="show" id="${compteInstance?.compteDeRattachement?.id}">${compteInstance?.compteDeRattachement?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compte.description.label" default="Description" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: compteInstance, field: "description")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compte.comptes.label" default="Comptes" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${compteInstance.comptes}" var="c">
                                    <li><g:link controller="compte" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                   
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${compteInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete danger" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
