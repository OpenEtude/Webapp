  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Historique ${activityType}</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="show" id="${entityId}" controller="${g.message(code:'activity.controllerId.'+controllerId)}"><span class="database_edit ico"></span>Retour</g:link></span>
        </div>
		</g:if>
        <div class="body">
            <h1>Historique ${activityType} : ${titre}</h1>
            <g:if test="${!activityList.empty}">
            <div class="dialog">
                <table>
                    <tbody>
                    <g:each in="${activityList}" status="i" var="activity">
                        <tr class="oper${activity.opType}${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td class='log'><g:message code="activity.opType.${activity.opType?.encodeAsHTML()}"/> <g:message code="activity.controllerName.${activity.controllerId}"/> <b><etude:relativeDate sentence="true" date="${activity.dateCreated}" time="true" sentence="true"/></b> par <b>${activity.user?.encodeAsHTML()}</b> ${activity.msg ? ': ' + activity.msg : ''}</td>
							<td>
							<g:if test="${activity.opType!=Activity.DELETE}">
							<g:link action="show" id="${activity.entityId}" controller="${g.message(code:'activity.controllerId.'+activity.controllerId)}">Afficher</g:link>
							</g:if>
							</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            </g:if>
            <g:else><span class="tip">L'historique est vide.</span></g:else>
        </div>
    </body>
</html>
