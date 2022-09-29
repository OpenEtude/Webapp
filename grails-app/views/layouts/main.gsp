<html>
<head>
    <g:set var="appname" value="${etude.syssetting(key: 'etude')}"/>
    <g:set var="appversion" value="${grailsApplication.metadata['app.version']}"/>
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="application-name" content="${appname}">
    <meta property="og:title" content="${appname}">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-title" content="${appname}">
    <link rel="icon" sizes="192x192" href="/images/etude-4x.png">
    <link rel="apple-touch-icon" href="/images/etude-4x.png">
    <meta name="msapplication-TileImage" content="/images/etude-3x.png">
    <meta name="msapplication-TileColor" content="#d4d0c8">
    <meta name="theme-color" content="#d4d0c8">
    <meta property="og:type" content="website">
    <meta name="description" content="${appname}">
    <meta property="og:description" content="${appname}">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <jsec:isLoggedIn><g:if test="${session?.user}"><g:set var="logged"
                                                          value="${true}"/></g:if></jsec:isLoggedIn><g:set
            var="userAgent" value="${request.getHeader('user-agent')?.toLowerCase()}"/><jawr:style
            src="/style/classic.css" media="all"/>
    <link rel="stylesheet" media="screen" href="${resource(file:"/css/mobile.css?v=$appversion")}" />
    <g:if test="${logged}"><jawr:script src="/script/all.js"/></g:if><link rel="shortcut icon"
                                                                           href="${createLinkTo(dir: 'images', file: 'favicon.ico')}"
                                                                           type="image/x-icon"/>
    <g:layoutHead/><g:if test="${logged}"><title><etude:syssetting key='etude'/> - <g:layoutTitle
        default="${etude.syssetting(key: 'etude')}"/></title></g:if><g:else><title><etude:syssetting
        key='etude'/> - Connexion</title></g:else><g:if test="${userAgent?.contains('mobile')}"><link
        rel="apple-touch-icon" href="${createLinkTo(dir: 'images', file: 'apple-touch-icon.png')}"/></g:if>
</head>

<body style="${logged && params.nostyle != 'true' ? '' : 'background-image:none;'}">
<noscript><div id="noscript"
               style="${params.nostyle != 'true' ? '' : 'margin:0'}">Veuillez activer javascript sur votre navigateur</div>
</noscript>
<g:if test="${logged}">
    <g:if test="${params.nostyle != 'true'}">

        <div id="header">
            <div id="menuToggle">
                <input id="hamburger" type="checkbox"/>
                <i></i>
                <i></i>
                <i></i>
                <div class="logo">
                    <h2 id="appname"><g:link controller="home" class="logo" action="index">${etude.syssetting(key: 'etude')}</g:link>
                    </h2>
                    <g:link controller="home" class="logo" action="index"><div id="profile">${session.user}</div></g:link>
                </div>
                <ul id="leftmenu">
                    <g:render template="/layouts/menu"/>
                </ul>
            </div>
            <div class="searchonheader">
                <input id="searchtoggle" type="checkbox"/>
                <g:if test="${params.nostyle!='true'}">
                    <jsec:hasPermission type="EtudePerm" target="Dossier" actions="Liste">
                        <div class="searchbox">
                            <g:form border="0" url='[controller: "dossier", action: "search"]'   id="dossierSearch" name="dossierSearch"  accept-charset="UTF-8"  method="get" style="display:inline;"><etude:keyword name="q" size="20" id="keybox_main" accesskey="s" value="${params.q}" hint="Num ou Nom Dossier" title="${'Numero ou Nom de dossier'.encodeAsJavaScript()}" lookup="true" controller="dossier" xhrType="xml"/>
                            </g:form>
                        </div>
                    </jsec:hasPermission>
                </g:if>
                <div class="searchicon"></div>
            </div>


        </div>
    </g:if>
    <div class="${params.preview == 'true' ? '' : 'page'}${params.nostyle == 'true' ? ' nomargin' : ''} ${params.controller == 'home' ? 'accueil' : ''}">
    <g:if test="${params.nostyle != 'true'}">
        <div id="maincontent"><g:layoutBody/></div>
        <script src="/js/onboarding.js?v=${appversion}"></script>
        <g:if test="${System.env.ETUDE_DEMO_MAIN_TOUR}">
            <script src="${System.env.ETUDE_DEMO_MAIN_TOUR}?v=${appversion}"></script>
        </g:if>
    </g:if>
</g:if>
<g:else>
    <div id="bg" alt="">
    </div>
    <center>
        <script language="Javascript">
            function capLock(e) {
                kc = e.keyCode ? e.keyCode : e.which;
                if (13 == kc) {
                    $('login').submit();
                    return true;
                }
                sk = e.shiftKey ? e.shiftKey : ((kc == 16));
                if (((kc >= 65 && kc <= 90) && !sk) || ((kc >= 97 && kc <= 122) && sk)) {
                    $('capsWarn').style.visibility = 'visible';
                    $('capsWarn').style.display = 'block';
                    return true;
                } else {
                    $('capsWarn').style.visibility = 'hidden';
                    $('capsWarn').style.display = 'none';
                    return true;
                }
            }
        </script>

        <div id="loginBox" class="dialog">
            <g:form accept-charset="UTF-8" name="login" action="signIn" controller="auth">
                <input type="hidden" name="targetUri" value="${targetUri}"/>
                <table>
                    <tr>
                        <td colspan="2">
                            <h2>${appname}</h2>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <g:if test="${flash.message}">
                                <div class="message">${flash.message}</div>
                            </g:if>
                            <div id="capsWarn" class="warn"
                                 style="visibility:hidden;display:none;">La touche majuscule est activ&eacute;e!</div>
                        </td>
                    </tr>
                    <tr>
                        <td>Utilisateur</td>
                        <%
                            try {
                                name = jsec.principal() ?: username
                            } catch (e) {
                                name = username
                            }
                        %>
                        <td>
                        <div id="loginHeader"></div>
                        <input id="username" type="text" name="username"
                                                            name="username" value="${name}"
                                                            onkeypress="return capLock(event);"/><g:if
                                test="${!name}"><g:set var="focus" value="username"/></g:if><g:else><g:set
                                var="focus" value="password"/></g:else></td>
                    </tr>
                    <tr id="pwdfield">
                        <td>Mot de Passe</td>
                        <td><input id="password" type="password" name="password" value=""
                                   onkeypress="return capLock(event);"/><input type="hidden" name="rememberMe"
                                                                               value="${true}"/></td>
                    </tr>
                    <tr id="loginSubmitButton">
                        <td/>
                        <td><input id="loginButton" type="submit" value="Se connecter"/></td>
                    </tr>
                </table>
            </g:form>
        </div>
    </center>
    <g:if test="${!logged}"><jawr:script src="/script/all.js"/>
        <script language="javascript">
            $('${focus}').focus();
        </script>
    </g:if>
    <img src="${createLinkTo(dir: 'images/skin', file: 'sprite6.png')}" class="hidden"/>
    <g:if test="${System.env.ETUDE_DEMO_LOGIN_TOUR}">
        <script src="${System.env.ETUDE_DEMO_LOGIN_TOUR}?v=${appversion}"></script>
    </g:if>
</g:else>
</div>
<g:if test="${params.nostyle != 'true'}"><div id="spinner" class="spinner" style="display:none"><img
        src="${createLinkTo(dir: 'images', file: 'modalspinner.gif')}" alt="Spinner"/></div></g:if>
<!--Auteur : El Mehdi EL AOUFIR (Arkilog)-->
</body>
</html>