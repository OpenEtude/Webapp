  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
        <title>Liste des Libell&eacute;s</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link class="modal" modalwidth="900" action="createAutre" title="Nouveau Libell&eacute;"><span class="database_add ico"></span>Nouveau Libell&eacute;</g:link></span>
            <span class="menuButton"><g:link class="modal" modalwidth="900" action="createFrais" title="Nouveau Libell&eacute; Frais"><span class="database_add ico"></span>Nouveau Libell&eacute; Frais</g:link></span>
            <span class="menuButton"><g:link class="modal" modalwidth="900" action="createPrix" title="Nouveau Libell&eacute; Prix"><span class="database_add ico"></span>Nouveau Libell&eacute; Prix</g:link></span>
            <span class="menuButton"><g:link class="modal" modalwidth="400" action="standardize" title="Uniformiser les libell&eacute;s"><span class="database_edit ico"></span>Uniformiser les libell&eacute;s</g:link></span>
            <span class="menuButton"><g:link class="modal" modalwidth="700" action="upload" title="Importer les libell&eacute;s"><span class="database_save ico"></span>Importer les libell&eacute;s</g:link></span>
            <span class="menuButton"><g:link action="export" title="Exporter les libell&eacute;s"><span class="xls ico"></span>Exporter les libell&eacute;s</g:link></span>
        </div>
        <div class="body">
            <h1>Liste des Libell&eacute;s</h1>
            <g:if test="${flash.message}">
            <div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
            </g:if>
            <div class="main">
				<etude:tabPane id="etude_libelle_${actionName}">
                    <g:each in="${libelles}" var="entry">
					<etude:tab code="${entry.key?.encodeAsHTML()}"/>
                    </g:each>
				</etude:tabPane>
                    <g:each in="${libelles}" var="entry">
				<etude:tabContent code="${entry.key?.encodeAsHTML()}">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="libelle" title="Libell&eacute;" />
                        
                   	        <g:sortableColumn property="credit" title="Type" />
                        
                   	        <g:sortableColumn property="affectable" title="Affectable &agrave; Compte Bancaire" />
                        
                   	        <g:sortableColumn property="afficheDansOperation" title="Affichage dans les op&eacute;rations" />
                        
                        	<td/>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${entry.value}" status="i" var="typeEcriture">
						<etude:tr ctrl="typeEcriture" actionName="edit" id="${typeEcriture.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><g:link action="show" id="${typeEcriture.id}">${typeEcriture.id?.encodeAsHTML()}</g:link></td>
                            <td>${typeEcriture.libelle?.encodeAsHTML()}</td>
                            <td>${typeEcriture.credit?'Cr&eacute;dit':'D&eacute;bit'}</td>
                            <td>${typeEcriture.affectable?'Oui':'Non'}</td>
                            <td>${g.message(code:'typeEcriture.afficheDansOperation.'+typeEcriture.afficheDansOperation)}</td>
                        </etude:tr>
                    </g:each>
                    </tbody>
                </table>
				</etude:tabContent>
				</g:each>
            </div>
        </div>
    </body>
</html>
