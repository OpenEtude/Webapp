  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Rapport de groupements d'Ecritures : ${groupement?.libelle} (${etat.libelle})</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link controller="groupement" action="list"><span class="database_table ico"></span>Param&egrave;trage des Groupements</g:link></span>
        </div>
            </g:if>
    <%
		def total = 0f
		synthese.each{total += it.total}
    	def labels = synthese.collect{it.typeEcriture?.libelle + " (${(100*it.total/total).intValue()}%25)"}
    	def colors = ['FF4422']
    	def values = synthese.collect{it.total}
    %>        <div class="body">
            <h1>${groupement?.libelle} (${etat.libelle})</h1>
			<span class="tip">P&eacute;riode du <b><g:formatDate format="dd MMMM yyyy" date="${debut}"/></b> au <b><g:formatDate format="dd MMMM yyyy" date="${fin}"/></b>.</span><br/><br/><br/>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <g:if test="${!synthese.empty}">
            <div class="dialog" style="margin-bottom:20px">
	<mychart:pieChart title="Repartition par \u00e9criture" colors="${colors}" size="${[600,300]}"
      labels="${labels}" fill="${'bg,s,f0f0f0|c,s,f0f0f0'}" dataType='text' data='${values}'/>
            <div style="margin:30px">
                <table>
                    <thead>
                        <tr>
							<th>Libell&eacute;</th>
                   	        <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${synthese}" status="i" var="entry">
                        <tr class="${entry.typeEcriture?.categorieEcriture?.id==1?'frais':'prix'}${(i % 2) == 0 ? 'odd' : 'even'}">
							<td>${entry.typeEcriture?.libelle?.encodeAsHTML()}</td>
                            <td class="moneyCell"><g:formatNumber number="${entry.total}" format="###,##0.00 DH" /></td>
                        </tr>
                    </g:each>
                    </tbody>
                    <tfooter>
                        <tr>
							<th>&nbsp;</th>
                   	        <th class="moneyCell"><g:formatNumber number="${total}" format="###,##0.00 DH" /></th>
                        </tr>
                    </tfooter>
                </table>
            </div>
            </div>
            </g:if>
            <g:else><span class="tip">Aucune ecriture ne correspond &agrave; vos crit&egrave;res</span>
            </g:else>
        </div>
    </body>
</html>
