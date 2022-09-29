


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><etude:traduction name="Client"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
            <div class="nav">
                <span class="menuButton"><g:link action="list"><span class="database_table ico"></span>Clients</g:link></span>
                <span class="menuButton"><g:link action="create"><span class="database_add ico"></span><g:message code="domain.Client.new" default="Nouveau Client" /></g:link></span>
                <span class="menuButton"><g:link class="modal" controller='operation' params='["client.id":client?.id]' action='create'><span class="database_add ico"></span>Ajout Operation</g:link></span>
            </div>
		<div class="searchbox">
			<g:form border="0" url='[controller: "client", action: "search"]'   id="clientSearch" name="clientSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
						<etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="Nom client" lookup="true" controller="client"/>
			</g:form>
		</div>
		</g:if>
        <div class="body">
            <h1><etude:traduction name="Client"/> ${client}</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

<tr class="prop">

<td valign="top" class="name"><etude:traduction name="civilite" default="Civilite" />:</td>


                            <td valign="top" class="value"><g:link controller="civilite" action="show" id="${client?.civilite?.id}" class="show">${client?.civilite}</g:link></td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="nom" default="Nom" />:</td>


                            <td valign="top" class="value">${client.nom}</td>
                            
                        </tr>
                    
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="numIdentite" default="Num Identite" />:</td>


                            <td valign="top" class="value">${client.numIdentite}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="pieceIdentite" default="Piece Identite" />:</td>


                            <td valign="top" class="value"><g:link controller="pieceIdentite" action="show" id="${client?.pieceIdentite?.id}" class="show">${client?.pieceIdentite}</g:link></td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="addresse1" default="Addresse1" />:</td>


                            <td valign="top" class="value">${client.addresse1}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="addresse2" default="Addresse2" />:</td>


                            <td valign="top" class="value">${client.addresse2}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="ville" default="Ville" />:</td>


                            <td valign="top" class="value">${client.ville}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="commentaire" default="Commentaire" />:</td>


                            <td valign="top" class="value">${client.commentaire}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="telephone" default="Telephone" />:</td>


                            <td valign="top" class="value">${client.telephone}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="mobile" default="Mobile" />:</td>


                            <td valign="top" class="value">${client.mobile}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="fax" default="Fax" />:</td>


                            <td valign="top" class="value">${client.fax}</td>
                            
                        </tr>
                    
<tr class="prop">

<td valign="top" class="name"><etude:traduction name="email" default="Email" />:</td>


                            <td valign="top" class="value">${client.email}</td>
                            
                        </tr>
                    
<tr class="prop">


<td valign="top" colspan="2"><div style="display:inline"><etude:traduction name="operations" default="Operations" />:
            <g:if test="${!listeOperations.empty}">
</div>
<div class="paginateButtons"></div>
<ul style="padding-left:0px;">
<g:each var="operation" in="${listeOperations}" status="i">
<li class="${(i % 2) == 0 ? 'odd' : 'even'}" style="line-height:2em;"><g:link controller="operation" action="show" id="${operation.id}">${operation}
</g:link><br/><span class="tip">${operation.description}</span><etude:databar controller="client" fields="${[id:operation.id]}" style="min-width:none;min-height:none;margin-left:auto;margin-right:0;right:0;left:auto;top:auto;height:0.0em;width:5em;top:0px;margin-top:-1.4em;margin-bottom:1em;">
<g:actionSubmit class="link danger" warn="Etes-vous sur de vouloir dissocier" title="Dissocier de ${client.encodeAsJavaScript()}" value="Dissocier" action="removeOperation"/>
</etude:databar></li>
</g:each>
</ul>
<div class="paginateButtons"></div>
</div>
						</g:if>
                            </td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${client?.id}" />
                    <span class="button"><g:actionSubmit value="Modifier" action="edit"/></span>
                    <span class="button"><g:actionSubmit class="danger" value="Supprimer" action="delete"/></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
