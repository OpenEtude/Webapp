  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>D&eacute;tail d'Activit&eacute;</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><mymodal:createLink sclass="database_delete" controller="activity" action="critereDeleteAll" title="Suppression de details d&apos;activit&eacute; pour lib&eacute;rer de l&apos;espace" linkname="Nettoyer l&apos;historique" width="600"/></span>
        </div>
        <div class="body">
            <h1>D&eacute;tail d'Activit&eacute;</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
			<g:if test="${!activityList.empty}">
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="dateCreated" title="Date" />
                        
                   	        <g:sortableColumn property="opType" title="Op&eacute;ration" />
                        
                   	        <g:sortableColumn property="controllerId" title="Type" />
                        
                   	        <g:sortableColumn property="user" title="Utilisateur" />
							<th/>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${activityList}" status="j" var="entry">
                     <tr class="tip even">
                        <td colspan="5"><h2><etude:relativeDate date="${entry.key}"/></h2></td>
                     </tr>
                    <g:each in="${entry.value}" status="i" var="activity">
                        <etude:tr ctrl="${g.message(code:'activity.controllerId.'+activity.controllerId)}" id="${activity.entityId}" class="oper${activity.opType}${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td style="text-indent:1em;"><g:formatDate date="${activity.dateCreated}" format="HH:mm"/></td>
                            <td colspan="2"><i><g:message code="activity.opType.${activity.opType?.encodeAsHTML()}"/> <g:message code="activity.controllerName.${activity.controllerId?.encodeAsHTML()}"/></i> <% value = byType.get(activity.controllerId).get(new Long(activity.entityId)) %> <g:if test="${value}">
							<g:link action="show" id="${activity.entityId}" controller="${g.message(code:'activity.controllerId.'+activity.controllerId)}">
							${value}</g:link><g:if test="${activity.msg}"><br/><span class="tip">${activity.msg}</span></g:if></g:if><g:else>#${activity.entityId}<br/><span class="tip">${activity.msg}</span></g:else></td><td><g:link action="show" id="${activity.user}" controller="jsecUser">
							${activity.user?.encodeAsHTML()}</g:link></td>
							<td><g:link controller="activity" class="noprint show" action="history" params="['controller.id':activity.controllerId, 'entity.id':activity.entityId, 'titre':activity.msg]">Historique</g:link></td>
                        </etude:tr>
                    </g:each>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Activity.count()}" />
            </div>
			</g:if>
            <g:else><span class="tip">Aucune activit&eacute; n'est enregistr&eacute;e</span>
            </g:else>
        </div>
    </body>
</html>
