

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><g:message code="domain.CompteBancaire" default="CompteBancaire" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link action="synthese"><span class="database_table ico"></span>Comptes Bancaires</g:link></span>
            <g:if test="${!hasSoldeInitial}">
                <span class="menuButton"><g:link controller="ecriture" action="create" params="['type':'autre','etat.id':2,'typeEcriture.id':61,'compte.id':compteBancaire.id]"><span class="database_add ico"></span><g:message code="domain.CompteBancaire.addEcri" default="Définir solde initial" /></g:link></span>
            </g:if>
			<jsec:hasRole name="Maitre">&nbsp;|&nbsp;<span class="menuButton"><mymodal:createLink sclass="database_table" controller="activity" action="history" params="['controller.id':Activity.COMPTE_BANCAIRE, 'entity.id':compteBancaire?.id, 'titre':compteBancaire.toString()]" linkname="Historique" width="1000" height="600" title="Historique de l&apos;activit&eacute; du compte bancaire ${' '+compteBancaire}"/></span></jsec:hasRole>
        </div>
        <div class="body">
            <h1><g:message code="domain.CompteBancaire" default="CompteBancaire" /></h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compteBancaire.libelle" default="Libelle" />:</td>
                            
                            <td valign="top" class="value">${compteBancaire.libelle}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compteBancaire.dateCreation" default="Date Creation" />:</td>
                            
                            <td valign="top" class="value"><etude:relativeDate sentence="true" date="${compteBancaire.dateCreation}"/></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compteBancaire.dateCloture" default="Date Cloture" />:</td>
                            
                            <td valign="top" class="value"><etude:relativeDate sentence="true" date="${compteBancaire.dateCloture}"/></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compteBancaire.agence" default="Agence" />:</td>
                            
                            <td valign="top" class="value">${compteBancaire.agence}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compteBancaire.rib" default="R.I.B" />:</td>
                            
                            <td valign="top" class="value">${compteBancaire.rib}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compteBancaire.telephone" default="Telephone" />:</td>
                            
                            <td valign="top" class="value">${compteBancaire.telephone}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compteBancaire.contact" default="Contact" />:</td>
                            
                            <td valign="top" class="value">${compteBancaire.contact}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="compteBancaire.commentaire" default="Commentaire" />:</td>
                            
                            <td valign="top" class="value">${compteBancaire.commentaire}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${compteBancaire?.id}" />
                    <g:actionSubmit class="default modal" value="Modifier" action="Edit" modalwidth="700"/>
                    <g:actionSubmit class="danger" action="Delete" value="${message(code:'delete', 'default':'Delete')}" />
                </g:form>
            </div>
        </div>
    </body>
</html>
