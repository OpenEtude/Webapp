  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier R&ocirc;le</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste des r&ocirc;les</g:link></span>
        </div>
        <div class="body">
            <h1>Param&egrave;trage du r&ocirc;le : ${jsecRole.name}</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${jsecRole}">
            <div class="errors">
                <g:renderErrors bean="${jsecRole}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   controller="jsecRole" method="post" >
                <div class="buttons">
                    <span class="button"><g:actionSubmit action="update" value="Enregistrer" /></span>
                </div>
                <input type="hidden" name="id" value="${jsecRole?.id}" />
<input type="hidden" name="nbPerms" value="${permissions.size()}" />
				<div class="dialog">
				Utilisateurs ayant ce r&ocirc;le : <span class="tip"><g:if test="${users.empty}">Aucun</g:if>${users.join(', ')}</span>
	                    <g:each in="${permissions}" var="perm" status="i">
							<g:if test="${!perm.target.startsWith('Jsec') && perm.target!= 'Setting'}">
						<ul>
						<li class="tip"><b>${etude.traduction('name':perm.target,'default':perm.target)}</b></li>
							<input type="hidden" name="perm${i}" value="${perm.target}" />
	                        <li>
	                        <ul>
								<g:each in="${EtudePerm.allowedActions.sort()}" var="act" status="j">
	<g:set var="permLabel" value="${g.message(code:'EtudePerm.'+perm.target+'.'+act, 'default':'')}"/>
							<g:if test="${permLabel}">
								<li>
										<input type="hidden" name="perm${i}_${j}" value="${act}" />
										<g:if test="${!'Aucune'.equals(act)}">
											<g:checkBox name="check${i}_${j}" value="${perm.actions.contains(act)}"/>
										</g:if>
										<g:else><b>x</b></g:else>
									<label for="check${i}_${j}">${permLabel}</label>
									</li>
							</g:if>
								</g:each>
							</ul>
							</li>
						</ul>
							</g:if>
	                    </g:each>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit action="update" value="Enregistrer" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
