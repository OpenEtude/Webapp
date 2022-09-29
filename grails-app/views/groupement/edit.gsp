  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Modifier Groupement</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Liste Groupement</g:link></span>
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau Groupement</g:link></span>
        </div>
        <div class="body">
            <h1>Modifier Groupement</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${groupement}">
            <div class="errors">
                <g:renderErrors bean="${groupement}" as="list" />
            </div>
            </g:hasErrors>
            <g:form accept-charset="UTF-8" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>

							<tr class='prop'><td valign='top' class='name'><label for='libelle'>Libelle:</label></td><td valign='top' class='value ${hasErrors(bean:groupement,field:'libelle','errors')}'><input type="text" id='libelle' name='libelle' value="${groupement?.libelle?.encodeAsHTML()}"/></td></tr>
                   
                        </tbody>
                    </table>
                <input type="hidden" name="id" value="${groupement?.id}" />
			<div class="buttons">
				<div  style="width:100%;text-align:right;padding-right:20px">
				<span class="button">
				<span class="menuButton"><a href="#" class="selectall">S&eacute;lectionner Tout</a></span>&nbsp;|&nbsp;
				<span class="menuButton"><a href="#" class="selectnone">Aucune S&eacute;lection</a></span>
				</div>
			</div>
	            <div class="list">
	                <table>
	                    <thead>
	                        <tr>
								<g:sortableColumn property="typeEcriture" title="Libell&eacute;" />
			
	                   	        <th>
								</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                    <g:each in="${allLibelles}" status="i" var="typeEcriture">
	                        <tr class="${typeEcriture.categorieEcriture?.id==1?'frais':'prix'}${(i % 2) == 0 ? 'odd' : 'even'}">
	                        
								<td>${typeEcriture.encodeAsHTML()}</td>
	                        
	                   	        <td class="checkfix">
									<input type="hidden" name="id${i}" value="${typeEcriture?.id}" />
									<g:checkBox name="check${i}" value="${libelles.find{it.id==typeEcriture.id}}"/>
								</td>

	                        </tr>
	                    </g:each>
	                    </tbody>
	                </table>
	            </div>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit value="Enregistrer" action="update"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
