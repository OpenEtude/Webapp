<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Nouveau ${params.modele ? 'Mod&egrave;le de ':''} Dossier</title>         
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste Dossier</g:link></span>
        </div>
        </g:if>
        <div class="body">
            <h1>Nouveau ${params.modele ? 'Mod&egrave;le de ':''} Dossier</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${dossier}">
            <div class="errors">
                <g:renderErrors bean="${dossier}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
							<g:if test="${!modeles?.empty}">
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="modele"><etude:traduction name="useModele" default="Utiliser le mod&egrave;le" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:dossier,field:'modele','errors')}">
								
                                   <g:select optionKey="id" from="${modeles}" name="modeleId" value="${dossier?.id}"  noSelection="['null':'']" optionValue="${{it.nomModele}}" onChange="${remoteFunction(controller: 'dossier', action: 'listeEcritures',method:'get', update: 'ecrituresDiv',on500:'ohno',onComplete:'new Effect.Appear(\'ecrituresDiv\', 30);Modalbox.resizeToContent();$(\'spinner\').hide();',params: '\'id=\' + this.options[this.selectedIndex].value')}"></g:select>
                                </td>
                            </tr> 
							</g:if>

                            <tr class='prop'><td valign='top' class='name'><label for='numeroDossier'>Num&eacute;ro Dossier:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'numeroDossier','errors')}'><input type="text" id='numeroDossier' name='numeroDossier' value="${dossier?.numeroDossier?.encodeAsHTML()}" size="10"/></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='libelle'>Libell&eacute;:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'libelle','errors')}'><input type="text" id='libelle' name='libelle' value="${dossier?.libelle?.encodeAsHTML()}" size="30"/></td></tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="operation"><etude:traduction name="operation" default="Operation" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:dossier,field:'operation','errors')}">
								
									<g:if test="${dossier?.operation?.id}">
										${dossier?.operation?.encodeAsHTML()}
										<input type="hidden" name="operation.id" value="${params.get('operation.id')}"/>
									</g:if>
									<g:else>
		                                    <g:select optionKey="id" from="${Operation.list()}" name="operation.id" value="${dossier?.operation?.id}"  noSelection="['null':'']"></g:select>
									</g:else>
								
                                </td>
                            </tr> 
                        
                            <tr class='prop'><td valign='top' class='name'><label for='description'>Description:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'description','errors')}'><textarea id='description' name='description'>${dossier?.description?.encodeAsHTML()}</textarea></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='dateCreation'>Date Creation:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'dateCreation','errors')}'><g:datePicker name='dateCreation' value="${dossier?.dateCreation}" precision ="day"></g:datePicker></td></tr>
                            <tr class='prop'><td valign='top' class='name'></td><td valign='top' class='value'><tags:editTags object="${dossier}" clazz="Dossier"/></td></tr>
							<tbody id="ecrituresDiv"></tbody>
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
