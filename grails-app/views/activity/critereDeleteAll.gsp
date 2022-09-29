  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Suppression de details d'activit&eacute;</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
        </div>
         </g:if>
        <div class="body">
            <h1>Suppression de details d'activit&eacute;</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <g:form accept-charset="UTF-8"   controller="activity" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='fin'>Dont la date est avant le :</label></td><td valign='top' class='value'><g:datePicker name='fin' value="${fin}" precision="day"></g:datePicker></td></tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit value="Supprimer" action="deleteAll"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
