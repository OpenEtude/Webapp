            
class TypeEcritureGroupementRelController {
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max)params.max = 20
        [ typeEcritureGroupementRelList: TypeEcritureGroupementRel.list( params ) ]
    }

    def show = {
        [ typeEcritureGroupementRel : TypeEcritureGroupementRel.get( params.id ) ]
    }

    def delete = {
        def typeEcritureGroupementRel = TypeEcritureGroupementRel.get( params.id )
        if(typeEcritureGroupementRel) {
            typeEcritureGroupementRel.delete()
            flash.message = "Groupement ${params.id} supprim&eacute;."
            redirect(action:list)
        }
        else {
            flash.message = "Groupement introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def typeEcritureGroupementRel = TypeEcritureGroupementRel.get( params.id )

        if(!typeEcritureGroupementRel) {
                flash.message = "Groupement introuvable avec identifiant ${params.id}"
                redirect(action:list)
        }
        else {
            return [ typeEcritureGroupementRel : typeEcritureGroupementRel ]
        }
    }

    def update = {
        def typeEcritureGroupementRel = TypeEcritureGroupementRel.get( params.id )
        if(typeEcritureGroupementRel) {
             typeEcritureGroupementRel.properties = params
            if(typeEcritureGroupementRel.save()) {
                flash.message = "Groupement ${params.id} mis &agrave; jour."
                redirect(action:show,id:typeEcritureGroupementRel.id)
            }
            else {
                render(view:'edit',model:[typeEcritureGroupementRel:typeEcritureGroupementRel])
            }
        }
        else {
            flash.message = "Groupement introuvable avec identifiant ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def typeEcritureGroupementRel = new TypeEcritureGroupementRel()
        typeEcritureGroupementRel.properties = params
        return ['typeEcritureGroupementRel':typeEcritureGroupementRel]
    }

    def save = {
        def typeEcritureGroupementRel = new TypeEcritureGroupementRel()
        typeEcritureGroupementRel.properties = params
        if(typeEcritureGroupementRel.save()) {
            flash.message = "Groupement ${typeEcritureGroupementRel.id} cr&eacute;e dans la base."
            redirect(action:show,id:typeEcritureGroupementRel.id)
        }
        else {
            render(view:'create',model:[typeEcritureGroupementRel:typeEcritureGroupementRel])
        }
    }

}
