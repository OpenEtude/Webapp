

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier <etude:traduction name="Client"/></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Clients</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span><g:message code="domain.Client.new" default="Nouveau Client" /></g:link></span>
        </div>
        <div class="body">
            <h1>Modifier <etude:traduction name="Client"/></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${client}">
            <div class="errors">
                <g:renderErrors bean="${client}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${client?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="civilite"><etude:traduction name="civilite" default="Civilite" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'civilite','errors')}">
                                    <g:select optionKey="id" from="${Civilite.list()}" name="civilite.id" value="${client?.civilite?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="nom"><etude:traduction name="nom" default="Nom" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'nom','errors')}">
                                    <input type="text" id="nom" name="nom" value="${fieldValue(bean:client,field:'nom')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="numIdentite"><etude:traduction name="numIdentite" default="Num Identite" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'numIdentite','errors')}">
                                    <input type="text" id="numIdentite" name="numIdentite" value="${fieldValue(bean:client,field:'numIdentite')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="pieceIdentite"><etude:traduction name="pieceIdentite" default="Piece Identite" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'pieceIdentite','errors')}">
                                    <g:select optionKey="id" from="${PieceIdentite.list()}" name="pieceIdentite.id" value="${client?.pieceIdentite?.id}" noSelection="['null':'']"></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="addresse1"><etude:traduction name="addresse1" default="Addresse1" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'addresse1','errors')}">
                                    <input type="text" id="addresse1" name="addresse1" value="${fieldValue(bean:client,field:'addresse1')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="addresse2"><etude:traduction name="addresse2" default="Addresse2" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'addresse2','errors')}">
                                    <input type="text" id="addresse2" name="addresse2" value="${fieldValue(bean:client,field:'addresse2')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="ville"><etude:traduction name="ville" default="Ville" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'ville','errors')}">
                                    <input type="text" id="ville" name="ville" value="${fieldValue(bean:client,field:'ville')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="commentaire"><etude:traduction name="commentaire" default="Commentaire" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'commentaire','errors')}">
                                    <input type="text" id="commentaire" name="commentaire" value="${fieldValue(bean:client,field:'commentaire')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="telephone"><etude:traduction name="telephone" default="Telephone" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'telephone','errors')}">
                                    <input type="text" id="telephone" name="telephone" value="${fieldValue(bean:client,field:'telephone')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="mobile"><etude:traduction name="mobile" default="Mobile" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'mobile','errors')}">
                                    <input type="text" id="mobile" name="mobile" value="${fieldValue(bean:client,field:'mobile')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="fax"><etude:traduction name="fax" default="Fax" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'fax','errors')}">
                                    <input type="text" id="fax" name="fax" value="${fieldValue(bean:client,field:'fax')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="email"><etude:traduction name="email" default="Email" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'email','errors')}">
                                    <input type="text" id="email" name="email" value="${fieldValue(bean:client,field:'email')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="operations"><etude:traduction name="operations" default="Operations" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'operations','errors')}">
                                    
<ul>
<g:each var="o" in="${client?.operations?}">
    <li><g:link controller="operation" action="show" id="${o.id}">${o}</g:link></li>
</g:each>
</ul>
<g:link controller="operation" params="["client.id":client?.id]" action="create">Add Operation</g:link>

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
