  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier Dossier</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste Dossier</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau Dossier</g:link></span>
        </div>
		</g:if>
        <div class="body">
			<g:if test="${!params.modele}">
            <h1>Modifier Dossier</h1>
            </g:if>
			<g:else>
            <h1>Mod&egrave;le de Dossier</h1>
			</g:else>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${dossier}">
            <div class="errors">
                <g:renderErrors bean="${dossier}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   controller="dossier" method="post" >
                <input type="hidden" name="id" value="${dossier?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
									<g:if test="${!params.modele}">
                            <tr class='prop'><td valign='top' class='name'><label for='numeroDossier'>Num&eacute;ro Dossier:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'numeroDossier','errors')}'><input type="text" id='numeroDossier' name='numeroDossier' value="${dossier?.numeroDossier?.encodeAsHTML()}" size="10"/></td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='libelle'>Libell&eacute;:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'libelle','errors')}'><input type="text" id='libelle' name='libelle' value="${dossier?.libelle?.encodeAsHTML()}" size="30"/></td></tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="operation"><etude:traduction name="operation" default="Operation" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:dossier,field:'operation','errors')}">
								
									<g:if test="${dossier?.operation?.id || params.get('operation.id')}">
										${dossier?.operation?.encodeAsHTML()}
										<input type="hidden" name="operation.id" value="${dossier?.operation?.id ?: params.get('operation.id')}"/>
									</g:if>
									<g:else>
		                                    <g:select optionKey="id" from="${Operation.list()}" name="operation.id" value="${dossier?.operation?.id}"  noSelection="['null':'']"></g:select>
									</g:else>
								
                                </td>
                            </tr> 

                            <tr class='prop'><td valign='top' class='name'><label for='description'>Description:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'description','errors')}'><g:textArea name='description' value="${dossier?.description?.encodeAsHTML()}"/></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='dateCreation'>Date Creation:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'dateCreation','errors')}'><g:datePicker name='dateCreation' value="${dossier?.dateCreation}" precision ="day"></g:datePicker></td></tr>
                            <tr class='prop'><td valign='top' class='name'></td><td valign='top' class='value'><tags:editTags object="${dossier}" clazz="Dossier"/></td></tr>
									</g:if>
									<g:else>
                <input type="hidden" name="modele" value="${true}" />
                            <tr class='prop'><td valign='top' class='name'><label for='nomModele'>Nom du mod&egrave;le:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'nomModele','errors')}'><input type="text" id='nomModele' name='nomModele' value="${dossier?.nomModele ?: nomModele?.encodeAsHTML()}" size="30"/></td></tr>

                            <tr valign='top' class='prop'><td valign='top' class='name'><label for='keepMontant'>Conserver les montants des &eacute;critures:</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'keepMontant','errors')}'>
<g:checkBox name="keepMontant" value="${dossier.keepMontant ?: keepMontant}" />
								</td>
							</tr>
                            <tr valign='top' class='prop'><td valign='top' class='name'><label for='etatModele'>Etat des &eacute;critures cr&eacute;&eacute;es :</label></td><td valign='top' class='value ${hasErrors(bean:dossier,field:'etatModele','errors')}'><g:select optionKey="id" from="${EtatEcriture.list()}" name='etatModele.id' value="${dossier?.etatModele?.id ?: 1}" noSelection="['null':g.message(code:'dossier.modele.keepEtat')]"></g:select>
								</td>
							</tr>
									</g:else>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit action="update" value="Enregistrer" /></span>
                    <g:if test="${params.modele}"><input type="hidden" name="nomodele" value="true" /></g:if><span class="button"><g:actionSubmit class="danger" value="Supprimer" action="${params.modele ? 'edit' : 'delete'}"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
