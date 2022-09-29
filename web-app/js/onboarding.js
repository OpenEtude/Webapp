// Define the tour!
var getUrl = window.location;
var baseUrl = getUrl.protocol + "//" + getUrl.host;
var hopscotchTourOnboardingDevMode = baseUrl == "http://localhost:8080/";
var hopscotchTourOnboardingCookieName = hopscotchTourOnboardingDevMode ? new Date().getMilliseconds() : baseUrl;
var hopscotchAppTitle = document.querySelector('.logo .logo').innerHTML || "Etude";
var hopscotchAppUser = document.querySelector('#profile').innerHTML || "";
var hopscotchTourOnboarding = null;
hopscotchTourOnboarding = {
    delay: 1,
    skipIfNoElement:true,
    showPrevButton:true,
    bubbleWidth: 305,
    bubblePadding:10,
    scrollTopMargin: 50,
    scrollDuration:200,
    smoothScroll:false,
    id: "ondoarding-hopscotch",
    onEnd: function() {
        setCookie(hopscotchTourOnboardingCookieName, hopscotchTourOnboardingCookieName);
    },
    steps: [
        {
            title: "Bienvenue "+hopscotchAppUser+"!",
            content: "<br>Vous êtes dans votre espace privé et personnalisé de l'application <b>"+hopscotchAppTitle+"</b>.<br><br>Faites le tour des principales fonctionnalités !",
            target: "#menuToggle",
            width: 250,
            placement: "bottom",
            onNext:function () {
                document.querySelector('#searchtoggle').checked=true;
                hopscotch.refreshBubblePosition();
                return;
            },
        },
        {
            title: "Recherche de dossiers",
            content: "Cherchez les dossiers clients partout dans l'application :<br> - Entrez une partie du numéro ou du nom de dossier puis sélectionnez parmi la liste proposée.<br> - Vous pouvez aussi appuyer sur entrée pour voir toutes les résultats !",
            target: ".searchbox",
            placement: "bottom",
            width:250,
            onStart:function () {
                document.querySelector('#searchtoggle').checked=true;
                hopscotch.refreshBubblePosition();
                return;
            },
            onNext:function () {
                document.querySelector('#searchtoggle').checked=false;
                document.querySelector('#hamburger').checked=true;
                setTimeout(function () {
                    hopscotch.refreshBubblePosition();
                },500);
                return;
            },
        },
        {
            title: "Accueil",
            content: "Revenez à tout moment à la Page d'Accueil.",
            target: "#home",
            width:250,
            onPrev:function () {
                document.querySelector('#hamburger').checked=false;
                setTimeout(function () {
                    hopscotch.refreshBubblePosition();
                },500);
                return;
            },
            onStart:function () {
                document.querySelector('#hamburger').checked=true;
                setTimeout(function () {
                    hopscotch.refreshBubblePosition();
                },500);
                return;
            },
            placement: "bottom"
        },
        {
            title: "Recherche",
            content: "Recherchez les Dossiers clients, les Actes ou les Ecritures Comptables.",
            width:250,
            target: ".search",
            placement: "bottom"
        },
        {
            title: "Favoris",
            width:250,
            content: "<b>Consultez les dossiers :</b><br/>- <u>En Conservation</u> : Contenant des frais de taxe foncière<br/> - <u>En enregistrement</u> : Contenant des frais d'enregistrement<br/> - <u>En cours</u> : Contenant des écritures à l'état <b>En cours</b> <span class='pending ico'></span><br/> -  <u>En Instance CF</u> : Contenant des frais d'enregistrement dépassant 200dh, mais sans frais de taxe fonciere (hors dossiers <span class='tag'>non soumis à TF</span>)<br/> - <u>En Instance IR/PF</u> Contenant des frais d'enregistrement dépassant dépasse le montant de 200dh, (hors dossiers <span class='tag'>non soumis à IR/PF</span>), ne contenant pas de prix paiement IR/PF et non attaché à une opération immobilière",
            target: ".favoris",
            placement: "bottom"
        },
        {
            title: "Opérations",
            width:250,
            content: "Gérez les opérations immobilières avec les partenaires promoteurs (clients) et gérez les dossiers et biens associés.",
            target: ".operationlink",
            placement: "bottom"
        },
        {
            title: "Rapport des groupements d'Ecritures",
            width:250,
            content: "<ul>Consultez les rapport des écritures par groupements : <li> - Chiffre d'affaires,</li><li> - Honoraires,</li><li> - Frais</li><li> - Charges</li><li> - Définissez vos propres groupements,</li><li> - Exportez les résulats en Excel</li></ul>",
            target: ".rapportgroupement",
            placement: "top"
        },
        {
            title: "Export de dossiers",
            width:250,
            content: "Exporter La liste des Dossiers sous le format excel selon plusieurs critères :<br>- Opérations Immobilières,<br>- Références dossier,<br>- Date.",
            target: ".exportdossierlink",
            placement: "top"
        },
        {
            title: "Comptes",
            width:250,
            content: "Gérez et consultez la siutation de vos comptes bancaires, procédez aussi au rapprochements des écritures.",
            target: "#compteBancaires",
            placement: "top"
        },
        {
            title: "Frais / Prix",
            width:250,
            content: "Consultez la synthèse Frais / Prix. Vous pouvez aussi lister le détails de ces écritures.",
            target: ".fraisPrix",
            placement: "top"
        },
        {
            title: "Activité",
            width:250,
            content: "Gardez un oeil sur les connexions des utilisteurs, toutes opérations de Création, de Modification ou de Suppression :<br>- Dossiers,<br>- Actes<br>- Ecritures<br>- Etc.",
            target: ".activitylink",
            placement: "top"
        },
        {
            title: "Mon profil",
            width:250,
            content: "Gérez votre mot de passe et vos favoris à tout moment.",
            target: ".myprofilelink",
            placement: "top"
        },
        {
            title: "Paramètres Utilisateurs",
            width:250,
            content: "Gérez les utilisateurs qui accèdent à l'application. Créez les et affectez leur les Rôles adaptés à vos besoins.",
            target: ".userslink",
            placement: "top"
        },
        {
            title: "Paramètres Ecritures",
            width:250,
            content: "Gérez les libellés des écritures afin de pouvoir les utiliser dans les dossiers et les actes :<br> - Frais<br> - Prix<br> - Autres<br><strong>Remarque : </strong> Plusieurs libellés sont déjà définis!",
            target: ".setupecritureslink",
            placement: "top"
        },
        {
            title: "Paramètres Groupements",
            width:250,
            content: "Regroupez les écritures afin de pouvoir voir leur synthèse dans le rapport <b>Ecritures</b><br><strong>Remarque : </strong> Plusieurs groupements sont déjà définis!",
            target: ".setupgroupementslink",
            placement: "top"
        },
        {
            title: "Paramètres Biens",
            width:250,
            content: "Definissez les types de biens et leurs attribus<br><strong>Remarque : </strong> Plusieurs types sont déjà définis !",
            target: ".setupbienslink",
            placement: "top"
        },
        {
            title: "Paramètres Sécurité",
            width:250,
            content: "Affinez les paramaètres de sécurité des roles d'utilisateurs :<br>- Que peut consulter, créer ou modifier chaque rôle ou groupe d'utilisateurs.",
            target: ".setupermisionslink",
            placement: "top"
        },
        {
            title: "Paramètres Sauvegardes",
            width:250,
            content: "Consultez et paramétrez les sauvegardes de données et leur envoi à votre addresse email.",
            target: ".backuplink",
            placement: "top"
        },
        {
            title: "Paramètres Avancés",
            width:250,
            content: "Configurez les paramètres avancés de l'application tels que la ville, le titre et les paramètres de vérrouillage des écritures.",
            target: ".setupadvancedlink",
            placement: "top"
        },
        {
            title: "Aide",
            width:250,
            content: "Consultez ce tour des fonctionnalités à tout moment.",
            target: ".helplink",
            placement: "top",
            onNext:function () {
                document.querySelector('#hamburger').checked=false;
                setTimeout(function () {
                    hopscotch.refreshBubblePosition();
                },500);
                return;
            },
        }
    ]
};
function setCookie(key, value) {
    var expires = new Date();
    expires.setTime(expires.getTime() + (1 * 24 * 60 * 60 * 1000));
    document.cookie = key + '=' + value + ';path=/' + ';expires=' + expires.toUTCString();
};
function getCookie(key) {
    var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');
    return keyValue ? keyValue[2] : null;
};
// Start the hopscotchTourOnboarding!
if (getCookie(hopscotchTourOnboardingCookieName)) {
    hopscotch.startTour(hopscotchTourOnboarding);
}