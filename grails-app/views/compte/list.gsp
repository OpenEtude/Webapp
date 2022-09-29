

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'compte.label', default: 'Compte')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="house" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link action="create"><g:message code="default.new.label" args="[entityName]" /><span class="database_add ico"></span></g:link></span>
            <span class="menuButton"><g:link class="modal" modalwidth="400" action="standardize" title="Uniformiser les libell&eacute;s"><span class="database_edit ico"></span>Uniformiser les libell&eacute;s de comptes</g:link></span>
            <span class="menuButton"><g:link class="modal" modalwidth="700" action="upload" title="Importer le plan comptable"><span class="database_save ico"></span>Importer le plan comptable</g:link></span>
            <span class="menuButton"><g:link action="export" title="Exporter le plan comptable"><span class="xls ico"></span>Exporter le plan comptable</g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="code" title="${message(code: 'compte.code.label', default: 'Code')}" />
                        
                            <g:sortableColumn property="libelle" title="${message(code: 'compte.libelle.label', default: 'Libelle')}" />
                        
                            <th><g:message code="compte.compteDeRattachement.label" default="Compte De Rattachement" /></th>
                        
                            <g:sortableColumn property="description" title="${message(code: 'compte.description.label', default: 'Description')}" />
                        
                        </tr>
                    </thead>
                    <tbody class="scrollContent">
                    <g:each in="${compteInstanceList}" status="i" var="compteInstance">
                        <etude:tr class="${(i % 2) == 0 ? 'odd' : 'even'}" ctrl="compte" id="${compteInstance.id}" actionName="edit">
                        
                            <td>${fieldValue(bean: compteInstance, field: "code")}</td>
                        
                            <td>${fieldValue(bean: compteInstance, field: "libelle")}</td>
                        
                            <td>${fieldValue(bean: compteInstance, field: "compteDeRattachement")}</td>
                        
                            <td>${fieldValue(bean: compteInstance, field: "description")}</td>
                        
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
