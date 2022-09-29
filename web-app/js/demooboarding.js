var demoOnboarding = {
    delay: 1,
    skipIfNoElement:true,
    showPrevButton:true,
    bubbleWidth: 280,
    bubblePadding:10,
    scrollTopMargin: 50,
    scrollDuration:200,
    smoothScroll:false,
    showCloseButton:false,
    id: "ondoarding-hopscotch-demo",
    steps: [
        {
            title: "Bienvenue",
            showCTAButton:true,
            ctaLabel:"Je veux en savoir plus",
            showNextButton: false,
            onCTA: function() {
                window.location.href='https://etudenotaires.com';
            },
            content: "<br/>Espace de démonstration",
            target: "table",
            placement: "bottom"
        },
    ]
};
//hopscotch.startTour(demoOnboarding);
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-135905431-1', 'auto');
ga('send', 'pageview');
var demoLoginAppClick = function (usr,pwd) {
    document.getElementById("username").value = usr;
    document.getElementById("password").value = pwd;
    document.getElementById("login").submit();
    return;
};
Event.observe(document, "dom:loaded", function () {
    var btnAccount = function (label,usr,pwd) {
        var btn = new Element('a', {
            style: "display:block;border:2px solid white;margin-bottom:5px;padding-top:0.6em;padding-left:20px;padding-right:20px;line-height:2em;padding-bottom:20px;height:2.5em;opacity:0.95;border-radius: 5px;",
            href:"#",
            onclick: "return demoLoginAppClick('"+usr+"','"+pwd+"');"
        });
        btn.innerHTML = label+"<span style='float:right;padding-top:1.25em;'><span class='database_save ico'></span></span>";
        return btn;
    };
    var elm = document.getElementById("loginHeader");
    document.getElementById("pwdfield").style="display:none;visibility:hidden;";
    document.getElementById("username").style="display:none;visibility:hidden;";
    document.getElementById("loginSubmitButton").style="display:none;visibility:hidden;";
    var fbMessenger = function () {
//Load Facebook SDK for JavaScript
        elm.appendChild(new Element('div', {id: "fb-root"}));
        window.fbAsyncInit = function () {
            FB.init({
                xfbml: true,
                version: 'v3.2'
            });
        };

        (function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s);
            js.id = id;
            js.src = 'https://connect.facebook.net/fr_FR/sdk/xfbml.customerchat.js';
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
        elm.appendChild(btnAccount("Maitre Démo","maitre_demo","159753"));
        elm.appendChild(btnAccount("Comptable Démo","comptable_demo","159753"));
        elm.appendChild(btnAccount("Stagiaire Démo","stagiaire_demo","159753"));
        elm.appendChild(btnAccount("Secretaire Démo","secretaire_demo","159753"));

//Your customer chat code
        elm.insert(new Element('div', {
                class: "fb-customerchat",
                attribution: "setup_tool",
                page_id: "2297743203883512",
                theme_color: "#67b868",
                logged_in_greeting: "Bonjour, comment pourrais-je vous aider?",
                logged_out_greeting: "Bonjour, comment pourrais-je vous aider?"
            }
        ));
    };
    fbMessenger();
});
