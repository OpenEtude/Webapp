Event.observe(document, "dom:loaded", function () {
    var elm = document.getElementById("header");
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

//Your customer chat code
        elm.appendChild(new Element('div', {
                class: "fb-customerchat",
                attribution: "setup_tool",
                page_id: "2297743203883512",
                theme_color: "#67b868",
                logged_in_greeting: "Bonjour, comment pourrais-je vous aider?",
                logged_out_greeting: "Bonjour, comment pourrais-je vous aider?"
            }
        ));
    };
    var SECS = 1000;
    setTimeout(function(){
        var btn1Opt = {class:"highlightedFeature", href:"#", style:"cursor:pointer;min-width:16rem;background-color:#003DB8;color:white;text-shadow: none;", onclick:"hopscotch.startTour(hopscotchTourOnboarding);"};
        var btn2Opt = {class:"highlightedFeature", href:"#", style:"cursor:pointer;min-width:16rem;background-color:forestgreen;color:white;text-shadow: none;",href:"https://etudenotaires.com"};
        var btn1 = new Element("a",btn1Opt);
        var btn2 = new Element("a",btn2Opt);
        var cent = new Element('center');
        var container = new Element('div',{style:"position:fixed;left:auto;right:auto;background-color:lightyellow;height:6rem;font-size:1rem;bottom:0;width:100%;border-radius:1rem;display:block;opacity:0.8;padding-top:1rem;padding-bottom:1rem;font-weight:bold;text-align:center;"});
        btn1.update('Tour des fonctionnalités');
        btn2.update('En savoir plus');
        cent.appendChild(btn1);
        cent.appendChild(new Element('br'));
        cent.appendChild(btn2);
        container.appendChild(cent);
        elm.appendChild(container);
        document.body.style.height = document.getElementById("maincontent").clientHeight + 6 + 'rem';
        fbMessenger();
        container.highlight({startcolor:'#ffcc00', duration: 5});
    }, 10 * SECS);
});
