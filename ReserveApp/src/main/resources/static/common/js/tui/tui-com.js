$(document).ready(function(){
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
	
	$("#fileInput").change(function(e){
		fnCom.fileImport(e);
	});
});

function commaFormat(obj){
	if(obj.value!=null && obj.value.length>0){
		return obj.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');	
	}else{
		return obj.value;
	}
}

function dateTimeFormat(obj) {
	if(obj.value!=null && obj.value.length>0){
		date = new Date(obj.value)
		let month = date.getMonth() + 1;
		let day = date.getDate();
		let hour = date.getHours();
		let minute = date.getMinutes();
		let second = date.getSeconds();

		month = month >= 10 ? month : '0' + month;
		day = day >= 10 ? day : '0' + day;
		hour = hour >= 10 ? hour : '0' + hour;
		minute = minute >= 10 ? minute : '0' + minute;
//		second = second >= 10 ? second : '0' + second;

		return date.getFullYear() + '-' + month + '-' + day + ' ' + hour + ':' + minute ; //+ ':' + second
	}else{
		return obj.value;
	}
}

class ButtonRenderer {
	constructor(props) {
		const el = document.createElement('button');
		const className = 'btn btn-secondary btn-xs';
		const value = props.columnInfo.renderer.options.value;
		
//		console.log(props.columnInfo.renderer.options.name)

		el.value = value;
		el.type = 'button';
		el.textContent = value;
		el.style = 'margin-top: 3px;';
		el.className = className
		el.addEventListener('click', (ev) => {
			if(props.columnInfo.renderer.options.hasOwnProperty('click')){
				const rowKey = props.rowKey;
				props.columnInfo.renderer.options.click.call(this, props, rowKey);
			}
		});
		
//		if(props.columnInfo.name == 'change' || props.columnInfo.name == 'cancle'){
//			el.disabled = 'disabled'
//		}
		
		this.el = el;
		
		this.render();
	}

	getElement() {
		return this.el;
	}

	render() {}
}

class ImageRenderer {
	constructor(props) {
		const el = document.createElement('img');
		const value = props.value;
		const path = props.columnInfo.renderer.options.path;
		const width = props.columnInfo.renderer.options.width;
		const height = props.columnInfo.renderer.options.height;

		el.src = path+'/'+value;
		el.style = 'width:'+width+'px;height:'+height+'px;';
		this.el = el;
		this.render();
	}

	getElement() {
		return this.el;
	}

	render() {}
}

class AtagRenderer {
	constructor(props) {
		const el = document.createElement('a');
		const path = props.columnInfo.renderer.options.path;
		const value = props.value;
		
		el.href = path+value;
		el.text = value;
		el.download = value;
		
		this.el = el;
		this.render();
	}

	getElement() {
		return this.el;
	}

	render() {}
}



let radioCheck;

class RadioRenderer {
	constructor(props) {
		const el = document.createElement('input');
		el.type = 'radio';
		el.name = props.grid.el.id;
		el.id = props.grid.el.id+'_'+props.rowKey;
		el.addEventListener('click', (ev) => {
			props.grid.check(props.rowKey);
			radioCheck = props.rowKey;
		});
		
		let originData = props.grid.dataManager.getOriginData();
		let originCheckIdx;
		
		originData.forEach((dt,idx) => {
			if(dt.SEL_CHK=='Y') {
				originCheckIdx = idx;
			}
		})
		
		$('input[type=radio]').each(function(i){
			console.log(props.grid)

//			let rowKey = this.id.split('_')[1];
			
			if(typeof originCheckIdx != 'undefined') {
				if(typeof radioCheck != 'undefined'){
					console.log('조건1', radioCheck)
					//실행되었던 값이 있고, 라디오버튼도 새로 클릭함
					$('#controlGrid_'+radioCheck).click();
				} else {
					console.log('조건2')
					//실행되었던 값이 있고, 라디오버튼을 새로 클릭하지 않음
//					console.log($('#controlGrid_'+radioCheck))
//					console.log($(this))
					$('#controlGrid_'+originCheckIdx).click();
				}
				
			}
			
			if(typeof radioCheck != 'undefined' && typeof originCheckIdx == 'undefined'){
				console.log('조건3')
				//실행되었던 값이 없고, 라디오버튼을 새로 클릭함
				$('#controlGrid_'+radioCheck).click();
			}
		});
		
		this.el = el;
		this.render();
	}

	getElement() {
		return this.el;
	}

	render() {}
}


