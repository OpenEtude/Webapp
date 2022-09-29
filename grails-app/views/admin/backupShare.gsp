<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
  <title>Sauvegarde du partage de fichiers</title>
</head>
<body>
		<g:if test="${params.nostyle!='true'}">
<div class="nav">
            <span class="menuButton"><g:link controller="admin" action="maintenance"><span class="database_save ico"></span>Maintenance</g:link></span>
</div>
		</g:if>
<div class="body">
<h1>Sauvegarde du partage de fichiers</h1>
	<g:if test="${flash.message}">
	<div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
	</g:if>
	<div class="dialog">
  <g:form accept-charset="UTF-8" controller="admin"  action="doBackupShare">
    <table>
      <tbody>
        <tr class='prop'>
          <td>Chemin du partage Windows (Exemple: POSTE/Partage/Dossier):</td>
          <td><input type="text" style="width:40em;" name="smbUrl" value="${smbUrl}" /><input type="hidden" name="folder" value="./arkilogfilebackup/" /></td>
        </td>
      </tbody>
    </table>
	<div class="buttons">
		<span class="button"><input type="submit" value="Lancer la sauvegarde" /></span>
	</div>
  </g:form>
  </div>
  </div>
</body>
</html>
