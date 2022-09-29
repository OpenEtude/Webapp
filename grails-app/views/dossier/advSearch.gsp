  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Export Liste de Dossiers</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
        </div>
         </g:if>
        <div class="body">
            <h1>Export Liste de Dossiers</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <g:form accept-charset="UTF-8"   controller="dossier" method="get" >
                <div class="dialog">
                    <table>
                        <tbody>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="operation"><etude:traduction name="operation" default="Op&eacute;ration" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:dossier,field:'operation','errors')}">
								
									<g:if test="${operation}">
										${operation?.encodeAsHTML()}
										<input type="hidden" name="operation.id" value="${operation.id}"/>
									</g:if>
									<g:else>
		                                    <g:select optionKey="id" from="${Operation.list()}" name="operation.id" value="${dossier?.operation?.id}"  noSelection="['null':'']"></g:select>
									</g:else>
								
                                </td>
                            </tr> 
				            <tr class='prop'><td valign='top' class='name'><label for='q'>Nom, num&eacute;ro, libell&eacute; ou description:</label></td><td valign='top' class='value'><input type="text" id='q' name='q'/><input type="hidden" value="xls" name="format"/></td></tr>
				            <tr class='prop'><td valign='top' class='name'><label for='debut'>Cr&eacute;&eacute; entre le : </label></td><td valign='top' class='value'><g:datePicker name='debut' value="${debut}" precision="day"></g:datePicker></td></tr>
				            <tr class='prop'><td valign='top' class='name'><label for='fin'>Et le : </label></td><td valign='top' class='value'><g:datePicker name='fin' value="${fin}" precision="day"></g:datePicker></td></tr>
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button ico"></span><g:actionSubmit value="Exporter" action="results"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
