$(document).ready(function(){
	$('body').click(function(e){
    	if(!$(e.target).hasClass('tui-grid-cell-content') && !$(e.target).hasClass('tui-grid-cell')){
        	gridList.forEach(grid => {
				if(grid.hasOwnProperty('el')){
					let rowKey = grid.getFocusedCell().rowKey;
					let colNm = grid.getFocusedCell().columnName
					if(rowKey!=null) grid.finishEditing(rowKey,colNm);
				}
			});
		}
	});
	
	$('.btn').click(function(){
		gridList.forEach(grid => {
			if(grid.hasOwnProperty('el')){
				let rowKey = grid.getFocusedCell().rowKey;
				let colNm = grid.getFocusedCell().columnName
				if(rowKey!=null) grid.finishEditing(rowKey,colNm);	
			}
		});
		let btnId = $(this).attr('id');
		if(btnCom.hasOwnProperty(btnId)){
			btnCom[btnId].call(this);
		}
	});
	
	$("#fileInput").change(function(e){
		fnCom.fileImport(e);
	});
});

function getTreeData(data,keyCol,pKeyCol,lvStr){
	let objData = {};
	let minLv = 1;
	let maxLv = 1;
	data.forEach(item => {
		if(item[lvStr]<=minLv){
			minLv=item[lvStr];
		}
		if(item[lvStr]>maxLv){
			maxLv=item[lvStr];
		}
		objData[item[keyCol]] = item;
	});
	
	for(i=maxLv;i>minLv;i--){
		for(key in objData){
			if(objData[key][lvStr]==i){
				if(objData[objData[key][pKeyCol]].hasOwnProperty('_children')){
					objData[objData[key][pKeyCol]]._children.push(objData[key]);
				}else{
					objData[objData[key][pKeyCol]]._children=[];
					objData[objData[key][pKeyCol]]._children.push(objData[key]);
				}
			}
		}
	}
	let list = [];
	for(key in objData){
		if(objData[key][lvStr]==minLv){
			list.push(objData[key]);
		}
	}
	return list;
}

function commaFormat(obj){
   if(obj.value!=null && (obj.value.length>0 || Math.abs(obj.value)>0)){
      return obj.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');   
   }else{
      return obj.value;
   }
}

