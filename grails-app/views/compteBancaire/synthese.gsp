

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle!='true' ? 'main' : 'nostyle'}" />
        <title><g:message code="compteBancaire.list" default="Situation des comptes bancaires" /></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span><g:message code="compteBancaire.new" default="Nouveau Compte Bancaire" /></g:link></span>
            <span class="menuButton"><mymodal:createLink sclass="database_table" controller="ecriture" action="export" title="Relev&eacute; de compte bancaire" linkname="Relev&eacute;" width="600"/></span>
            <span class="menuButton"><g:link action="synthese" params="[format:'xls']"><span class="xls ico"></span>Export</g:link></span>
        </div>
		</g:if>
        <div class="body">
            <h1><g:message code="compteBancaire.list" default="Situation des comptes bancaires" /></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                   	        <th>Libell&eacute;</th>
                   	        <th class="moneyCell">Solde</th>
                   	        <th class="moneyCell">D&eacute;bit en cours</th>
                   	        <th class="moneyCell">Cr&eacute;dit en cours</th>
	                        <th colspan="3"></th>
                        </tr>
                    </thead>
                    <tbody>
							<g:set var="totalSolde" value="${0.0F}"/>
							<g:set var="totalDebit" value="${0.0F}"/>
							<g:set var="totalCredit" value="${0.0F}"/>
                    <g:each in="${syn}" status="i" var="entry">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="detail" id="${entry.cb?.id}">${entry.cb?.libelle?.encodeAsHTML()}</g:link></td>
                        
                            <td class="moneySummaryCell"><span style="font-size:12px;font-weight:bold;color:${entry.solde < 0 ? 'red' : 'green'}" title="Solde futur : ${g.formatNumber(number:((entry.solde?:0.0) + (entry.encoursCredit?:0.0)), format:'###,##0.00 DH')}"><g:formatNumber number="${entry.solde}" format="###,##0.00 DH" /></span></td>
							<g:set var="totalSolde" value="${totalSolde + entry.solde}"/>
                            <td class="moneyCell"><span style="font-size:12px;"><g:formatNumber number="${entry.encoursDebit ?: 0.0}" format="###,##0.00 DH" /></span></td>
							<g:set var="totalDebit" value="${totalDebit + (entry.encoursDebit ?: 0.0)}"/>
                            <td class="moneyCell"><span style="font-size:12px;"><g:formatNumber number="${entry.encoursCredit ?: 0.0}" format="###,##0.00 DH" /></span></td>
							<g:set var="totalCredit" value="${totalCredit + (entry.encoursCredit ?: 0.0)}"/>
                        
                            <td class="noprint"><g:link action="detail" id="${entry.cb?.id}">D&eacute;tails</g:link></td>
                            <td class="noprint"><g:link controller="ecriture" action="affect" id="${entry.cb?.id}">Affectation</g:link></td>
                            <td class="noprint"><g:if test="${entry.pending>=1}"><g:link controller="ecriture" action="validate" id="${entry.cb?.id}">Rapprochement <span class="num">${entry.pending}</span></g:link></g:if></td>
                        </tr>
                    </g:each>
                    <tfoot>
                        <tr>
                        
                   	        <th>Total</th>
                        
                   	        <th class="moneyCell"><span style="font-size:12px;font-weight:bold;color:${totalSolde < 0 ? 'red' : 'green'}"><g:formatNumber number="${totalSolde}" format="###,##0.00 DH" /></span></th>
                   	        <th class="moneyCell"><g:formatNumber number="${totalDebit}" format="###,##0.00 DH" /></th>
                   	        <th class="moneyCell"><g:formatNumber number="${totalCredit}" format="###,##0.00 DH" /></th>
	                        <th colspan="3"></th>
                        </tr>
                    <tfooter>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