let gridList = [];
let fnCom = {};
let btnCom = {};
let ajaxCom = {};
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
			rowHeight	: options.hasOwnProperty('rowHeight')?options.rowHeight:26, 
			minRowHeight: options.hasOwnProperty('minRowHeight')?options.minRowHeight:26,
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
				event.cellclick.call(this,ev.rowKey,ev.columnName,ev.instance, ev);
			}
		});
		grid.on('check', ev => {
			if(ev.instance.getRow(ev.rowKey).status=="i"){
				ev.instance.removeRow(ev.rowKey);
			}else{
				ev.instance.addRowClassName(ev.rowKey,'tui-grid-cell-del');	
			}
			if(event.hasOwnProperty('cellcheck')){
				event.cellcheck.call(this,ev);
			}
			//2023-03-02 전성원: 라디오버튼 check추가
			if(event.hasOwnProperty('cellradiocheck')){
				ev.instance.removeRowClassName(ev.rowKey, 'tui-grid-cell-del');
				event.cellradiocheck.call(this, ev);
			}
		});
		grid.on('uncheck', ev => {
			ev.instance.removeRowClassName(ev.rowKey,'tui-grid-cell-del');
			if(event.hasOwnProperty('celluncheck')){
				event.celluncheck.call(this.ev);
			}
		});
		grid.on('onGridUpdated', ev => {
			if(options.hasOwnProperty('readOnlyColorFlag') && !options.readOnlyColorFlag){
				let _list = ev.instance.getData();
				_list.forEach(row => {
					ev.instance.addRowClassName(row.rowKey,'tui-grid-white');
					//ev.instance.setValue(row.rowKey,'col_id',options.gridId);
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
				
				//2023.1.18. 박경현
				//Random Forest Classfication Train 열 때 Uncaught TypeError: Cannot read properties of undefined (reading 'data') 에러 나서 막아둠
				if(ev.instance.el != undefined) {
					let _list = ev.instance.getData();
					_list.forEach(row => {
						ev.instance.addRowClassName(row.rowKey,'tui-grid-white');
					});
					$(ev.instance.el).attr('readonly-color-flag',false);
				}
			}
			if(options.hasOwnProperty('treeColumnOptions')){
				ev.instance.expandAll();
			}
			if(event.hasOwnProperty('onload')){
				event.onload.call(this,ev);
			}
		});
		grid.on('mouseover', ev => {
			options.columns.forEach(col=>{
				if(col.name==ev.columnName && col.hasOwnProperty('tooltip') && col.tooltip && ev.targetType=="cell"){
					let val = ev.instance.getValue(ev.rowKey,ev.columnName);
					if($('#tui_grid_tooltip').length==0){
						$('body').append('<div id="tui_grid_tooltip" style="position:absolute;padding:5px;left:'+ev.nativeEvent.x+'px;top:'+(ev.nativeEvent.y-10)+'px;border:1px solid lightgray;width:200px;height:auto;background-color: #eeeeee;word-break:break-all;z-index:2000;font-size:13px;border-radius:5px;">'+val+'</div>');
					}
				}
			});
		});
		grid.on('mouseout', ev => {
			if($('#tui_grid_tooltip').length>0){
				$('#tui_grid_tooltip').remove();
			}
		});
		
		return grid;
	},
	destroyGrid : function(grid){
		if(typeof grid=="object" && grid!=null && grid.hasOwnProperty('el')){
			grid.destroy();
		}
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
	getGridDataAll : function(data, header){
		var tempData = [];
		for(var i=0; i<data.length; i++){
			var obj = {};
			for(j=0; j<header.length; j++){
				obj[j] = data[i][j];
			}
			tempData.push(obj);
			obj = {};
		}
		
		return tempData;
	},
	dataExport : function(grid,fileName){
		let cols = grid.getColumns();
		let colNms = [];
		cols.forEach(col => {
			if(!col.hidden && col.name != 'change' && col.name != 'cancle' && col.name != 'check'){
				colNms.push(col.header);
			}
		});

		let data = grid.getData();
		let convData = [];
		
		data.forEach(row => {
			let map = {};
			cols.forEach( (col,idx) => {
				if(!col.hidden && col.name != 'change' && col.name != 'cancle' && col.name != 'check'){
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
			if(!col.hidden && col.name != 'change' && col.name != 'cancle' && col.name != 'check'){
				let val = sheetCol[cidx]+'1';
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
		});
		data.forEach( (row,idx) => {
			let rowIdx = idx+2;
			cols.forEach( (col,cidx) => {
				if(!col.hidden){
					let val = sheetCol[cidx]+rowIdx;
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
			let workBook = XLSX.read(data, {type : 'binary'});
			let rows = XLSX.utils.sheet_to_json(workBook.Sheets[workBook.SheetNames[0]],{header: 1});
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

let Grid = tuiGrid
const extOptions = {
	cell: {
		focused: { 
			border: 'transparent'
		}
	}
};

//tui.Grid.applyTheme('newTheme', extOptions)

const sheetCol = [
	"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ",
	"BA","BB","BC","BD","BE","BF","BG","BH","BI","BJ","BK","BL","BM","BN","BO","BP","BQ","BR","BS","BT","BU","BV","BW","BX","BY","BZ"
];