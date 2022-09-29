


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'compte.label', default: 'Compte')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="house" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link action="list"><g:message code="default.list.label" args="[entityName]" /><span class="database_table ico"></span></g:link></span>
            <span class="menuButton"><g:link action="create"><g:message code="default.new.label" args="[entityName]" /><span class="database_add ico"></span></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[compteInstance]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${compteInstance}">
            <div class="errors">
                <g:renderErrors bean="${compteInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${compteInstance?.id}" />
                <g:hiddenField name="version" value="${compteInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="code"><g:message code="compte.code.label" default="Code" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: compteInstance, field: 'code', 'errors')}">
                                    <g:textField name="code" value="${compteInstance?.code}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="libelle"><g:message code="compte.libelle.label" default="Libelle" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: compteInstance, field: 'libelle', 'errors')}">
                                    <g:textField name="libelle" value="${compteInstance?.libelle}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="compteDeRattachement"><g:message code="compte.compteDeRattachement.label" default="Compte De Rattachement" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: compteInstance, field: 'compteDeRattachement', 'errors')}">
                                    <g:select name="compteDeRattachement.id" from="${Compte.list()}" optionKey="id" value="${compteInstance?.compteDeRattachement?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="description"><g:message code="compte.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: compteInstance, field: 'description', 'errors')}">
                                    <g:textField name="description" value="${compteInstance?.description}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="comptes"><g:message code="compte.comptes.label" default="Comptes" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: compteInstance, field: 'comptes', 'errors')}">
                                    
<ul>
<g:each in="${compteInstance?.comptes?}" var="c">
    <li><g:link controller="compte" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="compte" action="create" params="['compteDeRattachement.id': compteInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'compte.label', default: 'Compte')])}</g:link>

                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete danger" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
