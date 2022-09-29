  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>R&ocirc;le : ${jsecRole.name}</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste des r&ocirc;les</g:link></span>
        </div>
        <div class="body">
            <h1>R&ocirc;le : ${jsecRole.name}</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="buttons">
                <g:form accept-charset="UTF-8"   controller="jsecRole">
                    <input type="hidden" name="id" value="${jsecRole?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                </g:form>
            </div>
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
											${perm.actions.contains(act) ? "<span class=\'accept\'/>" : "<span class=\'database_delete\'/>"}
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
                <g:form accept-charset="UTF-8"   controller="jsecRole">
                    <input type="hidden" name="id" value="${jsecRole?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
