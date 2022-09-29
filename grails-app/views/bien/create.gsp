

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Nouveau <etude:traduction name="Bien"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            <span class="menuButton"><a href="${createLinkTo(dir:'')}"><span class="house"></span><g:message code="home" default="Acceuil" /></span><span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Biens</g:link></span>
		</div>
		</g:if>
        <div class="body">
            <h1>Nouveau <etude:traduction name="Bien"/></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${bien}">
            <div class="errors">
                <g:renderErrors bean="${bien}" as="list" />
            </div>
            </g:hasErrors>
			<span class="ohno hidden"><g:if test="${!bien}">Une erreur s'est produite.</g:if></span>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="libelle"><etude:traduction name="bien.libelle" default="Titre foncier" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:bien,field:'libelle','errors')}">
								
		                                    <input type="text" id="libelle" name="libelle" value="${fieldValue(bean:bien,field:'libelle')}"/>
								
                                </td>
                            </tr> 
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="typeDeBien"><etude:traduction name="typeDeBien" default="Type De Bien" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:bien,field:'typeDeBien','errors')}">
								
								<g:select id='bienSelect' optionKey="id" from="${lovTypeDeBien}" name="typeDeBien.id" value="${bien?.typeDeBien?.id}" onChange="${remoteFunction(controller: 'typeDeBien', action: 'listeChamps',method:'get', update: 'champsDiv',on500:'ohno',onComplete:'new Effect.Appear(\'champsDiv\', 30);Modalbox.resize(0, -200);',params: '\'id=\' + this.options[this.selectedIndex].value')}" noSelection="['null':'']"></g:select>
								
                                </td>
                            </tr> 
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="operation"><etude:traduction name="operation" default="Operation" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:bien,field:'operation','errors')}">
								
									<g:if test="${bien?.operation?.id}">
										${bien?.operation?.encodeAsHTML()}
										<input type="hidden" name="operation.id" value="${params.get('operation.id')}"/>
									</g:if>
									<g:else>
		                                    <g:select optionKey="id" from="${Operation.list()}" name="operation.id" value="${bien?.operation?.id}" ></g:select>
									</g:else>
								
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dossier"><etude:traduction name="dossier" default="Dossier" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:bien,field:'dossier','errors')}">
								
									<g:if test="${bien?.dossier?.id}">
										${bien?.dossier?.encodeAsHTML()}
										<input type="hidden" name="dossier.id" value="${params.get('dossier.id')}"/>
									</g:if>
									<g:else>
		                                    <g:select optionKey="id" from="${lovDossier}" name="dossier.id" value="${bien?.dossier?.id}" noSelection="['null':'']"></g:select>
									</g:else>
								
                                </td>
                            </tr> 
							<tbody id="champsDiv"></tbody>
							<g:if test="${bien?.typeDeBien?.id}"><span class="evaljs">new Effect.Appear('spinner', 20);${remoteFunction(controller: 'typeDeBien', action: 'listeChamps',method:'get', update: 'champsDiv',on500:'ohno',onComplete:'new Effect.Appear(\'champsDiv\', 30);Modalbox.resize(0, -200);',params: '\'id=\' + \$("bienSelect").options[\$("bienSelect").selectedIndex].value')}new Effect.Fade('spinner', 20);</span></g:if>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input type="submit" value="Enregistrer"></input></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
