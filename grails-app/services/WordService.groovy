import org.apache.poi.hwpf.HWPFDocument
import org.apache.poi.hwpf.usermodel.DocumentPosition

class WordService {

   	static alignments = [0:'left',1:'center',2:'right',3:'justify']
   	static alignmentsx = ['justify' ,'center','left' ,'right' ]

	def servletContext

	def textService
	def toFacture(model){
		def response = model.response
		def document = new HWPFDocument(servletContext.getResourceAsStream( "/WEB-INF/facture.doc"));
 		def filename = model.filename ?: "Facture"
 		def cr  = document.range
 		def sentence = {text,bold,italic,size,c=null->
 			cr = new DocumentPosition(document,cr.endOffset)
 			cr = cr.insertAfter(text+'\r')
 			cr.bold = bold
 			cr.italic = italic
 			cr.fontSize = size * 2
 			if (c) {
 				c(cr)
 			}
 		}
        sentence((' '*30)+"FACTURE N° ${model.dossier.numeroDossier}",true,false,16)
        if (model.dossier.description)sentence((' '*30)+model.dossier.description,false,true,14)
        if (model.dossier.libelle)sentence((' '*30)+model.dossier.libelle,false,false,14)
        sentence('\r'*4,false,false,14)
        def dFormat = new java.text.DecimalFormat("###,##0.00 DHS")
        model.listeFrais.each{
        	def ecr = it.typeEcriture.libelle
        	ecr = ecr.toLowerCase().capitalize()
        	sentence( '- '+ecr.padRight(60,' ')+dFormat.format(it.montant).padLeft(20,' '),false,false,14)
        }

        def totalFrais = model.listeFrais.montant.sum() ?: 0
        def total = dFormat.format(totalFrais)
        sentence('\r',false,false,14)
        sentence("TOTAL".padRight(30,'=')+total.padLeft(23,'='),true,false,15)
        sentence('\r'*2,false,false,14)
        sentence("Arr\u00eat\u00e9 la pr\u00e9sente facture \u00e0 la somme de ${textService.toLetters(totalFrais).toUpperCase()} (${total}) toutes taxes comprises.",true,false,14)
        sentence('\r'*3,false,false,14)
        sentence((' '*90)+"${Setting.syssetting("city")}, le ${new java.text.SimpleDateFormat("dd MMMM yyyy").format(new Date())}",true,true,13)
		response.setHeader("Content-disposition", "attachment; filename=${filename}.doc")
		response.contentType = "application/vnd.ms-word"
		document.write(response.outputStream);
 	}

	def toPpe(model){
		def response = model.response
		def document = new HWPFDocument(servletContext.getResourceAsStream( "/WEB-INF/facture.doc"));
 		def filename = model.filename ?: "Ppe"
 		def cr  = document.range
 		def sentence = {text,bold,italic,size,c=null->
 			cr = new DocumentPosition(document,cr.endOffset)
 			cr = cr.insertAfter(text+'\r')
 			cr.bold = bold
 			cr.italic = italic
 			cr.fontSize = size * 2
 			if (c) {
 				c(cr)
 			}
 		}
        sentence((' '*30)+"Pr\u00e9l\u00e9vements Prix".toUpperCase(),true,false,16)
        sentence((' '*30)+"Dossier N° ${model.dossier.numeroDossier}",true,false,16)
        if (model.dossier.description)sentence((' '*30)+model.dossier.description,false,true,14)
        if (model.dossier.libelle)sentence((' '*30)+model.dossier.libelle,false,false,14)
        sentence('\r'*4,false,false,14)
        def dFormat = new java.text.DecimalFormat("###,##0.00 DHS")
        model.listePpe.each{
        	def ecr = it.typeEcriture.libelle
        	ecr = ecr.toLowerCase().capitalize()
        	sentence( '- '+ecr.padRight(60,' ')+dFormat.format(it.montant).padLeft(20,' '),false,false,14)
        }
        def totalPpe = model.listePpe.montant.sum() ?: 0
        def total = dFormat.format(totalPpe)
        sentence('\r',false,false,14)
        sentence("TOTAL".padRight(30,'=')+total.padLeft(23,'='),true,false,15)
        sentence('\r'*2,false,false,14)
        sentence("Arr\u00eat\u00e9 le pr\u00e9sent pr\u00e9l\u00e9vement de prix \u00e0 la somme de ${textService.toLetters(totalPpe).toUpperCase()} (${total}) toutes taxes comprises.",true,false,14)
        sentence('\r'*3,false,false,14)
        sentence((' '*90)+"${Setting.syssetting("city")}, le ${new java.text.SimpleDateFormat("dd MMMM yyyy").format(new Date())}",true,true,13)
		response.setHeader("Content-disposition", "attachment; filename=${filename}.doc")
		response.contentType = "application/vnd.ms-word"
		document.write(response.outputStream);
 	}
}
