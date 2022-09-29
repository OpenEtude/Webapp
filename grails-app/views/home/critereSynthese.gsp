  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Rapport de synth&egrave;se</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link controller="groupement" action="list"><span class="database_table ico"></span>Param&egrave;trage des Groupements</g:link></span>
        </div>
         </g:if>
        <div class="body">
            <h1>Rapport de synth&egrave;se</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <g:form accept-charset="UTF-8"   controller="home" method="get" >
                <input type="hidden" name="id" value="${acte?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
				            <tr class='prop'><td valign='top' class='name'><label for='debut'>P&eacute;riode:</label></td><td valign='top' class='value'><ul>
         <li><g:radio id="currMonth" name="periode" value="currMonth" checked="true" class="hides" rel="debut,fin"/><label for="currMonth">Mois en cours</label></li>
         <li><g:radio id="currQuarter" name="periode" value="currQuarter" class="hides" rel="debut,fin"/><label for="currQuarter">Trimestre en cours</label></li>
         <li><g:radio id="currYear" name="periode" value="currYear" class="hides" rel="debut,fin"/><label for="currYear">Ann&eacute;e en cours</label></li>
         <li><g:radio id="specific" name="periode" value="specific" class="shows" rel="debut,fin"/><label for="specific">Autre &agrave; d&eacute;finir</label></li></ul></td></tr>
				            <tr id="debut" class='prop hidden'><td valign='top' class='name'><label for='debut'>D&eacute;but:</label></td><td valign='top' class='value'><g:datePicker name='debut' value="${debut}" precision="day"></g:datePicker></td></tr>
				            <tr id="fin" class='prop hidden'><td valign='top' class='name'><label for='fin'>Fin:</label></td><td valign='top' class='value'><g:datePicker name='fin' value="${fin}" precision="day"></g:datePicker></td></tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"  title="Afficher le rapport de synth&egrave;se"><g:actionSubmit class="list" value="Afficher le rapport" action="synthese"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
