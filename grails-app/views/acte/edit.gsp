  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier Acte</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste des Actes</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouvel Acte</g:link></span>
        </div>
    <g:if test="${params.nostyle!='true'}">
        <div class="searchbox">
            <g:form border="0" url='[controller: "acte", action: "search"]'   id="acteSearch" name="acteSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
                <etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Num ou Nom Acte" lookup="true" controller="acte"/>
            </g:form>
        </div>
    </g:if>
        <div class="body">
            <h1>Modifier Acte</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${acte}">
            <div class="errors">
                <g:renderErrors bean="${acte}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   controller="acte" method="post" >
				<g:if test="${contenu}">
                <div class="buttons">
                    <span class="button"><g:actionSubmit value="Enregistrer" action="update"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </div>
				</g:if>
                <input type="hidden" name="id" value="${acte?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
				<tr class='prop'><td valign='top'><div  style="width:700px;"><table><tbody>
				            <tr class='prop'><td valign='top' class='name'><label for='numRepertoire'>Num Repertoire:</label></td><td valign='top' class='value ${hasErrors(bean:acte,field:'numRepertoire','errors')}'><input type="text" id='numRepertoire' name='numRepertoire' value="${acte?.numRepertoire?.encodeAsHTML()}"/></td><td valign='top' class='name'><label for='dossier'>Dossier:</label></td><td valign='top' class='value ${hasErrors(bean:acte,field:'dossier','errors')}'><etude:linkDossier dossier="${acte.dossier}" /></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='libelle'>Libelle:</label></td><td valign='top' class='value ${hasErrors(bean:acte,field:'libelle','errors')}'><input type="text" style="min-width:350px;" id='libelle' name='libelle' value="${acte?.libelle?.encodeAsHTML()}"/></td><td valign='top' class='name'><label for='dateCreation'>Date Cr&eacute;ation:</label></td><td valign='top' style="min-width:360px;" class='value ${hasErrors(bean:acte,field:'dateCreation','errors')}'><g:datePicker name='dateCreation' value="${acte?.dateCreation}" precision ="day"></g:datePicker></td></tr></tbody></table></div></td></tr>
                        
						<g:if test="${listEcritures && ! listEcritures.empty}">
                        <tr class="prop">
                            <td valign="top" class="name">Ecritures :
                                <ul>
                                <g:each var="ecr" in="${listEcritures}">
                                    <li><span class="${etude.mpIcon(mp:ecr.moyenPaiement)}"><g:link controller="ecritureDossier" action="show" id="${ecr.id}" title="${ecr.commentaire}">${ecr.typeEcriture?.libelle} : <g:formatNumber number="${ecr.montant}" format="###,##0.00 DH" /></g:link></li>
                                </g:each>
                                </ul>
                            </td>
                        </tr>
						</g:if>
						<tr class='prop'><td valign='top' class='name'>
							</td>
						</tr>
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit value="Enregistrer" action="update"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
