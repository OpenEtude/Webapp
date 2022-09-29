class MyModalTagLib {

    static namespace = "mymodal"
	
	def grailsUrlMappingsHolder

    def createLink = { attrs, body -> 
        def params = attrs.params && attrs.params instanceof Map ? attrs.remove('params') : [:]
		params.nostyle=true
		def title = attrs.title ? attrs.remove('title') : attrs.linkname
		def inlineId = attrs.inlineId ? attrs.remove('inlineId'): null
		def width = attrs.width ? attrs.remove('width') : '600'
		def height = attrs.height ? attrs.remove('height') : null
		def sclass = attrs.sclass ? attrs.remove('sclass') : null
		def evalScript = ((attrs.evalScript ? attrs.remove('evalScript') : null) == "true")
		def style = attrs.style ? attrs.remove('style') : null
		def mapping = grailsUrlMappingsHolder.getReverseMapping(attrs['controller'], attrs['action'],params)
        def url = mapping.createURL(attrs['controller'], attrs['action'], params, request.characterEncoding)
		if (inlineId) {
			out << """
			<div class="hidden"><div id="${inlineId}">${g.render(template:'/'+attrs['controller']+'/'+ attrs['action'], model:['params':params])}</div></div>
			"""
			inlineId = "\$('"+inlineId+"')"
		}
        out << """
		<a ${style?"style='"+style+"' ":""}href='${inlineId ?'#':url}' title='${title}' 
			onclick="\$('spinner').className='hidden';Modalbox.show(${inlineId ? inlineId : 'this.href'}, {title: this.title,${height?'height:'+height+",":''}width:${width},overlayOpacity:0.0,closeString: 'Fermer',transitions:false,slideDownDuration:0,slideUpDuration:0,overlayDuration:0${evalScript ? ', evalScripts:true' : ''}}); return false;\$('spinner').className='spinner';"><span ${sclass?"class='"+sclass+"' ":""}></span>${body()} ${attrs['linkname']?:''}</a>"""
    }
    
    def includes = {
        out << """
			<script type="text/javascript" src="${createLinkTo(dir:'js/include',file:'prototype.js')}"></script>
			<script type="text/javascript" src="${createLinkTo(dir:'js/include',file:'scriptaculous.js?load=effects')}"></script>
			<script type="text/javascript" src="${createLinkTo(dir:'js/include',file:'modalbox.js')}"></script>
			<link rel="stylesheet" href="${createLinkTo(dir:'css',file:'modalbox.css')}" type="text/css" media="screen" />
        """
    }
}

