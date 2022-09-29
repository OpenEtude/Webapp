import org.codehaus.groovy.grails.web.context.ServletContextHolder as SCH

class ParamUtils {
	static root(slash=false){
		return (slash?"/":"")
	}
	
	static trad(from,to,desc){
		def t = Traduction.findByName(from)
		if (!t) {
			println "${new Date()} Traduction not found [$from], let's create it..."
			new Traduction(name:from, trad:to, description:desc).save()
		} else if (!t.description || !t.description.equals(desc)) {
			t.description = desc
			t.save()
		}
	 }

	static keyword(q) {
		def k = (q?.toLowerCase())
		k = k ?: ''
		k.trim()
		return "%"+k.replaceAll('  ',' ').replace(' ','%').replace('+','%').replace('*','%')+"%"
	}
	static toDate(params,varName){
		try {
			return new java.text.SimpleDateFormat('dd/MM/yyyy').parse(params.get(varName+'_day')+'/'+params.get(varName+'_month')+'/'+params.get(varName+'_year'))
		} catch (ex) {
			return null
		}
	}
	static toParams(Date date, String varName, Map params){
			date = date ?: new Date()
			def day = new java.text.SimpleDateFormat('dd').format(date)
			def month = new java.text.SimpleDateFormat('MM').format(date)
			def year = new java.text.SimpleDateFormat('yyyy').format(date)
			params.put(varName+'_day',day)
			params.put( varName+'_month',month)
			params.put(varName+'_year',year)
	}
	static duration(date1, date2){
		if (!date1 && !date2) {return ''}
		def fmt = new java.text.SimpleDateFormat('dd.MM.yyyy')
		return fmt.format(date1)+ "_"+fmt.format(date2)
	}

	static format(g,value){
		if (value instanceof BigDecimal) {value = g.formatNumber(number:value, format:"###,##0.00 DH")}
		if (value instanceof Date) {value = g.formatDate(date:value, format:"dd/MM/yyyy")}
		if (value instanceof Boolean) {value = (value ? "Oui": "Non")}
		return value
	}
	static int getDaysBetween(java.util.Date d1, java.util.Date d2) {
		def c1 = Calendar.getInstance()
		def c2 = Calendar.getInstance()
		c1.time = d1
		c2.time = d2
		getDaysBetween(c1, c2)
	}
	static int getDaysBetween(java.util.Calendar d1, java.util.Calendar d2) {
	boolean after = false
    if (d1.after(d2)) {  // swap dates so that d1 is start and d2 is end
        java.util.Calendar swap = d1;
        d1 = d2;
        d2 = swap;
		after = true
    }
    int days = d2.get(java.util.Calendar.DAY_OF_YEAR) -
               d1.get(java.util.Calendar.DAY_OF_YEAR);
    int y2 = d2.get(java.util.Calendar.YEAR);
    if (d1.get(java.util.Calendar.YEAR) != y2) {
        d1 = (java.util.Calendar) d1.clone();
        while (d1.get(java.util.Calendar.YEAR) != y2) {
            days += d1.getActualMaximum(java.util.Calendar.DAY_OF_YEAR);
            d1.add(java.util.Calendar.YEAR, 1);
        } 
    }
    return (after ? 1 : -1) * days;
}
	static getMime(params){params.format == 'json' ? 'application/json' : 'text/xml'}
	static trunc(date){
		def fmt = new java.text.SimpleDateFormat('dd/MM/yyyy')
		fmt.parse(fmt.format(date))
	}
	
	static newDate(){
		return trunc(new Date())
	}
	
	static filter(params, filterName, c){
		def value = params.get(filterName)
		if (value) {
			try {return c(value)}catch(e){};
		}
	}
	static filters(params, filterMap){
		def values = [:]
		filterMap.each{k,v -> 
			def value = filter(params, k, v); 
			if (value) {
				values[k] = value
			} 
		}
		return values
	}
	static keep(params,list){def res = [:];params.each{if (it.key in list) res.put(it.key, it.value)};res}
	static paginate(params,also=[]){addSelect(params,params.findAll{it.key in (['q','max','sort','order','title'] + also)})}
	static sort(params,also=[]){addSelect(params,params.findAll{it.key in (['q','max','offset','title'] + also)})}
	static addSelect(params,map){map + (params.mode == 'select' ? [mode:'select', addTo: params.addTo, id : params.id]: [:])}
	static class2prop(domainClassName) {domainClassName?.size() > 0 ? domainClassName[0].toLowerCase()+domainClassName.substring(1) : null}
	static prop2class(controllerName) {controllerName?.size() > 0 ? controllerName[0].toUpperCase()+controllerName.substring(1) : null}
	static capitalize(controllerName) {controllerName?.size() > 0 ? controllerName[0].toUpperCase()+controllerName.toLowerCase().substring(1) : null}
}
