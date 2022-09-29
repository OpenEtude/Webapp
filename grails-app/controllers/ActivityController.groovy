            
class ActivityController {
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [deleteAll:'POST', delete:'POST']

    static accessControl = {
		permission(perm: new EtudePerm('Activity', [ 'Liste' ]), only: ['list'])
		permission(perm: new EtudePerm('Activity', [ 'Consultation' ]), action: 'history')
        permission(perm: new EtudePerm('Activity', [ 'Suppression' ]), only: [ 'critereDeleteAll', 'deleteAll'])
	}
    def list = {
        if(!params.max)params.max = 20
		if(!params.sort){
			params.sort = "dateCreated"
			params.order = "desc" 
		}
		def actlist = Activity.list( params )
		def byType = [:]
		actlist.groupBy{it.controllerId}.each{k,v->
			def entities = [:]
			def ctrlName = g.message(code:"activity.controllerId.${k}")
			def domainClass = ParamUtils.prop2class(ctrlName)
			def idList = v.collect{ent->ent.entityId}.toString().replace('[','(').replace(']',')')
			def qry = "from "+domainClass+" $ctrlName where ${ctrlName}.id in "+ idList
			Activity.executeQuery(qry).each{entity->entities.put(entity.id, entity)}
			byType.put(k,entities)
		}
		def results = new ArrayList(actlist.groupBy{ParamUtils.trunc(it.dateCreated)}.entrySet())
		Collections.sort(results, {o1, o2 ->
			o2.key.compareTo(o1.key)
		} as Comparator)
        [ activityList: results,byType:byType ]
    }

    def history = {
		def controllerId = params.'controller.id' ? new Long(params.'controller.id') : null
		def entityId = params.'entity.id' ? new Long(params.'entity.id') : null
		def activityList = (controllerId && entityId) ?
				new java.util.TreeSet(Activity.findAllByControllerIdAndEntityId(controllerId, entityId, [sort:'dateCreated',order:'asc'])) :
					[]
		if (controllerId == Activity.DOSSIER) {
			activityList.addAll(Activity.executeQuery("""
			select a from Activity a, EcritureDossier ed 
			where ed.dossier.id=:dossierId
			and a.controllerId=:ecriture
			and a.entityId=ed.id
			""",[dossierId:entityId, ecriture:Activity.ECRITURE_DOSSIER]))
			activityList.addAll(Activity.executeQuery("""
			select a from Activity a, Acte ac 
			where ac.dossier.id=:dossierId
			and a.controllerId=:acte
			and a.entityId=ac.id
			""",[dossierId:entityId, acte:Activity.ACTE]))
		}
        [ titre: params.titre, controllerId : controllerId, entityId : entityId, activityType : g.message(code:"activity.controllerName.${controllerId}"), activityList: activityList ]
    }

    def delete = {
        def activity = Activity.get( params.id )
        if(activity) {
            activity.delete()
            flash.message = "Activity ${params.id} supprimé."
            redirect(action:list)
        } else {
            flash.message = "Activity introuvable avec identifiant ${params.id}"
            redirect(action:list)
        }
    }

    def critereDeleteAll = {
        [fin:new Date()-180]
    }

    def deleteAll = {
		def fin = toDate(params,'fin')
		def synthese = Ecriture.executeUpdate("""
		delete from Activity a
		where a.dateCreated < :fin  
		""",[fin:fin])
		flash.message = "$synthese enregistrements supprim&eacute;s"
		redirect(action:list)
	}

	def toDate(params,varName){
		new java.text.SimpleDateFormat('dd/MM/yyyy').parse(params.get(varName+'_day')+'/'+params.get(varName+'_month')+'/'+params.get(varName+'_year'))
	}
}
