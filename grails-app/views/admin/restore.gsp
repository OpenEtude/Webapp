  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Historique de sauvegarde (<etude:month num="${month}"/> ${year})</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link controller="admin" action="maintenance"><span class="database_save ico"></span>Maintenance</g:link></span>
        </div>
        <div class="body">
            <h1>Historique de sauvegarde (<etude:month num="${month}"/> ${year})</h1>
			<div style="max-height:auto;">
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
			<g:if test="${!sauvegardes.empty && !years.empty && !months.empty}">
			<table>
			<tr>
			<td class="nomobile" style="width:220px;">
			<div class="mywidget" style="min-height:600px;">
				<h2>P&eacute;riode</h2>
					<table>
					<tr>
					<td>
					<g:each in="${years}" status="i" var="y">
						<g:if test="${String.valueOf(y)==year}">
							<p><span class="highlightedFeature" style="background-color:#aaa;"><span  class="database_save"/><b>${y}</b></span></p>
						</g:if>
						<g:else>
							<p><g:link class="highlightedFeature" controller="admin" action="restore" params="${[year:y]}"><span  class="noimg"/>${y}</g:link></p>
						</g:else>
					</g:each>
					</td>
					<td>
					<g:each in="${months}" status="i" var="m">
						<g:if test="${String.valueOf(m)==month}">
							<p><span class="highlightedFeature" style="background-color:#aaa;"><span  class="database_save"/><b><etude:month num="${m}"/></b></span></p>
						</g:if>
						<g:else>
							<p><g:link class="highlightedFeature" controller="admin" action="restore" params="${[year:year,month:m]}"><span class="noimg"/><etude:month num="${m}"/></g:link></p>
						</g:else>
					</g:each>
					</td>
					</tr>
					</table>
			</div>
			</td>
			<td>
			<g:if test="${!sauvegardes.entrySet().empty}">
			<div class="myWidget" style="min-height:600px;">
			<g:form accept-charset="UTF-8" controller="admin" method="post" >
				<h2>Sauvegardes</h2>

				<div>
                    <ul>
                    <g:each in="${sauvegardes}" status="j" var="entry">
                     <li class="tip even">
                        <h3 style="color:#555;"><etude:relativeDate date="${entry.key}"/></h3>
                     </li>
                    <g:each in="${entry.value}" status="i" var="sauvegarde">
                        <li class="${(i % 2) == 0 ? 'odd' : 'even'} clickable" style="padding-left:0.5em;">
                            <span><input id="radio${j}x${i}" type="radio" name="backupFile" value="${sauvegarde.filename}" /> <g:formatDate date="${sauvegarde.date}" format="HH:mm"/> <i>${sauvegarde.filename}</i> <span class="tip"><g:formatNumber number="${sauvegarde.size / (1024*1024)}" format="###,##0.00 Mo" /></span></span> <g:link class="popupaction num boldlink" controller='admin' action='download' title="T&eacute;l&eacute;charger ce fichier" params="[filetype:'backup',filename:sauvegarde.filename]"><span class="database_save ico"></span>T&eacute;l&eacute;charger</g:link>
                        </li>
                    </g:each>
                    </g:each>
                    </ul>
				</div>
			</g:form>
			</div>
			</g:if>
			<g:else>
			<div class="myWidget" style="min-height:600px;">
				<h2>Sauvegardes</h2>
            <span class="tip">Aucune sauvegarde n'a &eacute;t&eacute; trouv&eacute;e pour <etude:month num="${month}"/> ${year}</span>
			</div>
            </g:else>
			</td>
			</tr>
			</table>
			</g:if>
			<g:else>
			<div class="dialog">
            <span class="tip">Aucune sauvegarde n'a &eacute;t&eacute; trouv&eacute;e</span>
            </g:else>
			</div>
        </div>
    </body>
</html>
