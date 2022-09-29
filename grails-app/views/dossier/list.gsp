  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><g:if test="${params.title}">${params.title}</g:if><g:else>Liste des Dossiers</g:else></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
            
            <span class="menuButton"><g:link action="create"><span class="database_add ico"></span>Nouveau Dossier</g:link></span>
            <span class="menuButton"><g:link action="list" params="${ParamUtils.keep(params,['minAmount','typeEcriture','exclude','title','notTag','isNull','etat','q','addTo','sort','order','mode','id','max','offset'])+[format:'xls']}"><span class="xls ico"></span>Export</g:link></span>
			<g:if test="${params.mode=='select' && params.addTo == 'Operation'}">
			<span class="menuButton"><g:link controller="operation" action="show" id="${params.id}"><span class="database_edit ico"></span><etude:traduction name="${params.addTo}.backToOperation" default="Retour &agrave; l'op&eacute;ration"/></g:link></span>
			</g:if>
        </div>
		</g:if>
    <g:if test="${params.nostyle!='true'}">
        <div class="searchbox">
            <g:form border="0" url='[controller: "dossier", action: "list"]'   name="dossierSearch"  accept-charset="UTF-8"  method="get" style="display:inline;">
                <etude:keyword name="q" size="20" id="keybox" accesskey="s" value="${params.q}" hint="${params.title ?: 'Num ou Nom Dossier'}" lookup="${params.mode!='select'}" controller="dossier" />
            </g:form>
        </div>
    </g:if>
        <div class="body">
            <h1><g:if test="${params.title}">${params.title}</g:if><g:else><g:if test="${params.mode!='select'}"><etude:traduction name="Dossier.list" default="Liste des Dossiers"/></g:if><g:else><etude:traduction name="Dossier.selectMany" default="Ajout de Dossiers"/></g:else></g:else></h1>
            <g:if test="${filters != null && !filters.entrySet().empty}">
            <g:each in="${filters}" var="entry"><b><g:message code="dossier.list.${entry.key}"/> : </b> <span class="tip">${"notTag".equals(entry.key) ? tags.listTags(tags:entry.value) : (entry.value instanceof Collection ? entry.value.join(' ') : entry.value)}</span> </g:each><br/><br/>
            </g:if>
            <g:if test="${params.q}">
            <b>Mot cl&eacute; : </b> <span class="tip">${params.q}</span><br/>
            </g:if>
			<g:form accept-charset="UTF-8" controller="${ParamUtils.class2prop(params.addTo) ?: 'dossier'}" method="post" >
			<g:if test="${params.mode=='select'}">
			<input type="hidden" name="listSize" value="${dossierList.size()}" />
			<input type="hidden" name="${ParamUtils.class2prop(params.addTo)}.id" value="${params.id}" />
			<div class="buttons">
				<div  style="width:100%;text-align:right;padding-right:20px">
				<span class="button">
				<span class="menuButton"><a href="#" class="selectall">S&eacute;lectionner Tout</a></span>&nbsp;|&nbsp;
				<span class="menuButton"><a href="#" class="selectnone">Aucune S&eacute;lection</a></span>&nbsp;|&nbsp;
				<g:actionSubmit class="validate" action="addManyDossier" value="Ajouter la s&eacute;lection" /></span>
				</div>
			</div>
			</g:if>

            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn  params="${sortParams}" action="list" property="numero" title="Num&eacute;ro Dossier" />
                        
                   	        <g:sortableColumn  params="${sortParams}" action="list" property="libelle" title="Libell&eacute;" />
                        
                   	        <g:sortableColumn  params="${sortParams}" action="list" property="description" title="Description" />
                        
                   	        <g:sortableColumn  params="${sortParams}" action="list" property="dateCreation" title="Date Cr&eacute;ation" />
            <g:if test="${filters != null && !filters.entrySet().empty}">
                   	        <g:sortableColumn  params="${sortParams}" action="list" property="dateValeur" title="Derni&egrave;re Ecriture" />
            </g:if>
							<g:if test="${params.mode=='select'}">
							<th/>
							</g:if>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${dossierList}" status="i" var="dossier">
						<etude:tr ctrl="dossier" id="${dossier.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td ><etude:linkDossier dossier="${dossier}" display="${dossier.numeroDossier}"/></td>
                            <td ><tags:showTags object="${dossier}" clazz="Dossier"/>${dossier.libelle?.encodeAsHTML()}</td>
                            <td >${dossier.description?.encodeAsHTML()}</td>
                            <td  class="dateCell"><etude:relativeDate date="${dossier.dateCreation}"/></td>
            <g:if test="${filters != null && !filters.entrySet().empty}">
                            <td  class="dateCell"><etude:relativeDate date="${dates.get(dossier)}"/></td>
            </g:if>
							<g:if test="${params.mode=='select'}">
                   	        <td class="checkfix">
								<input type="hidden" name="id${i}" value="${dossier.id}" />
								<g:checkBox name="check${i}" value="${false}"/>
							</td>
							</g:if>
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${count}" params="${paginateParams}" action="list"/>
            </div>
        </div>
			</g:form>
    </body>
</html>
