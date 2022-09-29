

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier <etude:traduction name="TypeDeBien"/></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a href="${createLinkTo(dir:'')}"><span class="house"></span><g:message code="home" default="Acceuil" /></span><span class="menuButton"><g:link action="list"><span class="database_table ico"></span>TypeDeBiens</g:link></span>
            <span class="menuButton"><g:link action="create"><g:message code="domain.TypeDeBien.new" default="Nouveau TypeDeBien" /><span class="database_add ico"></span></g:link></span>
        </div>
        <div class="body">
            <h1>Modifier <etude:traduction name="TypeDeBien"/></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${typeDeBien}">
            <div class="errors">
                <g:renderErrors bean="${typeDeBien}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${typeDeBien?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="libelle"><etude:traduction name="libelle" default="Libelle" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:typeDeBien,field:'libelle','errors')}">
                                    <input type="text" id="libelle" name="libelle" value="${fieldValue(bean:typeDeBien,field:'libelle')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="champs"><etude:traduction name="champs" default="Champs" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:typeDeBien,field:'champs','errors')}">
                                    
<ul>
<g:each var="c" in="${typeDeBien?.champs?}">
    <li><g:link controller="champ" action="show" id="${c.id}">${c}</g:link></li>
</g:each>
</ul>
<g:link controller="champ" params="["typeDeBien.id":typeDeBien?.id]" action="create">Add Champ</g:link>

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