let gridList = [];
const tuiGrid = {
	createGrid : function(options,data,event){
		const divHeight = parseInt($('#'+options.gridId).closest('div').css('height').replace('px',''));
		if(!options.hasOwnProperty('height')){
			options.height=divHeight-100;
		}
		options.columns.forEach(col=>{
			if(col.hasOwnProperty('style')){
				let style = col.style.substring(col.style.length-1,col.style.length)==";"?col.style.substring(0,col.style.length-1).split(';'):col.style.split(';');
				if(options.hasOwnProperty('readOnlyColorFlag') && !options.readOnlyColorFlag){
					style.push('background-color:#fff');
				}
				let sheet = document.createElement('style');
				let sheet_str = ".style_"+col.name+" {"+style.join(';')+"}";
				let head = document.head || document.getElementsByTagName('head')[0];
				sheet.type='text/css';
				sheet.appendChild(document.createTextNode(sheet_str));
				head.appendChild(sheet);
				col.className='style_'+col.name;
			}
		});
		
		let gridOpts = {
			el			: document.getElementById(options.gridId),
			data		: data,
		    scrollX 	: options.hasOwnProperty('scrollX')?options.scrollX:false,
		    scrollY 	: options.hasOwnProperty('scrollY')?options.scrollY:false,
		    width		: options.hasOwnProperty('width')?options.width:'auto',
		    bodyHeight	: options.height,
		    editingEvent: 'click',
		    contextMenu: () => { return [] },
		    rowHeight	: options.hasOwnProperty('rowHeight')?options.rowHeight:40,
		    columns		: options.columns
		}
		if(options.hasOwnProperty('paging') && options.paging){
			gridOpts.pageOptions = {
				useClient: true,
	        	perPage: options.rowPerPage
			}
		}
		if(options.hasOwnProperty('rowHeaders')){
			gridOpts.rowHeaders = options.rowHeaders;
		}
		if(options.hasOwnProperty('header')){
			gridOpts.header = options.header;
		}
		if(options.hasOwnProperty('columnOptions')){
			gridOpts.columnOptions=options.columnOptions;
		}
		if(options.hasOwnProperty('treeColumnOptions')){
			gridOpts.treeColumnOptions=options.treeColumnOptions;
		}
		const grid = new tui.Grid(gridOpts);
		gridList.push(grid);
		
	    grid.on('beforeChange', ev => {
	      	if(event.hasOwnProperty('beforeedit')){
				event.beforeedit.call(this,ev);
			}
	    });
	    grid.on('afterChange', ev => {
	      	if(event.hasOwnProperty('afteredit')){
				event.afteredit.call(this,ev.changes[0].rowKey,ev.changes[0].columnName,ev.changes[0].prevValue,ev.changes[0].value,ev.instance);
			}
	    });
	    grid.on('click', (ev) => {
	      	if(event.hasOwnProperty('cellclick') && ev.targetType=='cell'){
				event.cellclick.call(this,ev.rowKey,ev.columnName,ev.instance);
			}
	    });
	    grid.on('dblclick', (ev) => {
	      	if(event.hasOwnProperty('celldblclick') && ev.targetType=='cell'){
				event.celldblclick.call(this,ev.rowKey,ev.columnName,ev.instance);
			}
	    });
	    grid.on('check', ev => {
			if(ev.instance.getRow(ev.rowKey).status=="i"){
				ev.instance.removeRow(ev.rowKey);
			}else{
				options.rowHeaders.forEach(rowHeader =>{
					if(typeof rowHeader=="object" && rowHeader.type=="checkbox" && rowHeader.hasOwnProperty('delFlag') && !rowHeader.delFlag){
					}else{
						ev.instance.addRowClassName(ev.rowKey,'tui-grid-cell-del');		
					}
				});
					
			}
	      	if(event.hasOwnProperty('cellcheck')){
				event.cellcheck.call(this,ev);
			}
	    });
	    grid.on('uncheck', ev => {
			ev.instance.removeRowClassName(ev.rowKey,'tui-grid-cell-del');
		});
		grid.on('mouseover', ev => {
			options.columns.forEach(col=>{
				if(col.name==ev.columnName && col.hasOwnProperty('tooltip') && col.tooltip && ev.targetType=="cell"){
					let val = ev.instance.getValue(ev.rowKey,ev.columnName);
					if($('#tui_grid_tooltip').length==0){
						$('body').append('<div id="tui_grid_tooltip" style="position:absolute;padding:5px;left:'+ev.nativeEvent.x+'px;top:'+(ev.nativeEvent.y-10)+'px;border:1px solid lightgray;width:200px;height:auto;background-color: white;word-break:break-all;">'+val+'</div>');	
					}
				}
			});
		});
		grid.on('mouseout', ev => {
			if($('#tui_grid_tooltip').length>0){
				$('#tui_grid_tooltip').remove();
			}
		});
		grid.on('onGridUpdated', ev => {
			if(options.hasOwnProperty('readOnlyColorFlag') && !options.readOnlyColorFlag){
				let _list = ev.instance.getData();
				_list.forEach(row => {
					ev.instance.addRowClassName(row.rowKey,'tui-grid-white');
				});
				$(ev.instance.el).attr('readonly-color-flag',false);
			}
			if(options.hasOwnProperty('treeColumnOptions')){
				ev.instance.expandAll();
			}
			if(event.hasOwnProperty('onload')){
				event.onload.call(this,ev);
			}
		});
		grid.on('onGridMounted', ev => {
			if(options.hasOwnProperty('readOnlyColorFlag') && !options.readOnlyColorFlag){
				let _list = ev.instance.getData();
				_list.forEach(row => {
					ev.instance.addRowClassName(row.rowKey,'tui-grid-white');
				});
				$(ev.instance.el).attr('readonly-color-flag',false);
			}
			if(options.hasOwnProperty('treeColumnOptions')){
				ev.instance.expandAll();
			}
			if(event.hasOwnProperty('onload')){
				event.onload.call(this,ev);
			}
		});
		return grid;
	},
	setRowBackColor : function(grid,rowKey,color){
		let className = grid.el.id+"_"+rowKey+"_back";
		let sheet = document.createElement('style');
		let sheet_str = "."+className+" {background-color:"+color+";}";
		let head = document.head || document.getElementsByTagName('head')[0];
		sheet.type='text/css';
		sheet.appendChild(document.createTextNode(sheet_str));
		head.appendChild(sheet);
		grid.addRowClassName(rowKey,className);
	},
	setColBackColor : function(grid,columnName,color){
		let className = grid.el.id+"_"+columnName+"_back";
		let sheet = document.createElement('style');
		let sheet_str = "."+className+" {background-color:"+color+";}";
		let head = document.head || document.getElementsByTagName('head')[0];
		sheet.type='text/css';
		sheet.appendChild(document.createTextNode(sheet_str));
		head.appendChild(sheet);
		grid.addColumnClassName(columnName,className);
	},
	setCellBackColor : function(grid,rowKey,columnName,color){
		let className = grid.el.id+"_"+rowKey+"_"+columnName+"_back";
		let sheet = document.createElement('style');
		let sheet_str = "."+className+" {background-color:"+color+";}";
		let head = document.head || document.getElementsByTagName('head')[0];
		sheet.type='text/css';
		sheet.appendChild(document.createTextNode(sheet_str));
		head.appendChild(sheet);
		grid.addCellClassName(rowKey,columnName,className);
	},
	setRowFontColor : function(grid,rowKey,color){
		let className = grid.el.id+"_"+rowKey+"_font";
		let sheet = document.createElement('style');
		let sheet_str = "."+className+" {color:"+color+";}";
		let head = document.head || document.getElementsByTagName('head')[0];
		sheet.type='text/css';
		sheet.appendChild(document.createTextNode(sheet_str));
		head.appendChild(sheet);
		grid.addRowClassName(rowKey,className);
	},
	setColFontColor : function(grid,columnName,color){
		let className = grid.el.id+"_"+columnName+"_font";
		let sheet = document.createElement('style');
		let sheet_str = "."+className+" {color:"+color+";}";
		let head = document.head || document.getElementsByTagName('head')[0];
		sheet.type='text/css';
		sheet.appendChild(document.createTextNode(sheet_str));
		head.appendChild(sheet);
		grid.addColumnClassName(columnName,className);
	},
	setCellFontColor : function(grid,rowKey,columnName,color){
		let className = grid.el.id+"_"+rowKey+"_"+columnName+"_font";
		let sheet = document.createElement('style');
		let sheet_str = "."+className+" {color:"+color+";}";
		let head = document.head || document.getElementsByTagName('head')[0];
		sheet.type='text/css';
		sheet.appendChild(document.createTextNode(sheet_str));
		head.appendChild(sheet);
		grid.addCellClassName(rowKey,columnName,className);
	},
	getModifiedData : function(grid){
		let cData = grid.getModifiedRows().createdRows;
		let uData = grid.getModifiedRows().updatedRows;
		uData.forEach(row=>{
			row.status="u";
		});
		let dData = grid.getCheckedRows();
		dData.forEach(row=>{
			row.status="d";
		});
		let data = cData.concat(uData,dData);
		return data;
	},
	getMaxValue : function(grid, colName){
		let data = grid.getData();
		let maxVal = 0;
		data.forEach(row => {
			if(isNaN(row[colName])){
				return;
			}
			if(maxVal<row[colName]){
				maxVal=row[colName];
			}
		});
		return maxVal;
	},
	appendRow : function(grid, colData, opt){
		let startAt = grid.getRowCount();
		if(typeof opt=="undefined"){
			opt={};
		}
		if(opt.hasOwnProperty('startAt')){
			startAt=opt.startAt;
		}
		colData.status="i";
		grid.appendRow(colData,{at:startAt,focus:true});
		if(opt.hasOwnProperty('editable')){
			let editableCols = opt.editable;
			editableCols.forEach(col => {
				let row = grid.getRowAt(startAt);
				grid.enableCell(row.rowKey,col);
			})
		}
		if($(grid.el).attr('readonly-color-flag')=='false'){
			grid.addRowClassName(grid.getRowAt(startAt).rowKey,'tui-grid-white');
		}
		return grid.getRowAt(startAt).rowKey;
	},
	dataExport : function(grid, fileName){
	    let cols = grid.getColumns();
	    let colNms = [];
	    cols.forEach(col => {
			if(!col.hidden){
				colNms.push(col.header);
			}
		});
		
		let data = grid.getData();
		let convData = [];
		
		if(data.length==0){
			alert('데이터가 없습니다.');
			return;
		}
		
		data.forEach(row => {
			let map = {};
			cols.forEach( (col,idx) => {
				if(!col.hidden){
					if(col.hasOwnProperty('formatter') && col.formatter=="listItemText"){
						let list = col.editor.options.listItems;
						list.forEach( item => {
							if(item.value==row[col.name]){
								map[col.header]=item.text;		
							}
						})		
					}else{
						map[col.header]=row[col.name];	
					}
				}
			});
			convData.push(map);
		});
		
		const wb = XLSX.utils.book_new();
		const ws = XLSX.utils.json_to_sheet(convData, {
			header: colNms,
		});
		
		cols.forEach( (col,cidx) => {
			if(!col.hidden){
				let val = sheetCol[cidx]+'1';
				if(typeof ws[val]!=="undefined"){
					ws[val].s = {
						alignment : {
							horizontal : 'center'
						},
						font :{
							color 	: { rgb: '000000' }
						},
						fill : {
							patternType : 'solid', bgColor 	: { rgb: 'D1D1D1' }, fgColor : { rgb: 'D1D1D1' }
						},
						border : {
							top : {
								style:'thin',color:{rgb:'000000'}
							},
							bottom : {
								style:'thin',color:{rgb:'000000'}
							},
							left : {
								style:'thin',color:{rgb:'000000'}
							},
							right : {
								style:'thin',color:{rgb:'000000'}
							}
						}
					}
				}
			}
		});
		data.forEach( (row,idx) => {
			let rowIdx = idx+2;
			cols.forEach( (col,cidx) => {
				if(!col.hidden){
					let val = sheetCol[cidx-1]+rowIdx;
					if(typeof ws[val]!=="undefined"){
						ws[val].s = {
							alignment : {
								horizontal : col.align
							},
							border : {
								top : {
									style:'thin',color:{rgb:'000000'}
								},
								bottom : {
									style:'thin',color:{rgb:'000000'}
								},
								left : {
									style:'thin',color:{rgb:'000000'}
								},
								right : {
									style:'thin',color:{rgb:'000000'}
								}
							}
						}
					}
				}
			});
		});
		XLSX.utils.book_append_sheet(wb, ws, 'sheet1'); // add worksheet to workbook
		XLSX.writeFile(wb, fileName); // write workbook
	},
	dataImport : function(grid,options){
		cfn_loadingOn();
	    let reader = new FileReader();
	    reader.onload = function () {
	        let data = reader.result;
	        let workBook = XLSX.read(data, {type : 'binary',cellText:false,cellDates:true});
	        let rows = XLSX.utils.sheet_to_json(workBook.Sheets[workBook.SheetNames[0]],{header: 1,raw:false,dateNF:'yyyy"-"mm"-"dd'});
	        let list = [];
	        
	        rows.forEach((row,ridx)=>{
	        	let obj = {};
	        	if(options.headerExist && ridx===0){
					return;
				}
				if(options.hasOwnProperty('hiddenColumn')){
					options.hiddenColumn.forEach(hCol=>{
						obj[hCol.name]=hCol.value;
					});
				}

				row.forEach((colData,idx)=>{
					let header = options.uploadHeader[idx];
					if(header.hasOwnProperty('comboData')){
						header.comboData.forEach( item => {
							if(item.text==row[idx]){
								obj[header.name]=item.value;	
							}
						})
					}else{
						obj[header.name]=colData;
					}
				});
				list.push(obj);
	        });
	        grid.resetData(list);
	        cfn_loadingOff();
	    };
	    //reader.readAsText(options.file);
	    reader.readAsBinaryString(options.file);
	}
}

const sheetCol = [
	"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ",
	"BA","BB","BC","BD","BE","BF","BG","BH","BI","BJ","BK","BL","BM","BN","BO","BP","BQ","BR","BS","BT","BU","BV","BW","BX","BY","BZ"
]; 