<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="layout" content="${params.nostyle ? 'nostyle' : 'main'}" />
  <title>Changement de Mot de Passe</title>
</head>
<body>
		<g:if test="${params.nostyle!='true'}">
<div class="nav">
	
</div>
		</g:if>
<div class="body">
<h1>Changement de Mot de Passe</h1>
	<g:if test="${flash.message}">
	<div class="${flash.messageType?flash.messageType:'message'}">${flash.message}</div>
	</g:if>
	<div class="dialog">
  <g:form accept-charset="UTF-8" controller="param"  action="updatePwd">
    <input type="hidden" name="targetUri" value="${targetUri}" />
    <table cellspacing="0">
      <tbody>
        <tr>
          <td colspan="2"></td>
        </tr>
        <tr class='prop'>
          <td style="padding-top:20px">Utilisateur:</td>
          <td style="padding-top:20px">${username}</td>
		  <input type="hidden" name="username" value="${username}" />
        </tr>
        <tr class='prop'>
          <td>Ancien Mot de Passe:</td>
          <td><input type="password" name="password" value="" /></td>
        </td>
        <tr class='prop'>
          <td>Nouveau Mot de Passe:</td>
          <td><input type="password" name="password1" value="" /></td>
        </td>
        <tr class='prop'>
          <td>R&eacute;peter le Nouveau Mot de Passe:</td>
          <td><input type="password" name="password2" value="" /></td>
        </td>
      </tbody>
    </table>
	<div class="buttons">
		<span class="button"><input type="submit" value="Valider le changement" /></span>
	</div>
  </g:form>
  </div>
  </div>
</body>
</html>
