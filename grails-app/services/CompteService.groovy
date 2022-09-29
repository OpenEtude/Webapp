import org.springframework.beans.factory.InitializingBean

class CompteService implements InitializingBean {
    static transactional = true
	
	def grailsApplication
	
    def setting
	
	def g

    void afterPropertiesSet() {
        this.setting = grailsApplication.config.setting
        this.g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
    }	
	
	def xls2PlanComptable(file) {
		def planComptableMap = ['planComptable':[], 'rejets':[]]
		def lineNumberMap = [:]
		def xls = new SimpleXlsSlurper(file.inputStream)
		def fetch = {xls.rowCount > 1 ? (2..(xls.rowCount)) : []}
		def childrenComptes = [:]
		def handleOrphans = {compte,codeRattachement->
			def orphanList = childrenComptes.get(codeRattachement)
			if (!orphanList) {orphanList = []; childrenComptes.put(codeRattachement, orphanList)}
			orphanList << compte
			null
		}
		def loadCompteRattachement = {compte,code->code ? (Compte.findByCode(code) ?: handleOrphans(compte,code)) : null}
		def find = {domain,label,finder->label ? domain."${finder}"(label) : null}
		def comptes = []
		xls.sheets("Plan Comptable")
		fetch().each{rowNum->
			def codeCompte = xls.valueAt("'Plan Comptable'!B${rowNum}")
			def codeCompteRattachement = xls.valueAt("'Plan Comptable'!A${rowNum}")
			if (codeCompte instanceof Double){codeCompte = codeCompte.intValue().toString()}
			if (codeCompteRattachement instanceof Double){codeCompteRattachement = codeCompteRattachement.intValue().toString()}
			def libelleCompte = xls.valueAt("'Plan Comptable'!C${rowNum}")
			def descriptionCompte = xls.valueAt("'Plan Comptable'!D${rowNum}")
			def compte = Compte.findByCodeIlike(codeCompte) ?: new Compte(code:codeCompte)
			compte.properties = [
				libelle:libelleCompte,
				description:descriptionCompte,
				compteDeRattachement : loadCompteRattachement(compte, codeCompteRattachement)
			]
			comptes << compte
			lineNumberMap.put(compte,rowNum)
		}
		comptes.each{compte->
			if (compte.validate()){
				(childrenComptes.get(compte.code) ?: []).each{childCompte->
					compte.addToComptes(childCompte)
				}
				planComptableMap.planComptable << compte
			} else {
				planComptableMap.rejets << compte
			}
		}
		return [planComptable : planComptableMap,lineNumbers:lineNumberMap]
	}
	def xlsTemplate(args) {
		def response = args.response
		def populate = args.populate
		response.setHeader("Content-disposition", "attachment; filename=ImportPlanComptable.xls")
		response.contentType = "application/vnd.ms-excel"
		def lovIndex = 1
		def nextNum = {def first = "'LOV'!\$A\$${lovIndex}";lovIndex += args["${it}"]?.size()-1;def result="${first}:\$A\$${lovIndex}";lovIndex++;result.toString()}
		def col = {"${it}2:${it}65536".toString()}
		def value = {"\$${it}\$2:\$${it}\$65536".toString()}
		def validationMap = [:]
		def workbook = new SimpleXlsBuilder().workbook(
			templateInputStream:args.templateInputStream
		) {
			sheet(name:"LOV",hidden:true){			
			}
			sheet(name:"Plan Comptable",validation:validationMap){
				if (populate) {
					row()
					Compte.list([sort:'code',order:'asc']).each{
						row(0:it.compteDeRattachement?.code,
						1:it.code,
						2:it.libelle,
						3:it.description
						)
					}
				}
			}
		}
		workbook.saveToOutput(response.outputStream,false)
	}
}
