package org.grails.taggable

class TagsTagLib {
    
    static namespace = 'tags'
    
	def editTags = {attrs->
        def type = grailsApplication.classLoader.loadClass(attrs.remove('clazz'))
        def object = attrs.remove('object')
		def tags = object.getTags()
		type.getAvailableTags().each{tag->
			out << g.checkBox(name:tag.name, value:tags.contains(tag.name))
			out << "<label for=\"${tag.name}\">"
			out << "<span class=\"tag\">"
			out << etude.traduction(name:tag.name, 'default':tag.name)
			out << "</span>"
			out << "</label>"
			out << "<br/>"
		}
	}
	def showTags = {attrs,body->
        def type = grailsApplication.classLoader.loadClass(attrs.remove('clazz'))
        def object = attrs.remove('object')
		def tags = object.getTags()
		out << body()
		type.getAvailableTags().findAll{tags.contains(it.name)}.each{tag->
			out << "<span class=\"tag\">"
			out << etude.traduction(name:tag.name, 'default':tag.name)
			out << "</span>"
		}
	}
	def listTags = {attrs->
		def tags = attrs.remove('tags')
		tags.each{tag->
			out << "<span class=\"tag\">"
			out << etude.traduction(name:tag.name, 'default':tag.name)
			out << "</span>"
		}
	}
}