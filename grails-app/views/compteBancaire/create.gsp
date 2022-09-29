

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><g:message code="compteBancaire.create" default="Nouveau Compte Bancaire" /></title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="synthese"><span class="database_table ico"></span>Comptes Bancaires</g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="domain.CompteBancaire.create" default="Nouveau Compte Bancaire" /></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${compteBancaire}">
            <div class="errors">
                <g:renderErrors bean="${compteBancaire}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
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
                                    <label for="soldeInitial"><g:message code="compteBancaire.soldeInitial" default="Solde initial" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:compteBancaire,field:'soldeInitial','errors')}">
                                    <input type="text" id="soldeInitial" name="soldeInitial" value="${fieldValue(bean:compteBancaire,field:'libelle')}"/>
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dateCreation"><g:message code="compteBancaire.dateCreation" default="Date Creation" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:compteBancaire,field:'dateCreation','errors')}">
                                    <g:datePicker name="dateCreation" value="${compteBancaire?.dateCreation}"  noSelection="['null':'']" precision ="day"></g:datePicker>
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
                    <span class="button"><input type="submit" value="Enregistrer"></input></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
