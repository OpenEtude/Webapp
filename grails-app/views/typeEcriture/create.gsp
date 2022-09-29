  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Nouveau Libell&eacute;</title>         
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste des Libell&eacute;s</g:link></span>
        </div>
		</g:if>
        <div class="body">
            <h1>Nouveau Libell&eacute; (${typeEcriture?.categorieEcriture?.encodeAsHTML()})</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${typeEcriture}">
            <div class="errors">
                <g:renderErrors bean="${typeEcriture}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   action="save" method="post" >
                <div class="dialog">
				<input type="hidden" name="categorieEcriture.id" value="${typeEcriture?.categorieEcriture?.id}"/>
                    <table>
                        <tbody>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='libelle'>Libelle:</label></td><td valign='top' class='value ${hasErrors(bean:typeEcriture,field:'libelle','errors')}'><input type="text" id='libelle' size="40" name='libelle' value="${typeEcriture?.libelle?.encodeAsHTML()}" /></td></tr>
                        
                            <tr valign='top' class='prop'><td valign='top' class='name'><label for='credit'>Type:</label></td>
								<td valign='top' class='value ${hasErrors(bean:typeEcriture,field:'credit','errors')}'>
									<g:radioGroup name="credit" labels="['D&eacute;bit','Cr&eacute;dit']" values="[false,true]"  value="${typeEcriture.credit}">
										<p>${it.label} ${it.radio}</p>
									</g:radioGroup>
								</td>
							</tr>
                            <tr valign='top' class='prop'><td valign='top' class='name'><label for='affectable'>Affectable &agrave; Compte Bancaire:</label></td><td>
<g:checkBox name="affectable" value="${typeEcriture.affectable}" />
								</td>
							</tr>
							<tr class='prop'><td valign='top' class='name'><label for='afficheDansOperation'>Affichage dans les op&eacute;rations:</label></td><td valign='top' class='value'><g:select from="${[0,1,2,3]}" name='afficheDansOperation' value="${typeEcriture?.afficheDansOperation}" valueMessagePrefix="typeEcriture.afficheDansOperation"></g:select></td></tr>
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
