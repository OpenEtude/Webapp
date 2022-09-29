var ETUDE = {
	disableModalHandleRedirect : false,
	isPreviewRequest : false,
	setDone:function(element,fid){
	element.addClassName('_ark_'+fid);},
	done:function(element,fid){return element.hasClassName('_ark_'+fid);;},
	runOnce:function(fid,f,element){if (!ETUDE.done(element,fid)){ETUDE.setDone(element,fid);return f(element);}},
	jump:function(event,to){	
		if (event.target!=null && event.target.tagName.toUpperCase()=='TR' || event.target.tagName.toUpperCase()=='TD') {
			if(event.keyCode==17){
				window.open(to,'_blank');
			} else {
				document.location.href = to;
			}
		}
	},
	toggle:function(element){
		if (element.checked){
			element.up().up().addClassName("rowselected");
		} else {
			element.up().up().removeClassName("rowselected");
		}
	},
	doSelect:function(ok) {
	   $$('td.checkfix input[type="checkbox"]').each(
			function docheck(element) {
				element.checked = ok;
				ETUDE.toggle(element);
			}
		);
	},
	selectall:function(element){element.observe('click',function(){ETUDE.doSelect(true);})},
	selectnone:function(element){element.observe('click',function(){ETUDE.doSelect(false);})},
	ellipsis:function(e,maxLength) {
		var t = e.innerHTML.escapeHTML();
		if (t.length > maxLength) {
			e.title = e.innerHTML;
			var trunc = t.truncate(maxLength,'...').unescapeHTML();
			e.innerHTML = "<span class=\"noprint\">" + trunc + "</span><span class=\"noshow\"><b>"+e.title+"</b></span>";
		}
	},
	ellipsis30:function(e) {ETUDE.ellipsis(e,30);},
	ellipsis50:function(e) {ETUDE.ellipsis(e,50);},
	ellipsis60:function(e) {ETUDE.ellipsis(e,60);},
	ellipsis90:function(e) {ETUDE.ellipsis(e,90);},
	appear:function(element) {
		element.innerHTML+="<div class=\"spread\"><button class=\"danger topright\" onclick=\"this.up().up().fade({ duration:0.5});return false;\">X</button></div>";
		new Effect.Pulsate(element, { duration: 0.75,pulses:0.25,from:0.0 });
	},
	disableLink:function(element) {
		element.href = "#";
		element.title = "Fonctionnalit\351 non disponible pour le moment.";
	},
	nolinks:function(element) {
		element.select("a").invoke('hide');
	},
	hookHighlightListItem:function(element) {
		if (element.checked){
			element.up().up().addClassName("rowselected");
		}
		element.observe("widget:outsideclick", function(event){
				element.checked = true;
				element.up().up().addClassName("rowselected");
				element.focus();
		});
		element.observe("change", function(event){
				element.up().up().addClassName("rowselected");
		});
		element.observe("blur", function(event){
				element.up().up().removeClassName("rowselected");
		});
	},
	hookHighlightRow:function(element) {
		if (element.checked){
			element.up().up().addClassName("rowselected");
		}
		element.observe("change", function(event){ETUDE.toggle(element);});
		element.observe("widget:docheck", function(event){ETUDE.toggle(element);});
	},
	hookHighlight:function(element) {
		element.highlight({startcolor:'#ff7000', duration: 5});
		element.removeClassName("highlight");
	},
	addPreview:function(element) {
		var anchor = element.previous("span.help");
		if (null == anchor){
			var parent = element.up();
			if (parent.tagName.toUpperCase()=='TD'){
				parent = parent.previous(); //TD
				anchor = parent.down("span.help");
				if (null == anchor){
					parent = parent.up(); //TR
					anchor = parent.down("span.help");
				}
			}
		}
		new Tip(anchor, {title: element.innerHTML, ajax: {url: (element.href+'?preview=true&nostyle=true'),options: {method:'get',onComplete:ETUDE.hookEvents}},closeButton: true,hideOn:'.close', className: 'etude',effect: 'appear',delay:1,radius: 0,border:0,viewport: true, stem: 'topMiddle' });
	},
	setModal:function(element) {
		var el_h = element.height;
		var target = element.getAttribute('anchor');
		var modalwidth = element.getAttribute('modalwidth');
		var title = element.title;
		if ((null==title || undefined==title || ""==title) && element.tagName.toUpperCase()=='A'
		&& !element.hasClassName("step") && undefined == element.up("th.sortable")) {
			title = element.innerHTML;
		}
		if (null==title || undefined==title || ""==title) {
			var h1 = element.ancestors().last();
			if (null!=h1){h1 = h1.down("h1");}
			if (null!=h1){title += " "+h1.innerHTML;}
		}
		if (undefined==target) {
			target = element.href;
			target +=(target.indexOf('?')!=-1 ? '&' : '?')+'nostyle=true';
		}
		if (undefined==modalwidth) {modalwidth = 1000;}
		element.observe('click',function(event){
			event.stop();
            var vp_w = Math.min(document.documentElement.clientWidth, window.innerWidth || 0);
            Modalbox.show(target,
			{title: title,
			width:Math.min(vp_w, modalwidth),height:element.getAttribute('modalheight'),overlayOpacity:0.01,closeString: 'Fermer',evalScripts:true,overlayDuration:0.0,overlayClose:true,afterLoad: ETUDE.hookEvents});
			return false;
		});
	},	
	setInputModal:function(element) {
		var target = element.getAttribute('anchor');
		var modalwidth = element.getAttribute('modalwidth');
		var title = element.value;
		var h1 = element.up('html');
		if (null!=h1){h1 = h1.down("h1");}
		if (null!=h1){title += " "+h1.innerHTML;}
		if (element.title){title = element.title;}
		if (undefined==target) {
			target = element.up("form");
		}
		if (undefined==modalwidth) {modalwidth = 1000;}
		element.observe('click',function(event){
            document.getElementById('menuToggle').setAttribute('class','hidden');
            ETUDE.disableModalHandleRedirect = true;
			event.stop();
			var formParams = $H(target.serialize(true));
			formParams.set('nostyle',true);
			Modalbox.show(target.action, 
			{title: title,
			width:modalwidth,height:element.getAttribute('modalheight'),overlayOpacity:0.01,closeString: 'Fermer',evalScripts:true,overlayDuration:0.0,params: formParams, method: 'post',afterLoad: ETUDE.hookEvents});
            document.getElementById('menuToggle').removeAttribute('class');
			return false;
		});
	},
    setAutoComplete:function(element) {
        var baseurl = '/';
		var controller = element.getAttribute("controller");
		var filter = element.getAttribute("filter");
		var onItemSelect = element.getAttribute("onItemSelect");
		element.observe("keypress",function(evt){
			element.removeClassName("noresults");
		});
		if (null==filter){filter="";}
		var div = new Element('div', { 'class': 'searchcontainer yui-skin-sam' })
		element.insert({after:div});
		autoCompleteDataSource = new YAHOO.widget.DS_XHR(baseurl+controller+"/lookup", ["result", "name", "id", "code", "date", "icon"]);
		autoCompleteDataSource.scriptQueryAppend = filter+"format=xml";
		autoCompleteDataSource.responseType = YAHOO.widget.DS_XHR.TYPE_XML;
		autoComplete = new YAHOO.widget.AutoComplete(element,div,autoCompleteDataSource);
		autoComplete.queryDelay = 1;
		autoComplete.prehighlightClassName = "yui-ac-prehighlight";
		autoComplete.useShadow = false;
		autoComplete.minQueryLength = 2;
		autoCompleteDataSource.maxCacheEntries = 0;
		autoComplete.offsetWidth = 450;
		autoComplete.formatResult = function(aResultItem, sQuery) {					
			var sKey = aResultItem[0]; // the entire result key                          
			// and another piece of data defined by schema                               
			var sCode = aResultItem[2];                                             
			var sDate = aResultItem[3];                                             
			var sIcon = aResultItem[4];                                             
			sIcon = sIcon ? "<span class='"+sIcon+"'></span>" : "";           
			var keyItems = sQuery.split(/[+, ' ', '*']/);                          
			for(i = 0; i < keyItems.length; i++){                          
			var rex = new RegExp(keyItems[i], "gi");                     
			var matches = sKey.match(rex);	
			var matchesTip = sCode.match(rex);	
			if (null != matches && matches[0]!="" && matches[0]!=null){                   
			sKey = sKey.replace(rex, "<b>"+matches[0]+"</b>"); 
			}                          
			if (null != matchesTip && matchesTip[0]!="" && matchesTip[0]!=null){                   
			sCode = sCode.replace(rex, "<b>"+matchesTip[0]+"</b>"); 
			}                          
			}                          
			var aMarkup = ["<div id='ysearchresult'>"+sIcon,                                   
			sKey,                                                            
			"<br/><span class='tip'>",                                        
			sCode,                                                                
			" (",                                                                
			sDate,                                                                
			")</span></div>"];                                                                
			return (aMarkup.join(""));                                                    
		};                                                                              
		var itemSelectHandler = function(sType, args) {
			var autoCompleteInstance = args[0];
			var selectedItem = args[1];
			var data = args[2];
			var id = data[1];
			if (null!= onItemSelect){eval(onItemSelect);} else {
				document.location.href = (baseurl=="/" ? "" : baseurl)+"/"+controller+'/show/' + id;
			}
		};
		autoComplete.itemSelectEvent.subscribe(itemSelectHandler);
		var containerPopulateHandler = function(oSelf) {
			var mbContent = $('MB_content');
			if (mbContent != null){
				mbContent.setStyle({'overflow':'visible'});
			}
		};
		autoComplete.dataReturnEvent.subscribe(containerPopulateHandler);
		autoComplete.dataReturnEvent.subscribe(function(oSelf,aResults) {
			if (aResults[2].size()==0){element.addClassName("noresults");}
			else {element.removeClassName("noresults");}
		});
	},
	setDatabar:function(element) {
		var parent = element.up();
		while (parent !=null && parent.tagName.toUpperCase()!= "TR" && parent.tagName.toUpperCase()!= "LI"){
			parent = parent.up();
		}
		if (parent!=null){
			if (parent.tagName.toUpperCase()== "LI"){parent.insert(element);}
			parent.observe('mouseout',function(event){
				element.addClassName('partiallyhidden');
				element.removeClassName('normal');
				element.descendants().each(function(item){
					item.addClassName('weightnormal');
					item.removeClassName('weightbold');
				});
			});
			parent.observe('mouseover',function(event){
				element.removeClassName('partiallyhidden');
				element.addClassName('normal');
				element.descendants().each(function(item){
					item.addClassName('weightbold');
					item.removeClassName('weightnormal');
				});
			});
		}
	},
	hookLiClick:function(element) {
		element.observe('click',function(event){
			element.down('input[type="radio"]').fire("widget:outsideclick");
			}
		);
	},
	hookConfirmOnDanger:function(element) {
		element.observe('click', function(event){var msg = element.getAttribute('warn');
		if (!msg && element.value!=null && element.value.startsWith("Suppr")){msg="\312tes vous sur de vouloir supprimer?";}
		if (!confirm(msg ? msg : "\312tes vous sur de vouloir effectuer cette action?")){Event.stop(event);};});
	},
	hookTrClickable:function(element) {
		element.observe('click', function(event){ETUDE.jump(event,element.getAttribute('url'));});
	},
	hookPopupAction:function(element) {
		element.addClassName('justhidden');
		element.previous().observe('mouseover', function(event){element.removeClassName('justhidden');element.addClassName('partiallyhidden');});
		element.previous().observe('mouseout', function(event){element.removeClassName('partiallyhidden');});
		element.observe('mouseover', function(event){element.removeClassName('justhidden');element.removeClassName('partiallyhidden');});
		$(element,element.previous()).each(function(it){it.observe('mouseout', function(event){element.addClassName('justhidden')});})
	},
	CronUI:Class.create({
		  initialize: function(element,index) {
			this.element  = element;
			this.elementId = index;
			this.parse();
			this.buildUI();
			this.bindAll();
		  },
		  parse: function() {
			var cron = this.element.value;
			cron = cron.sub('  ',' ');
			var cronArray = cron.split(' ');
			var i = 0;
			this.seconds = cronArray[i++];
			this.minutes = cronArray[i++];
			this.hours = cronArray[i++];
			this.dayOfMonth = cronArray[i++];
			this.month = cronArray[i++];
			this.dayOfWeek = cronArray[i++];
		  },
		  toString: function() {
			return this.seconds +" "
			+this.minutes +" "
			+this.hours +" "
			+this.dayOfMonth +" "
			+this.month +" "
			+this.dayOfWeek;
		  },
		  show: function() {this.element.value = this.toString();},
		  selectEvery: function(name) {this.disableSelect(name,false);
			  this.checkIncompatible(name);
		  },
		  selectChoose: function(name) {var el = this.findSelect(name); 
		  el.removeAttribute('disabled');
		  el.removeClassName('partiallyhidden');
		  var checkChoose = el.previous('#'+this.elementId+'choose'+name)
		  if (checkChoose!=undefined){
			checkChoose.checked = true;
		  }
		  this.setProperty(name, el.value);
			  this.checkIncompatible(name);
		  },
		  noEvery:$A(['minutes','hours']),
		  nonCompatible:$H({'dayOfMonth':'dayOfWeek','dayOfWeek':'dayOfMonth'}),
		  disableProperty: function(name) {this.disableSelect(name,true);},
		  disableSelect: function(name,value) {
			var el = this.findSelect(name)
			el.addClassName('partiallyhidden');
			if (value) {
				el.setAttribute('disabled',true);
				var choose = el.previous('#'+this.elementId+'choose'+name)
				if (undefined!=choose)choose.checked = false;
				var every = el.previous('#'+this.elementId+'every'+name)
				if (undefined!=every)every.checked = false;
			} else {
				el.removeAttribute('disabled');
				el.previous('#'+this.elementId+'every'+name).checked = true;
			}
			this.setProperty(name, (value ? '?' : '*'));
		  },
		  findSelect: function(name) {return this.ui.select('select').find(function(el) {return el.name==name;});},
		  checkIncompatible: function(name) {
			var me = this;
			this.nonCompatible.each(function(pair){
				if (name==pair.key){
					me.disableProperty(pair.value);
				}
			});
		  },
		  bind: function(name,f) {
			var me = this;
			var uiElement = this.findSelect(name);
			var val = this.getProperty(name);
			uiElement.value = val;
			if (val == '?') {this.disableSelect(name, true);}
			else if (val == '*') {this.selectEvery(name);}
			else {this.selectChoose(name);}
			uiElement.observe('click', function(event){
			  me.checkIncompatible(name);
			  f(Event.element(event));
			 });
		  },
		  bindAll: function() {
			var me = this;
			$A(
				['minutes', 'hours','dayOfMonth','dayOfWeek']
			).each(
				function(name) {
					me.bind(name,function(el) {me.setProperty(name, el.value);});
				}
			);
		  },
		  setProperty: function(name,value) {
			if (name == 'minutes') {this.minutes = value;}
			if (name == 'hours') {this.hours = value;}
			if (name == 'dayOfMonth') {this.dayOfMonth = value;}
			if (name == 'dayOfWeek') {this.dayOfWeek = value;}
			this.show();
		  },
		  getProperty: function(name) {
			if (name == 'minutes') {return this.minutes;}
			if (name == 'hours') {return this.hours;}
			if (name == 'dayOfMonth') {return this.dayOfMonth;}
			if (name == 'dayOfWeek') {return this.dayOfWeek;}
		  },
		box:function(title,obj) {
			var me = this;
			var every = new Element('input',{type:'radio',name:this.elementId+'radio'+obj.name,id:this.elementId+'every'+obj.name}).observe('click',
				function(evt){me.selectEvery(obj.name);}
			);
			var choose = new Element('input',{type:'radio',name:this.elementId+'radio'+obj.name,id:this.elementId+'choose'+obj.name}).observe('click',
				function(evt){obj.selectedIndex = (obj.selectedIndex || 0);me.selectChoose(obj.name);}
			);
			var everyLabel = new Element('label',{'for':this.elementId+'every'+obj.name}).update("Tous");
			var element = new Element('div',{'class':'box'}).insert(
				new Element('h5').update(title)
			).insert(
				new Element('br')
			).insert(
				every
			).insert(
				everyLabel
			).insert(
				new Element('br')
			).insert(
				choose
			).insert(
				new Element('label',{'for':this.elementId+'choose'+obj.name}).update("Choisir")
			).insert(
				new Element('br')
			).insert(obj);
			function sameName(name){return name == obj.name;}
			if (undefined != this.noEvery.find(sameName)){
				every.setAttribute('disabled',true);
				every.addClassName('partiallyhidden');
				everyLabel.setAttribute('disabled',true);
				everyLabel.addClassName('partiallyhidden');
				choose.checked = true;
			}
			return element;
		},
		populateMultiSelect:function(name,data) {
			var element = new Element('select',{'name':name});
			data.each(
				function(entry){
					element.insert(
						new Element('option',{'value':entry.key}).update(entry.value)
					);
				}
			);
			return element;
		},
		  buildUI:function(){
			var allMinutes = new Hash();
			$R(0,59).each(function(i){if ( i % 15 == 0){allMinutes.set(""+i,(i<10 ? "0" : "")+i)}});
			var allHours = new Hash();
			$R(0,23).each(function(i){allHours.set(""+i,(i<10 ? "0" : "")+i+"h")});
			var allDom = new Hash();
			$R(1,31).each(function(i){allDom.set(""+i,(i<10 ? "0" : "")+i)});
			var minutes = this.populateMultiSelect('minutes',allMinutes);
			var hours = this.populateMultiSelect('hours',allHours);
			var dayOfMonth = this.populateMultiSelect('dayOfMonth',allDom);
			var dayOfWeek = this.populateMultiSelect('dayOfWeek',$H({2:'Lundi',3:'Mardi',4:'Mercredi',5:'Jeudi',6:'Vendredi',7:'Samedi',1:'Dimanche'}));
			this.ui = new Element('div',{'class':'even','style':'min-height:8em;'})
			.insert(
				this.box("Jour du mois", dayOfMonth)
			).insert(
				this.box("Jour de semaine", dayOfWeek)
			).insert(
				this.box("Heure", hours)
			).insert(
				this.box("Minute", minutes)
			);
			this.element.insert({before:this.ui});
		  }
	}),
	crons:0,
	hookCronExpression:function(element) {
		element.addClassName('justhidden');
		var ui = new ETUDE.CronUI(element,ETUDE.crons++);
	},
	setPassword:function(element) {
		var otherPass = new Element('input',{'type':'password','value':element.value});
		var msg = new Element('span',{'style':'padding:3px;'}).update('&nbsp;');
		element.setAttribute('type','password');
		element.up().insert(new Element('br')).insert(otherPass).insert("&nbsp;(V&eacute;rification)").insert(msg);
		var checkSame = function(evt){
			if (element.value!=otherPass.value){
				msg.setStyle("color:red;");
				msg.update("MOTS DE PASSE DIFFERENTS!");
				msg.pulsate();
				evt.stop();
			} else {
				msg.update("");
			}
		}
		otherPass.observe('change',checkSame);
		otherPass.observe('blur',checkSame);
		element.up('form').observe('submit',checkSame);
	},
	setUiTheme:function(element) {
		var combo = new Element('select',{'name':element.name+"_combo"});
		combo.insert(new Element('option',{'value':"compact"}).update('Compact'));
		combo.insert(new Element('option',{'value':"classic"}).update('Classique'));
		var read = function(evt){
			combo.value = element.value;
		}
		read();
		element.up().insert(combo);
		var sync = function(evt){
			element.value = combo.value;
		}
		element.addClassName('hidden');
		combo.observe('change',sync);
		element.observe('change',read);
		combo.observe('blur',sync);
		element.up('form').observe('submit',sync);
	},
	setEmail:function(element) {
		var msg = new Element('span',{'style':'padding:3px;'}).update('&nbsp;');
		element.up().insert(msg);
		element.setStyle("width:25em;");
		var validateEmail = function(field) {
			var regex=/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i;
			return (regex.test(field)) ? true : false;
		};
		var validateMultipleEmailsCommaSeparated = function (value) {
			var result = value.split(/,|;/);
			for(var i = 0;i < result.length;i++)
			if(!validateEmail(result[i])) 
					return false;               
			return true;
		};
		var checkEmail = function(evt){
			var str =element.value;
			if (str==null || str=="" || validateMultipleEmailsCommaSeparated(str)){
				msg.update("");
			}else{
				msg.setStyle("color:red;");
				msg.update("EMAIL(s) INCORRECT(s)!");
				msg.pulsate();
				evt.stop();
			}
		};
		element.observe('change',checkEmail);
		element.up('form').observe('submit',checkEmail);
	},
	lockUI:function(){
		$$("div.nav","a","#personalBar","#header","#headerback","button",".memusage",".taches-title",".taches-detail").each(function(it){it.addClassName('hidden');});
		Modalbox.deactivate();
	},
	unlockUI:function(){
		$$("div.nav","a","#personalBar","#header","#headerback","button",".memusage",".taches-title",".taches-detail").each(function(it){it.removeClassName('hidden');});
		Modalbox.activate();
	},
	hookServerStatus:function(element) {
			var url = element.getAttribute('monitorurl');
			var homeurl = element.getAttribute('homeurl');
			var interval = element.getAttribute('interval');
			var statusName = element.getAttribute('statusName');
			var statusNode = element.getAttribute('statusNode');
			var noLockTheUI = element.hasClassName('nolockui');
			var status = new Element('span');
			var icon = new Element('span',{'class':'noimg'});
			interval = (interval != null ? (+interval) : 5);
			var oldStatus = 0;
			checkServer = function(){
				new Ajax.Request(url, {
				  method: 'get',
				  onComplete: function(transport) {
					if (200 == transport.status){
						if ((oldStatus !=200 && oldStatus !=0) || transport.responseText.indexOf('Connexion') != -1){
							window.location.href = homeurl;
						} else {
							status.innerHTML= transport.responseText;
							icon.className= 'checked';
							ETUDE.unlockUI();
							window.location.href = homeurl;
						}
					} else if (404 == transport.status || 503 == transport.status) {
					  status.innerHTML= 'En cours...';
					  icon.className= 'pending';
					  ETUDE.lockUI();
					} else if (301 == transport.status) {
					  window.location.reload();
					} else {
					  status.innerHTML= ' ';
					  icon.className= 'busy';
					  ETUDE.lockUI();
					}
					oldStatus = transport.status;
				  }
				});
			}
			if (null!=url && null!=homeurl) {
				var statusNode = new Element(statusNode || 'h3').update(statusName || "Etat du serveur : ");
				statusNode.insert(icon);
				icon.insert(status);
				element.insert({after: statusNode});
				checkServer();
				new PeriodicalExecuter(checkServer, interval);
			}
	},
	hookClientMsg:function(element) {
		element.observe('click',function(event){
			var msgElement = $(element.getAttribute('showin'));
			var lockTheUI = element.hasClassName('lockui');
			if (msgElement!=null){
				var icon = new Element('span',{id:'icon','class':'busy'});
				msgElement.insert(icon);
				msgElement.insert(new Element('strong').update(element.getAttribute('msg')));
				msgElement.removeClassName('hidden');
			}
			element.up("div.dialog").addClassName('hidden');
			if (lockTheUI){ETUDE.lockUI();}
		});
	},
	setHides:function(element) {
		var toBeHidden = $A(element.getAttribute('rel').split(','));
		element.observe('click', function(event){
			toBeHidden.each(function(item){
				$(item).addClassName('hidden');
			});
		});
	},
	setShows:function(element) {
		var toBeShown = $A(element.getAttribute('rel').split(','));
		element.observe('click', function(event){
			toBeShown.each(function(item){
				$(item).removeClassName('hidden');
			});
		});
	},
	hookAddFavorite:function(element) {
		var h1 = element.down('h1');
		if (h1!=null){
			var favUrl = document.location.href;
			var baseUrl = favUrl.split('?')[0];
			var params = $H((favUrl.indexOf('?') >=0 ? favUrl.split('?')[1] : "").toQueryParams());
			baseUrl = (baseUrl.startsWith('https') ? baseUrl.sub('https://','') : baseUrl.sub('http://',''))
			baseUrl = baseUrl.substr(baseUrl.indexOf('/'));
			if (null == h1.up('#MB_content')){
				params.unset('offset');
				params.unset('max');
				favUrl = baseUrl;
				if (params.keys().size() > 0) {favUrl+= "?"+params.toQueryString();}
				var targetUrl = "/setting/ajoutfavoris";
				var addfav = new Element('button',{'class':'partiallyhidden favadd modal',modalwidth:400,title:"Ajouter aux favoris"}).update(new Element('span',{'class':'favoris'}));
				var favForm = new Element('form',{action:targetUrl,'class':'pack','method':'post'}).insert(
					new Element('input',{type:'hidden',name:'label', value:h1.innerHTML})
				).insert(
					new Element('input',{type:'hidden',name:'nostyle', value:true})
				).insert(
					new Element('input',{type:'hidden',name:'url', value:favUrl})
				).insert(addfav);
				h1.insert({before:favForm});
				addfav.observe('mouseout', function(event){addfav.addClassName('partiallyhidden');});
				addfav.observe('mouseover', function(event){addfav.removeClassName('partiallyhidden');});
			}
		}
	},
	selectCurrentUrl:function(a) {
		if (a!=null){
			var baseUrl = document.location.href;
			baseUrl = (baseUrl.startsWith('https') ? baseUrl.sub('https://','') : baseUrl.sub('http://',''))
			baseUrl = baseUrl.substr(baseUrl.indexOf('/'));
			if (encodeURI(a.getAttribute("href"))==baseUrl){
				a.addClassName("selected");
			}
		}
	},
	hideNavbar:function(element) {
		if (null != element.up('#MB_content')){
			element.addClassName('hidden');
		}
	},
	setTabs:function(element) {
		new Control.Tabs(element); 
		
	},
	evalJs:function(element) {
		if (null != element.innerHTML){
			eval(element.innerHTML);
		}
	},
	responder:{
	  onCreate: function(request) {
			this.url = request.url;
			if (this.url.indexOf("preview=true")>0){
				ETUDE.isPreviewRequest = true;
			}
	  },
	  onComplete: function(response) {
		if (!ETUDE.isPreviewRequest && !ETUDE.disableModalHandleRedirect && response.transport.responseText.indexOf('loginBox')!=-1){
			Modalbox.hide();
			document.location.href = this.url.sub('?nostyle=true', '');
		}
		ETUDE.disableModalHandleRedirect = false;
	  }
	},
	hookEvents:function() {
		var featureId = 1;
		var mapping = new Hash();
		mapping.set('.tabs', ETUDE.setTabs);
		mapping.set('.nolinks', ETUDE.nolinks);
		mapping.set('.hides', ETUDE.setHides);
		mapping.set('.shows', ETUDE.setShows);
		mapping.set('.ellipsis', ETUDE.ellipsis50);
		mapping.set('.ellipsis30', ETUDE.ellipsis30);
		mapping.set('.ellipsis60', ETUDE.ellipsis60);
		mapping.set('div.nav', ETUDE.hideNavbar);
		mapping.set('h1', ETUDE.ellipsis90);
		mapping.set('div.body', ETUDE.hookAddFavorite);
		mapping.set('.message', ETUDE.appear);
		mapping.set('.warn', ETUDE.appear);
		mapping.set('.error', ETUDE.appear);
		mapping.set('div.errors', ETUDE.appear);
		mapping.set('#appMsg', ETUDE.appear);
		mapping.set('a.disabled', ETUDE.disableLink);
		mapping.set('.evaljs', ETUDE.evalJs);
		mapping.set('div.databar', ETUDE.setDatabar);
		mapping.set('.highlight', ETUDE.hookHighlight);
		mapping.set('a.modal', ETUDE.setModal);
		mapping.set('#MB_content th.sortable a', ETUDE.setModal);
		mapping.set('#MB_content a.step', ETUDE.setModal);
		mapping.set('input[type="submit"].modal', ETUDE.setInputModal);
		mapping.set('button.modal', ETUDE.setInputModal);
		mapping.set('input[type="text"].autocomplete', ETUDE.setAutoComplete);
		mapping.set('a.preview', ETUDE.addPreview);
		mapping.set('.selectall', ETUDE.selectall);
		mapping.set('.selectnone', ETUDE.selectnone);
		mapping.set('td.checkfix input[type="checkbox"]', ETUDE.hookHighlightRow);
		mapping.set('tr.clickable', ETUDE.hookTrClickable);
		mapping.set('input[type="submit"].danger', ETUDE.hookConfirmOnDanger);
		mapping.set('a.danger', ETUDE.hookConfirmOnDanger);
		mapping.set('li.clickable input[type="radio"]', ETUDE.hookHighlightListItem);
		mapping.set('li.clickable', ETUDE.hookLiClick);
		mapping.set('.serverstatus', ETUDE.hookServerStatus);
		mapping.set('.popupaction', ETUDE.hookPopupAction);
		mapping.set('.clientmsg', ETUDE.hookClientMsg);
		mapping.set('.DbBackupJob_cron', ETUDE.hookCronExpression);
		mapping.set('.SendBackupJob_cron', ETUDE.hookCronExpression);
		mapping.set('.SendBackupJob_to', ETUDE.setEmail);
		mapping.set('.ui_theme', ETUDE.setUiTheme);
		mapping.set('.ui_theme_personal', ETUDE.setUiTheme);
		mapping.set('.gmail_Pass', ETUDE.setPassword);
		mapping.set('#leftmenu p a', ETUDE.selectCurrentUrl);
		mapping.each(function(entry) {
			$$(entry.key).each(function(element){
				ETUDE.runOnce(featureId, entry.value, element);
			});
			featureId++;
		});
	},
}
Event.observe(document, "dom:loaded", ETUDE.hookEvents);
Ajax.Responders.register(ETUDE.responder);
if('serviceWorker' in navigator) {
    navigator.serviceWorker.getRegistrations().then(

        function(registrations) {

            for(let registration of registrations) {
                registration.unregister();

            }

        });
}
