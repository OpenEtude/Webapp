

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Nouveau <etude:traduction name="Operation"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            <span class="menuButton"><a href="${createLinkTo(dir:'')}"><span class="house"></span><g:message code="home" default="Acceuil" /></span><span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Operations</g:link></span>
		</div>
		</g:if>
        <div class="body">
            <h1>Nouveau <etude:traduction name="Operation"/></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:hasErrors bean="${operation}">
            <div class="errors">
                <g:renderErrors bean="${operation}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="libelle"><etude:traduction name="libelle" default="Libelle" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:operation,field:'libelle','errors')}">
								
		                                    <input type="text" id="libelle" name="libelle" value="${fieldValue(bean:operation,field:'libelle')}"/>
								
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="client"><etude:traduction name="client" default="Client" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:operation,field:'client','errors')}">
								
									<g:if test="${operation?.client?.id}">
										${operation?.client?.encodeAsHTML()}
										<input type="hidden" name="client.id" value="${params.get('client.id')}"/>
									</g:if>
									<g:else>
		                                    <g:select optionKey="id" from="${Client.list()}" name="client.id" value="${operation?.client?.id}" ></g:select>
									</g:else>
								
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><etude:traduction name="description" default="Description" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:operation,field:'description','errors')}">
								
		                                    <input type="text" id="description" name="description" value="${fieldValue(bean:operation,field:'description')}"/>
								
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dateCreation"><etude:traduction name="dateCreation" default="Date Creation" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:operation,field:'dateCreation','errors')}">
								
		                                    <g:datePicker name="dateCreation" value="${operation?.dateCreation}" precision ="day"></g:datePicker>
								
                                </td>
                            </tr> 
                        
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
