/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @Scan plugin.
 */
var arkilogScannerJnlpPath = "";
function showScannerApplet(){
	if (scannerDiv.innerHTML != "") {
		scannerDiv.innerHTML = null;
	} else {
		var htmlStr = "<object type=\"application/x-java-applet\"  width=\"750\" height=\"40\">";
		htmlStr+="<param name=\"code\" value=\"com.arkilog.ria.tools.scanner.MainApp.class\"/>";
		htmlStr+="<param name=\"jnlp_href\" value=\""+arkilogScannerJnlpPath+"\"/>";
		htmlStr+="<param name=\"name\" value=\"Scanner\"/>";
		htmlStr+="</object>";
		scannerDiv.innerHTML = htmlStr;
	}
}
(function()
{
	var scanCmd =
	{
		modes : { wysiwyg:1, source:1 },

		exec : function( editor )
		{
			showScannerApplet();
			this.toggleState();
			// Toggle button label.
			var button = this.uiItems[ 0 ];
			var label = ( this.state == CKEDITOR.TRISTATE_OFF )
				? 'Afficher le Scanner' : 'Masquer le Scanner';
			var buttonNode = editor.element.getDocument().getById( button._.id );
			buttonNode.getChild( 1 ).setHtml( label );
			buttonNode.setAttribute( 'title', label );
		}
	};

	var pluginName = 'ocrscanner';

	// Register a plugin named "Scan".
	CKEDITOR.plugins.add( pluginName,
	{
		init : function( editor )
		{
			var command = editor.addCommand( pluginName, scanCmd );
			command.modes = { wysiwyg : true };
			arkilogScannerJnlpPath = this.path+"../../../../applet/ocr.jnlp"
			editor.ui.addButton( 'Scan',
				{type:'toggle',
					label : 'Afficher le Scanner',
					command : pluginName,
					icon: this.path + 'images/scanner.png'
				});
		}
	});
})();
