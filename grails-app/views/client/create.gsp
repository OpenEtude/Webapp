

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Nouveau <etude:traduction name="Client"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Clients</g:link></span>
		</div>
		</g:if>
        <div class="body">
            <h1>Nouveau <etude:traduction name="Client"/></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${client}">
            <div class="errors">
                <g:renderErrors bean="${client}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
				<etude:tabPane id="create_client">
					<etude:tab code="description"/>
					<etude:tab code="identification"/>
					<etude:tab code="contact"/>
				</etude:tabPane>
				<etude:tabContent code="description">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="civilite"><etude:traduction name="civilite" default="Civilite" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'civilite','errors')}">
								
									<g:if test="${client?.civilite?.id}">
										${client?.civilite?.encodeAsHTML()}
										<input type="hidden" name="civilite.id" value="${params.get('civilite.id')}"/>
									</g:if>
									<g:else>
		                                    <g:select optionKey="id" from="${Civilite.list()}" name="civilite.id" value="${client?.civilite?.id}" noSelection="['null':'']"></g:select>
									</g:else>
								
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
                                    <label for="commentaire"><etude:traduction name="commentaire" default="Commentaire" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:client,field:'commentaire','errors')}">
								
		                                    <textarea type="text" id="commentaire" name="commentaire">${fieldValue(bean:client,field:'commentaire')}</textarea>
								
                                </td>
                            </tr> 
                        </tbody>
                    </table>
				</etude:tabContent>
				<etude:tabContent code="identification">
                    <table>
                        <tbody>
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
								
									<g:if test="${client?.pieceIdentite?.id}">
										${client?.pieceIdentite?.encodeAsHTML()}
										<input type="hidden" name="pieceIdentite.id" value="${params.get('pieceIdentite.id')}"/>
									</g:if>
									<g:else>
		                                    <g:select optionKey="id" from="${PieceIdentite.list()}" name="pieceIdentite.id" value="${client?.pieceIdentite?.id}" noSelection="['null':'']"></g:select>
									</g:else>
								
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
                        
                        
                        </tbody>
                    </table>
				</etude:tabContent>
				<etude:tabContent code="contact">
                    <table>
                        <tbody>
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
                        
                        </tbody>
                    </table>
				</etude:tabContent>
                </div>
                <div class="buttons">
                    <span class="button"><input type="submit" value="Enregistrer"></input></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
