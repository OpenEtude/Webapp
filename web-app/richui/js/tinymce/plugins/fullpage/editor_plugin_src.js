/**
 * $Id: editor_plugin_src.js 520 2008-01-07 16:30:32Z spocke $
 *
 * @author Moxiecode
 * @copyright Copyright ? 2004-2008, Moxiecode Systems AB, All rights reserved.
 */

(function() {
	tinymce.create('tinymce.plugins.FullPagePlugin', {
		init : function(ed, url) {
			var t = this;

			t.editor = ed;

			// Register commands
			ed.addCommand('mceFullPageProperties', function() {
				ed.windowManager.open({
					file : url + '/fullpage.htm',
					width : 430 + parseInt(ed.getLang('fullpage.delta_width', 0)),
					height : 495 + parseInt(ed.getLang('fullpage.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url,
					head_html : t.head
				});
			});

			// Register buttons
			ed.addButton('fullpage', {title : 'fullpage.desc', cmd : 'mceFullPageProperties'});

			ed.onBeforeSetContent.add(t._setContent, t);
			ed.onGetContent.add(t._getContent, t);
		},

		getInfo : function() {
			return {
				longname : 'Fullpage',
				author : 'Moxiecode Systems AB',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/fullpage',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		},

		// Private plugin internal methods

		_createSerializer : function() {
			return new tinymce.dom.Serializer({
				dom : this.editor.dom,
				apply_source_formatting : true
			});
		},

		_setContent : function(ed, o) {
			var t = this, sp, ep, c = o.content;

			// Parse out head, body and footer
			sp = c.indexOf('<body');
			if (sp == -1)
				sp = c.indexOf('<BODY');

			if (sp != -1) {
				sp = c.indexOf('>', sp);
				t.head = c.substring(0, sp + 1);

				ep = c.indexOf('</body', sp);
				if (ep == -1)
					ep = c.indexOf('</body', ep);

				o.content = c.substring(sp + 1, ep);
				t.foot = c.substring(ep);
			} else {
				t.head = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
				t.head += '\n<html>\n<head>\n<title>Untitled document</title>\n</head>\n<body>\n';
				t.foot = '\n</body>\n</html>';
			}
		},

		_getContent : function(ed, o) {
			var t = this;

			o.content = tinymce.trim(t.head) + '\n' + tinymce.trim(o.content) + '\n' + tinymce.trim(t.foot);
		}
	});

	// Register plugin
	tinymce.PluginManager.add('fullpage', tinymce.plugins.FullPagePlugin);
})();