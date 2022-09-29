import jxl.*
import jxl.write.*
import jxl.format.VerticalAlignment as VA


class ExcelWriter {

 static def writeSheet(filename, response, map, objects, sheetName) {
    response.setHeader("Content-disposition", "attachment; filename=${filename}.xls")
    response.contentType = "application/vnd.ms-excel"
	def out = response.outputStream
     // create our workbook and sheet
     def workbook = Workbook.createWorkbook(out)
	 addSheetToWorkBook(workbook, map, objects, safe(sheetName), 0)
     // close
     workbook.write()
     workbook.close()
	}
 static def writeSheets(filename, response, maps, objectss, sheetNames) {
    response.setHeader("Content-disposition", "attachment; filename=${filename}.xls")
    response.contentType = "application/vnd.ms-excel"
	def out = response.outputStream
     // create our workbook and sheet
     def workbook = Workbook.createWorkbook(out)
	 sheetNames.eachWithIndex{sheetName, i ->
	 addSheetToWorkBook(workbook, maps[i], objectss[i], safe(sheetName), i)
	 }
     // close
     workbook.write()
     workbook.close()
	}

	static safe(sheetName){
        if (!sheetName){
            return "Nouvelle feuille"
        }
        def _sheetName = sheetName.replaceAll(" ", "_").replaceAll("\\W", "-").replaceAll("_", " ").split('-').findAll{it}.join('-')
		(_sheetName?.size() >=31) ? _sheetName[0..30] : _sheetName
	}
 
 static def addSheetToWorkBook(workbook, map, objects, sheetName, index) {
 
	def font9plain = new WritableFont(WritableFont.ARIAL, 9,
					WritableFont.NO_BOLD);

	def font10bold = new WritableFont(WritableFont.ARIAL, 10,
					WritableFont.BOLD);

	def format10bold = new WritableCellFormat(font10bold);

	def format9plain = new WritableCellFormat(font9plain);
	format9plain.wrap = true
	format9plain.verticalAlignment = VA.CENTRE
	def floatFormat = new WritableCellFormat(font9plain, new NumberFormat("###,##0.00;[RED]-###,##0.00"))
	floatFormat.verticalAlignment = VA.CENTRE
	def integerFormat = new WritableCellFormat(font9plain, NumberFormats.INTEGER)
	integerFormat.verticalAlignment = VA.CENTRE
	def dateFormat = new WritableCellFormat(font9plain, new DateFormat("dd/MM/yyyy"))
	dateFormat.verticalAlignment = VA.CENTRE

    def sheet = workbook.createSheet(safe(sheetName), index)
	
     // walk through our map and write out the headers
     def c = 0
     map.each() { k, v ->
		def header = v.toString() ? v.toString() : ""
		def hCell = new Label(c, 0, header)
		hCell.setCellFormat(format10bold);
		def maxWidth = header.length() + 1
		sheet.setColumnView(c,maxWidth)
         // write out our header
         sheet.addCell(hCell)
     
         // write out the value for each object
         def r = 1
         objects.each() { o ->
			def value = o[k]
             if (value) {
				def cell = null
                 if (value instanceof java.lang.Number) {
                    cell = new Number(c, r, value, (value instanceof Integer ? integerFormat : floatFormat))
					sheet.setColumnView(c, Math.max(11, maxWidth))
                 } else if (value instanceof java.util.Date) {
                    cell = new DateTime(c, r, value, dateFormat)
					sheet.setColumnView(c, Math.max(10, maxWidth))
                 } else {
					def str = value.toString()
					def retCharIdx = str.indexOf('\n')
					if (maxWidth < str.length() && retCharIdx==-1){
						maxWidth = str.length() + 3
						sheet.setColumnView(c,maxWidth)
					} else if (retCharIdx >= 0) {
						def maxLineWidth = str.split('\n').max{it.size()}.size()
						if (maxWidth < maxLineWidth) {
							maxWidth = maxLineWidth + 3
							sheet.setColumnView(c,maxWidth)
						}
					}
					if (value instanceof String && str.startsWith('_')) {
						str = str.replace("_",'')
						cell = new Label(c, r, str)
						cell.setCellFormat(format10bold);
					} else {
						cell = new Label(c, r, str)
						cell.setCellFormat(format9plain);
					}
                 }
				sheet.addCell(cell)
             }
             r++
         }
         c++
     }

}
}
