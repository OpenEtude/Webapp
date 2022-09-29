  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier Libell&eacute; (${typeEcriture?.categorieEcriture?.encodeAsHTML()})</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste des Libell&eacute;s</g:link></span>
            <span class="menuButton"><g:link action="createAutre"><span class="database_add ico"></span>Nouveau Libell&eacute;</g:link></span>
            <span class="menuButton"><g:link action="createFrais"><span class="database_add ico"></span>Nouveau Libell&eacute; Frais</g:link></span>
            <span class="menuButton"><g:link action="createPrix"><span class="database_add ico"></span>Nouveau Libell&eacute; Prix</g:link></span>
        </div>
        <div class="body">
            <h1>Modifier Libell&eacute; (${typeEcriture?.categorieEcriture?.encodeAsHTML()})</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${typeEcriture}">
            <div class="errors">
                <g:renderErrors bean="${typeEcriture}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   controller="typeEcriture" method="post" >
                <input type="hidden" name="id" value="${typeEcriture?.id}" />
				<input type="hidden" name="categorieEcriture.id" value="${typeEcriture?.categorieEcriture?.id}"/>
                <div class="dialog">
                    <table>
                        <tbody>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='libelle'>Libell&eacute;:</label></td><td valign='top' class='value ${hasErrors(bean:typeEcriture,field:'libelle','errors')}'><input type="text" id='libelle' size="30" name='libelle' value="${typeEcriture?.libelle?.encodeAsHTML()}"  /></td></tr>
                        
                            <tr valign='top' class='prop'><td valign='top' class='name'><label for='credit'>Type:</label></td>
								<td valign='top' class='value ${hasErrors(bean:typeEcriture,field:'credit','errors')}'>
									<g:radioGroup name="credit" labels="['D&eacute;bit','Cr&eacute;dit']" values="[false,true]"  value="${typeEcriture.credit}">
										<p>${it.label} ${it.radio}</p>
									</g:radioGroup>
								</td>
							</tr>

                            <tr valign='top' class='prop'><td valign='top' class='name'><label for='affectable'>Affectable &agrave; Compte Bancaire:</label></td><td valign='top' class='value ${hasErrors(bean:typeEcriture,field:'affectable','errors')}'>
<g:checkBox name="affectable" value="${typeEcriture.affectable}" />
								</td>
							</tr>
							<tr class='prop'><td valign='top' class='name'><label for='afficheDansOperation'>Affichage dans les op&eacute;rations:</label></td><td valign='top' class='value ${hasErrors(bean:typeEcriture,field:'afficheDansOperation','errors')}'><g:select from="${[0,1,2,3]}" name='afficheDansOperation' value="${typeEcriture?.afficheDansOperation}" valueMessagePrefix="typeEcriture.afficheDansOperation"></g:select></td></tr>
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
