/*
Copyright 2009 Yellow Snow 

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. You may obtain a copy of 
the License at 

	http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
License for the specific language governing permissions and limitations under 
the License. 
*/
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.hssf.usermodel.DVConstraint
import org.apache.poi.hssf.usermodel.HSSFDataValidation
import org.apache.poi.hssf.usermodel.DVConstraint
import org.apache.poi.hssf.util.CellReference
//DATA_TYPE_LIST 

import org.apache.poi.ss.usermodel.WorkbookFactory
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.ss.util.CellRangeAddressList

import groovy.util.BuilderSupport

import java.io.IOException
import java.io.OutputStream
import java.math.BigDecimal
import java.util.Map
import java.text.DateFormat

public class SimpleXlsBuilder extends BuilderSupport {
	static {
		def oldWrite = HSSFWorkbook.metaClass.getMetaMethod("write", [OutputStream] as Class[])
		HSSFWorkbook.metaClass.autoSizeAndWrite = { OutputStream out,boolean resize=false ->
			if (resize){
				(0..(delegate.numberOfSheets -1)).each{index->
					def sheet = delegate.getSheetAt(index)
					def columnIndexes = new HashSet()
					sheet.each{row->
						row.each{cell->
							columnIndexes << cell.columnIndex
						}
					}
					columnIndexes.each{sheet.autoSizeColumn(it);}
				}
			}
			return oldWrite.invoke(delegate, out)
		}
		HSSFWorkbook.metaClass.saveToFile = {fileName,boolean resize=false ->
			new File(fileName).delete()
			def fileOut = new FileOutputStream(fileName)
			delegate.autoSizeAndWrite(fileOut,resize)
			fileOut.close()
		}
		HSSFWorkbook.metaClass.saveToOutput = {fileOut,boolean resize=false ->
			delegate.autoSizeAndWrite(fileOut,resize)
			fileOut.close()
		}
	}

	def workbook
	def currentSheet
	def currentRow
	def currentCell
	def sheetNum = 0
	def rowNum = -1
	def cellNum = 0
	def formulaIndex = 1
	def x = 0
	def y = 0
	def dateFormat = DateFormat.getDateInstance(DateFormat.SHORT).toPattern()

	@Override
	protected Object createNode(Object name) {
		createNode(name, [:])
	}

	@Override
	protected Object createNode(Object arg0, Object arg1) {
		return null;
	}
	private checkCurrentSheet(){
		if (!currentSheet) {
			currentSheet = workbook.numberOfSheets > sheetNum ? workbook.getSheetAt(sheetNum++) : null
			if (!currentSheet) {
				currentSheet = workbook.createSheet("Sheet ${sheetNum}")
				
			}
		}
		return currentSheet
	}

  private checkCurrentSheet = {sheetName ->
    currentSheet = workbook.getSheet(sheetName)
    if (!currentSheet) {
      currentSheet = workbook.createSheet(sheetName)
      sheetNum = workbook.getSheetIndex(sheetName)

    } else {

    }
    return currentSheet
  }
	private checkCurrentRow(){
		checkCurrentSheet()
		currentRow = currentSheet.getRow(rowNum)
		if (!currentRow) {
			currentRow = currentSheet.createRow(rowNum)
		}
		return currentRow
	}
	@Override
	protected Object createNode(Object name, Map map) {
		if (name.equals("sheet")) {
			if (map.name) {
				checkCurrentSheet(map.name)
			}
			checkCurrentSheet()
			rowNum = -1
			cellNum = 0
			def hidden = map["hidden"]==true;
			workbook.setSheetHidden(workbook.getSheetIndex(map.name),hidden)
			def validation = map["validation"];
				validation.each{column,constraint->
					def addressList = new CellRangeAddressList()
					def address = CellRangeAddress.valueOf(column)
					addressList.addCellRangeAddress(address)
					def dvConstraint = null
					println constraint
					if (constraint instanceof String || constraint instanceof GString) {
						def rName = workbook.createName();
						def formulaName ="formula${formulaIndex++}"
						rName.setNameName(formulaName);
						rName.setRefersToFormula(constraint); 
						dvConstraint = DVConstraint.createFormulaListConstraint(formulaName);
					} else {
						throw new RuntimeException("Unrecongnized data validation constraint [${constraint}] for range [${column}]")
					}
					def dataValidation = new HSSFDataValidation(addressList, dvConstraint);
					dataValidation.suppressDropDownArrow = false
					dataValidation.emptyCellAllowed = false
					dataValidation.showErrorBox = true
					dataValidation.showPromptBox = false
					currentSheet.addValidationData(dataValidation);
				}
			return currentSheet;
		} else if (name.equals("row")) {
			def y = map.remove('y')
			rowNum = y ?: rowNum+1
			cellNum = 0
			if (!map.empty) {
				map.each{k,v->
					if (k instanceof String) {
						createNode('cell', [ref:k,value:v])
					} else if (k instanceof Integer) {
						createNode('cell', [x:k,value:v])
					}
				}
			} else {
				checkCurrentRow()
			}
			return currentRow;
		} else if (name.equals("cell")) {
			if (map.ref) {
				def ref = new CellReference(map.ref)
				rowNum = ref.row ?: rowNum
				cellNum = ref.col ?: cellNum
				if (ref.sheetName) {
					checkCurrentSheet(ref.sheetName)
				}
			} else {
				rowNum = map.y ?: rowNum
				cellNum = map.x ?: cellNum
			}
			checkCurrentRow()
			def value = map['value'];
			currentCell = currentRow.getCell(cellNum)
			if (!currentCell) {
				currentCell = currentRow.createCell(cellNum)
			}
			currentCell.setCellValue(value)
			if (value) {
				def format = map['format']
				if (!format) {
					if (value instanceof Date) {
						format = dateFormat
					} else if (value instanceof Integer || value instanceof Long || value instanceof Short) {
						format = "(#,##0_);[Red](#,##0)"
					} else if (value instanceof Number) {
						format = "(#,##0.00_);[Red](#,##0.00)"
						value = value.doubleValue()
					} else {
						format = "text"
						currentCell.stringCellValue
					}
				}
				def cellStyle = workbook.createCellStyle()
				cellStyle.cloneStyleFrom(currentCell.getCellStyle())
				cellStyle.dataFormat = workbook.creationHelper.createDataFormat().getFormat(format)
				currentCell.setCellStyle(cellStyle)
				//println "CELL#${format}:${value}@[${rowNum},${cellNum}]"
			}
			cellNum = cellNum + 1
			return currentCell;
		}  else if (name.equals("workbook")) {
			def inputStream
			if (map.templateInputStream){
				inputStream = map.templateInputStream
			} else if (map.templateFileName) {
				inputStream = new FileInputStream(map.templateFileName)
			}
			if (inputStream) {
				workbook = WorkbookFactory.create(inputStream);
				
			} else {
				workbook = new HSSFWorkbook()
				
			}
			return workbook;
		} else throw new RuntimeException("Unrecognized node $name")
	}

	@Override
	protected Object createNode(Object arg0, Map arg1, Object arg2) {
	// TODO Auto-generated method stub
	return null;
	}

	@Override
	protected void setParent(Object parent, Object child) {
	}
}
