  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle!='true' ? 'main' : 'nostyle'}" />
        <title>Synth&egrave;se Globale (${etat?.libelle ?: ''})</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            <span class="menuButton"><g:link controller="groupement" action="list"><span class="database_table ico"></span>Param&egrave;trage des Groupements</g:link></span>
        </div>
            </g:if>
	<div class="body">
            <h1>Synth&egrave;se Globale (${etat?.libelle ?: ''})</h1>
			<span class="tip">P&eacute;riode du <b><g:formatDate format="dd MMMM yyyy" date="${debut}"/></b> au <b><g:formatDate format="dd MMMM yyyy" date="${fin}"/>			<g:if test="${!all.empty}">
    <g:each in="${all}" status="j" var="synthese">
    <%
		def total = 0f
		synthese.value.each{total += it.total ?: 0f}
    	def labels = synthese.value.collect{it.typeEcriture?.libelle + " (${(100*(it.total ?: 0f)/total).intValue()}%25)"}
    	def colors = ['FF4422']
    	def values = synthese.value.collect{it.total ?: 0f}
    %>        
    <h3>${synthese.key?.libelle}</h3>
    <g:if test="${flash.message}">
    <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
    </g:if>
    <div class="dialog">
            <div class="list" style="margin:30px">
                <table>
                    <thead>
                        <tr>
							<th>Libell&eacute;</th>
                   	        <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${synthese.value}" status="i" var="entry">
                        <tr class="${entry.typeEcriture?.categorieEcriture?.id==1?'frais':'prix'}${(i % 2) == 0 ? 'odd' : 'even'}">
							<td>${entry.typeEcriture?.libelle?.encodeAsHTML()}</td>
                            <td class="moneyCell"><g:formatNumber number="${entry.total}" format="###,##0.00 DH" /></td>
                        </tr>
                    </g:each>
                    </tbody>
                    <tfooter>
                        <tr>
							<th><b>Total</b></th>
                   	        <th class="moneyCell"><b><g:formatNumber number="${total}" format="###,##0.00 DH" /></b></th>
                        </tr>
                    </tfooter>
                </table>
            </div>
            </div>
			</g:each>
            </g:if>
            <g:else><span class="tip">Aucune ecriture ne correspond &agrave; vos crit&egrave;res</span></g:else>
        </div>
    </body>
</html>
