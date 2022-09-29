<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Relev&eacute; de Compte Bancaire</title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
        </div>
         </g:if>
        <div class="body">
            <h1>Relev&eacute; de Compte Bancaire</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <g:form accept-charset="UTF-8"   controller="ecriture" method="post" >
                <input type="hidden" name="id" value="${acte?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
							<g:set var="extensions" value="${[['ext':'html','name':'Page Web'], ['ext':'xls','name':'Excel']]}"/>
				            <tr class='prop'><td valign='top' class='name'><label for='compteBancaire'>Compte Bancaire:</label></td><td valign='top' class='value'><g:select optionKey="id" from="${lovCompteBancaire}" name='compteBancaire.id' value="${compteBancaire?.id}" ></g:select></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='compteBancaire'>Etat:</label></td><td valign='top' class='value'><g:select optionKey="id" from="${lovEtat}" name='etat.id' value="${etatEcriture?.id}" ></g:select></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='debut'>D&eacute;but:</label></td><td valign='top' class='value'><g:datePicker name='debut' value="${debut}" precision="day"></g:datePicker></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='fin'>Fin:</label></td><td valign='top' class='value'><g:datePicker name='fin' value="${fin}" precision="day"></g:datePicker></td></tr>
                        
				            <tr class='prop'><td valign='top' class='name'><label for='compteBancaire'>Afficher le r&eacute;sultat dans :</label></td><td valign='top' class='value'><g:select name="format" from="${['html', 'xls']}" valueMessagePrefix="result.format" /></td></tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit value="Relev&eacute;" action="doExport"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
