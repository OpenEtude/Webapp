

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title><etude:traduction name="Bien.list" default="Liste des Biens"/></title>
    </head>
    <body>
		<g:if test="${params.nostyle!='true'}">
        <div class="nav">
                        
			<span class="menuButton"><g:link action="create"><g:message code="domain.Bien.new" default="Nouveau Bien" /><span class="database_add ico"></span></g:link></span>
			<g:if test="${params.mode=='select'}">
			<span class="menuButton"><g:link controller="operation" action="show" id="${params.addTo == 'Operation' ? params.id : Dossier.get(params.id)?.operation?.id}"><etude:traduction name="${params.addTo}.backToOperation" default="Retour &agrave; l'op&eacute;ration"/><span class="database_edit ico"></span></g:link></span>
			</g:if>
		</div>
		</g:if>
        <div class="body">
            <h1><g:if test="${params.mode!='select'}"><etude:traduction name="Bien.list" default="Liste des Biens"/></g:if><g:else><etude:traduction name="Bien.selectMany" default="Ajout de Biens"/></g:else></h1>
			<g:form accept-charset="UTF-8" controller="${ParamUtils.class2prop(params.addTo) ?: 'bien'}" method="post" >
			<g:if test="${params.mode=='select'}">
			<g:set var="selectIndex" value="${0}"/>
			<% bienListSize = 0;bienList.each{bienListSize+=it.value?.size()} %>
			<input type="hidden" name="listSize" value="${bienListSize}" />
			<input type="hidden" name="${ParamUtils.class2prop(params.addTo)}.id" value="${params.id}" />
			<input type="hidden" name="from" value="${params.from}" />
			<input type="hidden" name="fromId" value="${params.fromId ?: params.id}" />
			<div class="buttons">
				<div  style="width:100%;text-align:right;padding-right:20px">
				<span class="button">
				<span class="menuButton"><a href="#" class="selectall">S&eacute;lectionner Tout</a></span>&nbsp;|&nbsp;
				<span class="menuButton"><a href="#" class="selectnone">Aucune S&eacute;lection</a></span>&nbsp;|&nbsp;
				<g:actionSubmit class="validate" action="addManyBien" value="Ajouter la s&eacute;lection" /></span>
				</div>
			</div>
			</g:if>

            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}"><g:message code="${flash.message}" args="${flash.args}" default="${flash.message}" /></div>
            </g:if>
            <g:if test="${!bienList.empty}">
			<g:each in="${bienList}" status="j" var="entry">
            <div class="list">
                <table>
                    <thead>
	                     <tr style="height:2em;">
							<g:sortableColumn class="even" style="background-image:none;" colspan="${entry.key.champs.size() + (params.mode != 'select' ? 4 : 2)}" property="typeDeBien" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="&gt;&nbsp;${entry.key}"/>
	                     </tr>
                        <tr>
                   	        <g:sortableColumn style="width:15em;" property="libelle" params="${sortParams}" action="${params.q ? 'search' : 'list'}"  title="${etude.traduction(name:'libelle', default:'Libell&eacute;')}"/>
							<g:if test="${params.mode!='select'}">
                   	        <th><etude:traduction style="width:12em;" name="operation" default="Operation" /></th>
                   	        <th><etude:traduction style="width:25em;" name="dossier" default="Dossier" /></th>
							</g:if>
                   	    
							<g:each in="${entry.key.champs}" var="champ">
                   	        <th><etude:traduction name="${champ.libelle}" default="${champ.libelle}" /></th>
							</g:each>
							<g:if test="${params.mode=='select'}">
							<th></th>
							</g:if>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${entry.value}" status="i" var="bien">
						<etude:tr ctrl="bien" id="${bien.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
				            <td><mymodal:createLink controller="bien" action="edit" params="['id':bien.id]" linkname="${bien.libelle}"/></td>
							<g:if test="${params.mode!='select'}">
                            <td><g:link controller="operation" action="show" id="${bien.operation?.id}">${bien.operation?.encodeAsHTML()}</g:link></td>
                            <td><etude:linkDossier dossier="${bien.dossier}"/></td>
							</g:if>
                        
							<g:each in="${bien.typeDeBien.champs}" var="champ">
                   	        <td><%=bien.valeurs?.find{it?.champ == champ}?.contenu %></td>
							</g:each>
                        
							<g:if test="${params.mode=='select'}">
                   	        <td class="checkfix" style="width:2em;">
								<input type="hidden" name="id${selectIndex}" value="${bien.id}" />
								<g:checkBox name="check${selectIndex}" value="${false}"/>
								<g:set var="selectIndex" value="${selectIndex + 1}"/>
                				</td>
							</g:if>
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
			</g:each>
            <div class="paginateButtons">
                <g:paginate total="${count}" params="${paginateParams}" action="${params.q ? 'search' : 'list'}"/>
            </div>
	        </g:if>
			</g:form>
        </div>
    </body>
</html>
