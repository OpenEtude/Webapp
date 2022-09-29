/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	config.extraPlugins = 'ocrscanner';
	config.language = 'fr';
	config.uiColor = '#d4d0c8';
	config.height = "420px";
	config.fontSize_defaultLabel = '12px';
	config.font_defaultLabel = 'Times New Roman';
	config.pasteFromWordCleanupFile = true;
	config.tabSpaces = 4;
	config.skin = 'office2003';
	config.disableNativeSpellChecker = false;
	config.removePlugins = 'elementspath,scayt,menubutton,contextmenu'; 
	config.font_style =
    {
        element		: 'span',
        styles		: { 'font-family' : '#(family)' },
        overrides	: [ { element : 'font', attributes : { 'face' : null } } ]
    };
	config.fontSize_style =
	{
		element		: 'span',
		styles		: { 'font-size' : '#(size)' },
		overrides	: [ { element : 'font', attributes : { 'size' : null } } ]
	};
	config.startupFocus = true;
	config.toolbar = [['Print','Cut','Copy','Paste','Undo','Redo','-','SelectAll','RemoveFormat','-','Find','Replace'],['Bold','Italic','Underline','StrikeThrough'],['OrderedList','UnorderedList','-','Outdent','Indent'],	['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull','Font','FontSize'],['Table','Rule','SpecialChar','PageBreak'],
['TextColor','BGColor', 'Preview','SpellChecker','Maximize','LayoutFlowRTL','Scan']];

};
