<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Acte : ${acte?.libelle}</title>
    </head>
    <body>

        <div class="nav">
            
            <span class="menuButton"><g:link action="list" title="Liste des actes"><span class="database_table ico"></span>Liste des Actes</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouvel Acte</g:link></span>
            <jsec:hasRole name="Maitre">&nbsp;|&nbsp;<span class="menuButton"><g:link controller="activity" action="history" params="['controller.id':Activity.ACTE, 'entity.id':acte?.id, 'titre':acte.toString()]"><span class="database_table ico"></span>Historique</g:link></span></jsec:hasRole>
        </div>
    <g:if test="${params.nostyle!='true'}">
        <div class="searchbox">
            <g:form border="0" url='[controller: "acte", action: "search"]'   id="acteSearch" name="acteSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
                <etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Num ou Nom Acte" lookup="true" controller="acte"/>
            </g:form>
        </div>
    </g:if>
        <div class="body">
            <h1>Acte : ${acte?.libelle}</h1>
			<g:if test="${contenu}">
			<g:form accept-charset="UTF-8"   controller="acte">
            <div class="buttons">
                    <input type="hidden" name="id" value="${acte?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
            </div>
            </g:form>
			</g:if>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                        <tr class="prop">

                            <td valign="top" class="name">Dossier: <etude:linkDossier dossier="${acte.dossier}"/>, Num&eacute;ro de Repertoire: <b>${acte.numRepertoire}</b>,  cr&eacute;e <i><etude:relativeDate sentence="true" date="${acte.dateCreation}"/></i><g:if test="${contenu}">
			                <g:form accept-charset="UTF-8"   controller="acte" style="display:inline">
			                    <input type="hidden" name="acteId" value="${acte?.id}" />
			                    <span class="button"><g:actionSubmit class="danger" style="width:20em;;" onclick="return confirm('Etes-vous sur de vouloir detacher le document?');" action="detach" value="D&eacute;tacher le contenu de l'acte" /></span>
			                </g:form>
						</g:if>
</td>
                        </tr>
						<g:if test="${listEcritures && ! listEcritures.empty}">
                        <tr class="prop">
                            <td valign="top" class="name">Ecritures :
                                <ul>
                                <g:each var="ecr" in="${listEcritures}">
                                    <li><span class="${etude.mpIcon(mp:ecr.moyenPaiement)}"></span><g:link controller="ecritureDossier" action="show" id="${ecr.id}" title="${ecr.commentaire}">${ecr.typeEcriture?.libelle} : <g:formatNumber number="${ecr.montant}" format="###,##0.00 DH" /></g:link></li>
                                </g:each>
                                </ul>
                            </td>
                        </tr>
						</g:if>
                    </tbody>
                </table>
            </div>
			<g:form accept-charset="UTF-8"  controller="acte">
            <div class="buttons">
                    <input type="hidden" name="id" value="${acte?.id}" />
                    <g:actionSubmit class="temporary" value="Modifier" action="edit"/>
                    <g:actionSubmit class="danger" value="Supprimer" action="delete"/>
            </div>
            </g:form>
        </div>
    </body>
</html>
