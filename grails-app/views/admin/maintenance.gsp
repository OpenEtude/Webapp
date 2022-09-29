<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Maintenance</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
			<span class="menuButton"><g:link controller='admin' action='restore' ><span class="database_table ico"></span>Sauvegardes B.D</g:link></span>
        </div>
		</g:if>
        <div class="body">
        <h1>Maintenance</h1>
        <div class="dialog">
            <g:if test="${flash.message}">
            <div class="${flash.messageType?:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
			<h3 class='taches-title'>T&acirc;ches planifi&eacute;es</h3><br/>
			<ul class="taches-detail" style="padding-left:0;">
			<g:each in="${jobs}" status="j" var="job">
			 <li ${etude.addHover(ctrlName:'admin',id:job.name)} style="min-height:6em;">
				<h3><g:message code="${job.name}"/><span class="tip"><g:if test="${job.trigger?.nextFireTime}"><br/>Prochaine ex&eacute;cution : <etude:relativeDate date="${job.trigger?.nextFireTime}" time="true" sentence="true"/></g:if></span></h3>
				<div class="right"><span>
<g:link class="num danger" controller='admin' title="${job.trigger?.nextFireTime ? 'D&eacute;sa' : 'A'}ctiver la t&acirc;che" action="${job.trigger?.nextFireTime ? 'un' : ''}schedule" params="[job:job.name]">${job.trigger?.nextFireTime ? 'D&eacute;sa' : 'A'}ctiver</g:link>
<g:link title="${job.running ? 'Arr&ecirc;ter' : 'Ex&eacute;cuter'} la t&acirc;che maintenant" class="num danger" controller='admin' action="${job.running ? 'abortJob': 'trigger'}" params="[job:job.name]">${job.running ? 'Arr&ecirc;ter': 'Lancer'}</g:link>
<g:link class="num modal" title="Configurer la t&acirc;che" controller='setting' action="syslist" params="[prefix:job.name,'comebackTo':'maintenance']">Configurer</g:link>
</span></div></li>
			</g:each>
			</ul>
        </div>
        </div>
    </body>
</html>
