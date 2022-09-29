  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Planification des sauvegardes</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link controller="admin" action="maintenance"><span class="database_save ico"></span>Maintenance</g:link></span>
        </div>
        <div class="body">
            <h1>Planification des sauvegardes</h1>
			<div style="max-height:auto;">
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
			<div class="myWidget" style="min-height:auto;">
				<h2>T&acirc;ches planifi&eacute;es</h2>
				<div style="max-width:600px;">
                    <ul>
                    <g:each in="${jobs}" status="j" var="job">
                     <li ${etude.addHover(ctrlName:'admin',id:job.name)} >
                        <h3><span class="${job.trigger?.nextFireTime ? 'checked' : 'rejected' }"></span><g:message code="${job.name}"/><h3><p>
						<span class="tip">Prochaine ex&eacute;cution : <etude:relativeDate date="${job.trigger?.nextFireTime}" time="true" sentence="true"/><g:if test="${!job.trigger?.nextFireTime}"><b>non planifi&eacute;</b></g:if><etude:relativeDate date="${job.running}" time="true" sentence="true"/></span><etude:databar controller="admin" fields="${[id:job.name]}" style="min-width:none;min-height:none;margin-left:auto;margin-right:0;right:0;left:auto;top:auto;height:0.0em;width:5em;top:0px;margin-top:-2.8em;margin-bottom:0.8em;">
<g:link class="danger" controller='admin' action="${job.trigger?.nextFireTime ? 'un' : ''}schedule" params="[job:job.name]">${job.trigger?.nextFireTime ? 'D&eacute;sa' : 'A'}ctiver</g:link>
</etude:databar>
                     </li>
                    </g:each>
                    </ul>
				</div>
			</div>
			</div>
        </div>
    </body>
</html>
