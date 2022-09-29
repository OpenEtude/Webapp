import org.springframework.beans.factory.InitializingBean

class TypeEcritureService implements InitializingBean {
    static transactional = true
	
	def grailsApplication
	
    def setting
	
	def g

    void afterPropertiesSet() {
        this.setting = grailsApplication.config.setting
        this.g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
    }	
	
	def xls2Libelles(file) {
		def afficheDansOperation = [:]
		[0,1,2,3].each{
			afficheDansOperation.put(
				g.message(code:"typeEcriture.afficheDansOperation.${it}"),
				it
			)
		}
		def libelleMap = ['libelles':[], 'rejets':[]]
		def lineNumberMap = [:]
		def xls = new SimpleXlsSlurper(file.inputStream)
		def fetch = {xls.rowCount > 1 ? (2..(xls.rowCount)) : []}
		def load = {domain,label->label ? domain.get(new Long(label.split(' - ')[0])) : null}
		def loadCompte = {label->label ? Compte.findByCode(label.split(' - ')[0]) : null}
		def parseCredit = {it == 'Cr\u00E9dit' ? true : false}
		def parseAffectable = {it.startsWith('Affect') ? true : false}
		def parseAfficheDansOperation = {afficheDansOperation.get(it) ?: 0}
		def find = {domain,label,finder->label ? domain."${finder}"(label) : null}
		xls.sheets("Libell\u00E9s")
		fetch().each{rowNum->
			def libelleEcriture = xls.valueAt("'Libell\u00E9s'!B${rowNum}")
			def typeEcriture = TypeEcriture.findByLibelleIlike(libelleEcriture) ?: new TypeEcriture()
			typeEcriture.properties = 
				[categorieEcriture : load(CategorieEcriture,xls.valueAt("'Libell\u00E9s'!A${rowNum}")),
				libelle : libelleEcriture,
				credit : parseCredit(xls.valueAt("'Libell\u00E9s'!C${rowNum}")),
				affectable : parseAffectable(xls.valueAt("'Libell\u00E9s'!D${rowNum}")),
				afficheDansOperation : parseAfficheDansOperation(xls.valueAt("'Libell\u00E9s'!E${rowNum}")),
				compteADebiter : loadCompte(xls.valueAt("'Libell\u00E9s'!F${rowNum}")),
				compteACrediter : loadCompte(xls.valueAt("'Libell\u00E9s'!G${rowNum}"))]
			if (typeEcriture.validate()){
				libelleMap.libelles << typeEcriture
			} else {
				libelleMap.rejets << typeEcriture
			}
			lineNumberMap.put(typeEcriture,rowNum)
		}
		return [libelles : libelleMap,lineNumbers:lineNumberMap]
	}
	def xlsTemplate(args) {
		def afficheDansOperation = [:]
		def afficheDansOperationReverse = [:]
		[0,1,2,3].each{
			afficheDansOperation.put(
				g.message(code:"typeEcriture.afficheDansOperation.${it}"),
				it
			)
			afficheDansOperationReverse.put(
				it,
				g.message(code:"typeEcriture.afficheDansOperation.${it}")
			)
		}
		def response = args.response
		def populate = args.populate
		response.setHeader("Content-disposition", "attachment; filename=ImportLibelles.xls")
		response.contentType = "application/vnd.ms-excel"
		def lovIndex = 1
		def nextNum = {def first = "'LOV'!\$A\$${lovIndex}";lovIndex += args["${it}"]?.size()-1;def result="${first}:\$A\$${lovIndex}";lovIndex++;result.toString()}
		def col = {"${it}2:${it}65536".toString()}
		def value = {"\$${it}\$2:\$${it}\$65536".toString()}
		def validationMap = [:]
		validationMap+={args.categorieEcriture.empty ? [:] : [(col("A")):nextNum('categorieEcriture')]}()
		validationMap+={args.credit.empty ? [:] : [(col("C")):nextNum('credit')]}()
		validationMap+={args.affectable.empty ? [:] : [(col("D")):nextNum('affectable')]}()
		validationMap+={args.afficheDansOperation.empty ? [:] : [(col("E")):nextNum('afficheDansOperation')]}()
		validationMap+={args.compteADebiter.empty ? [:] : [(col("F")):nextNum('compteADebiter')]}()
		validationMap+={args.compteACrediter.empty ? [:] : [(col("G")):nextNum('compteACrediter')]}()
		def workbook = new SimpleXlsBuilder().workbook(
			templateInputStream:args.templateInputStream
		) {
			sheet(name:"LOV",hidden:true){			
				args.categorieEcriture.each{row(0:"${it.id} - ${it.libelle}")}
				args.credit.each{row(0:it)}
				args.affectable.each{row(0:it)}
				args.afficheDansOperation.each{row(0:it)}
				args.compteADebiter.each{row(0:"${it.code} - ${it.libelle}")}
				args.compteACrediter.each{row(0:"${it.code} - ${it.libelle}")}
			}
			sheet(name:"Libell\u00E9s",validation:validationMap){
				if (populate) {
					row()
					TypeEcriture.list([sort:'id',order:'desc']).each{
						row(0:"${it.categorieEcriture.id} - ${it.categorieEcriture.libelle}",
						1:it.libelle,
						2:(it.credit ? 'Cr\u00E9dit':'D\u00E9bit'),
						3 : (it.affectable ? 'Affectable \u00E0 compte bancaire':'Non affectable \u00E0 compte bancaire'),
						4 : (afficheDansOperationReverse.get(it.afficheDansOperation ?: 0))
						)
					}
				}
			}
		}
		workbook.saveToOutput(response.outputStream,false)
	}
}
