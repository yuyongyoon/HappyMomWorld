
$.extend({
	doPost : function(options){
		options.type='POST';
		options.dataType='json';
		options.timeout=3000000;
		options.contentType='application/json; charset=UTF-8';
		if(options.hasOwnProperty("data")){
			options.data = JSON.stringify(options.data);
		}else{
			options.data = JSON.stringify({});
		}
		options.beforeSend = function(){
			cfn_loadingOn();
		};
		options.complete = function(){
			cfn_loadingOff();
		};
		$.ajax(options);
	}
});

function cfn_loadingOn(){
	if($('#div_loading_panel').length==0){
		$('body').append('<div id="div_loading_panel" style="position:absolute;width:100%;height:100%;background-color:black;top:0px;opacity:0.1;"></div>');	
	}
	if($('#img_loading').length>0){
		$('#img_loading').hide();
	}
	let top = window.innerHeight/2-150;
	let left = window.innerWidth/2-100;
	$('#img_loading').css('top',top+'px');
	$('#img_loading').css('left',left+'px');
	$('#img_loading').show();
}

function cfn_loadingOff(){
	$('#div_loading_panel').remove();
	$('#img_loading').hide();
}

function cfn_gridResize(parentid,top){
	let height = window.innerHeight-top;
	$(window).resize(function(){
		height = window.innerHeight-top;
		$('#main-content #'+parentid).css('height',height+'px');	
	}).resize();
}

function cfn_getFormatToday(format){
	let date = new Date(+new Date() + 3240 * 10000).toISOString().split("T")[0]
	if(typeof format!=="undefined"){
		date = date.split("-").join(format);	
	}
	return date;
}

function cfn_getFormatFirstday(format){
	let date = new Date();
	let year = date.getFullYear();
	let month = cfn_getLPAD(date.getMonth()+1,2,"0");
	let day = "01";
	if(typeof format==="undefined"){
		format = "-";	
	}
	return year+format+month+format+day;
}

function cfn_getFormatLastMonthFirstday(format){
	let date = new Date();
	let year = date.getMonth()==0?date.getFullYear()-1:date.getFullYear();
	let month = cfn_getLPAD(date.getMonth()==0?12:date.getMonth(),2,"0");
	let day = "01";
	if(typeof format==="undefined"){
		format = "-";	
	}
	return year+format+month+format+day;
}

function cfn_getFormatDate(value,format){
	if(value.length!==0){
		return;
	}
	let year = value.substring(0,4);
	let month = value.substring(4,6);
	let day = value.substring(6,8);
	if(typeof format==="undefined"){
		format = "-";	
	}
	return year+format+month+format+day;
}

function cfn_getLPAD(str, padLen, padStr) {
	if (padStr.length > padLen) {
		console.log("오류 : 채우고자 하는 문자열이 요청 길이보다 큽니다");
		return str;
	}
	str += ""; // 문자로
	padStr += ""; // 문자로
	while (str.length < padLen)
		str = padStr + str;
	str = str.length >= padLen ? str.substring(0, padLen) : str;
	return str;
}

function cfn_tuiDateFormat(date) {
	const year = date.getFullYear();
	const month = String(date.getMonth() + 1).padStart(2, '0');
	const day = String(date.getDate()).padStart(2, '0');
	return `${year}-${month}-${day}`;
}

function cfn_clearField(modalId){
	const modal = $('#' + modalId);
	modal.find('input, textarea').val('');
	modal.find('input, textarea').prop('disabled', false);
}

$(document).ready(function() {
	$('.row.search input').keydown(function(e){
		
		if(e.keyCode===13){
			if($('#btn_get').length>0){
				$('#btn_get').click();
			}else if($('#btn_search').length>0){
				$('#btn_search').click();
			}
		}
	});
});