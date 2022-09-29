

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier <g:message code="domain.CompteBancaire"/></title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="synthese"><span class="database_table ico"></span>Comptes Bancaires</g:link></span>
            <span class="menuButton"><g:link action="create"><g:message code="domain.CompteBancaire.new" default="Nouveau Compte Bancaire" /><span class="database_add ico"></span></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="compteBancaire.edit" default="Modifier Compte Bancaire" /></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${compteBancaire}">
            <div class="errors">
                <g:renderErrors bean="${compteBancaire}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${compteBancaire?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="libelle"><g:message code="compteBancaire.libelle" default="Libelle" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:compteBancaire,field:'libelle','errors')}">
                                    <input type="text" id="libelle" name="libelle" value="${fieldValue(bean:compteBancaire,field:'libelle')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dateCreation"><g:message code="compteBancaire.dateCreation" default="Date Creation" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:compteBancaire,field:'dateCreation','errors')}">
                                    <g:datePicker name="dateCreation" value="${compteBancaire?.dateCreation}"  noSelection="['':'']" precision ="day"></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dateCloture"><g:message code="compteBancaire.dateCloture" default="Date Cloture" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:compteBancaire,field:'dateCloture','errors')}">
                                    <input type="text" id="dateCloture" name="dateCloture" title="Format dd/MM/yyyy" value="${g.formatDate(format:'dd/MM/yyyy', date:compteBancaire?.dateCloture)}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="agence"><g:message code="compteBancaire.agence" default="Agence" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:compteBancaire,field:'agence','errors')}">
                                    <input type="text" id="agence" name="agence" value="${fieldValue(bean:compteBancaire,field:'agence')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="rib"><g:message code="compteBancaire.rib" default="R.I.B" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:compteBancaire,field:'rib','errors')}">
                                    <input type="text" id="rib" name="rib" value="${fieldValue(bean:compteBancaire,field:'rib')}"/>
                                </td>
                            </tr> 

                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="telephone"><g:message code="compteBancaire.telephone" default="Telephone" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:compteBancaire,field:'telephone','errors')}">
                                    <input type="text" id="telephone" name="telephone" value="${fieldValue(bean:compteBancaire,field:'telephone')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="contact"><g:message code="compteBancaire.contact" default="Contact" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:compteBancaire,field:'contact','errors')}">
                                    <input type="text" id="contact" name="contact" value="${fieldValue(bean:compteBancaire,field:'contact')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="commentaire"><g:message code="compteBancaire.commentaire" default="Commentaire" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:compteBancaire,field:'commentaire','errors')}">
                                    <g:textArea id="commentaire" name="commentaire" value="${fieldValue(bean:compteBancaire,field:'commentaire')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit action="Update" value="${message(code:'update', 'default':'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="danger" action="Delete" value="${message(code:'delete', 'default':'Delete')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
