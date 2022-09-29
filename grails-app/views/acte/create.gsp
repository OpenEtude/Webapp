  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Nouvel Acte</title>         
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste des Actes</g:link></span>
        </div>
        </g:if>
    <g:if test="${params.nostyle!='true'}">
        <div class="searchbox">
            <g:form border="0" url='[controller: "acte", action: "search"]'   id="acteSearch" name="acteSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
                <etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Num ou Nom Acte" lookup="true" controller="acte"/>
            </g:form>
        </div>
    </g:if>
        <div class="body">
            <h1>Nouvel Acte</h1>
            <g:if test="${flash?.message}">
            <div class='message'>${flash.message}</div>
            </g:if>
            <g:if test="${flash?.messageError}">
            <div class='error'>${flash.messageError}</div>
            </g:if>
            <g:hasErrors bean="${acte}">
            <div class="errors">
                <g:renderErrors bean="${acte}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8"   action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                            <tr class='prop'><td valign='top' class='name'><div style="width:450px;"><table><tr class='prop'><td valign='top' class='name'><label for='numRepertoire'>Num Repertoire:</label></td><td valign='top' class='value ${hasErrors(bean:acte,field:'numRepertoire','errors')}'><input type="text" id='numRepertoire' name='numRepertoire' value="${acte?.numRepertoire?.encodeAsHTML()}"/></td><td valign='top' class='name'><label for='dossier'>Dossier:</label></td><td valign='top' class='value ${hasErrors(bean:acte,field:'dossier','errors')}'>
							<g:if test="${acte?.dossier?.id}">
								${acte?.dossier?.encodeAsHTML()}
								<input type="hidden" name="dossier.id" value="${params['dossier.id']}"/>
							</g:if>
							<g:else>
							<g:select optionKey="id" from="${lovDossier}" name='dossier.id' value="${acte?.dossier?.id}" noSelection="['null':'']"></g:select>
							</g:else>
							</td></tr>
                        
                            <tr class='prop'><td valign='top' class='name'><label for='libelle'>Libelle:</label></td><td valign='top' class='value ${hasErrors(bean:acte,field:'libelle','errors')}'><input type="text" style="min-width:350px;" id='libelle' name='libelle' value="${acte?.libelle?.encodeAsHTML()}"/></td><td valign='top' class='name'><label for='dateCreation'>Date Cr&eacute;ation:</label></td><td valign='top' class='value ${hasErrors(bean:acte,field:'dateCreation','errors')}' style="min-width:360px;"><g:datePicker name='dateCreation' value="${acte?.dateCreation}" precision ="day"></g:datePicker></td></tr></table></div></td></tr>
								<tr class='prop'><td valign='top' class='name' colspan="2">
								</td></tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input type="submit" value="Enregistrer"></input></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
