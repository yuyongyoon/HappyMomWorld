function doAPIbyECOUNT(url,param,callback){
	let top = window.innerHeight/2;
	let marginLeft = window.innerWidth/2;
	$('#img_loading').css('margin-left',marginLeft+'px');
	$('#img_loading').css('top',top+'px');
	$('#img_loading').show();
	
	if(typeof param!=="undefined" && param!=null){
		param.SESSION_ID = SESSION_ID;
	}else{
		param = {
			SESSION_ID : SESSION_ID
		};
	}
	
	const xhr = new XMLHttpRequest();
	
	xhr.onreadystatechange = function() { // 요청에 대한 콜백
		if (xhr.readyState === xhr.DONE) { // 요청이 완료되면
		    if (xhr.status === 200 || xhr.status === 201) {
		    	let response = JSON.parse(xhr.response);
		    	callback.call(this,response);
		    	$('#img_loading').hide();
			} else {
		      	alert("error");
		      	$('#img_loading').hide();
		    }
		}
	};

	//HTTP 요청 초기화
	xhr.open('POST',API_URL_COM+url+'?SESSION_ID='+SESSION_ID);

	//HTTP 요청 헤더 설정
	//클라이언트가 서버로 전송할 데이터의 MIME 타입 지정 : json
	xhr.setRequestHeader('content-type', 'application/json');

	//HTTP 요청 전송
	xhr.send(JSON.stringify(param));
}

function getZoneByECOUNT(){
	//XMLHttpRequest 객체 생성
	const xhr = new XMLHttpRequest();
	
	xhr.onreadystatechange = function() { // 요청에 대한 콜백
		if (xhr.readyState === xhr.DONE) { // 요청이 완료되면
		    if (xhr.status === 200 || xhr.status === 201) {
		    	let response = JSON.parse(xhr.response);
		    	ZONE = response.Data.ZONE;
		    	API_URL_COM = 'https://sboapi'+ZONE+'.ecount.com/OAPI/V2';
		    	loginByECOUNT();
			} else {
		      	alert("error");
		    }
		}
	};

	//HTTP 요청 초기화
	xhr.open('POST','https://sboapi.ecount.com/OAPI/V2/Zone');

	//HTTP 요청 헤더 설정
	//클라이언트가 서버로 전송할 데이터의 MIME 타입 지정 : json
	xhr.setRequestHeader('content-type', 'application/json');

	//HTTP 요청 전송
	xhr.send(JSON.stringify({COM_CODE : COM_CODE}));
}

function loginByECOUNT(zone){
	//XMLHttpRequest 객체 생성
	const xhr = new XMLHttpRequest();
	
	xhr.onreadystatechange = function() { // 요청에 대한 콜백
		if (xhr.readyState === xhr.DONE) { // 요청이 완료되면
		    if (xhr.status === 200 || xhr.status === 201) {
		    	let response = JSON.parse(xhr.response);
		    	SESSION_ID = response.Data.Datas.SESSION_ID;
			} else {
		      	alert("error");
		    }
		}
	};

	//HTTP 요청 초기화
	xhr.open('POST',API_URL_COM+'/OAPILogin');

	//HTTP 요청 헤더 설정
	//클라이언트가 서버로 전송할 데이터의 MIME 타입 지정 : json
	xhr.setRequestHeader('content-type', 'application/json');

	//HTTP 요청 전송
	xhr.send(JSON.stringify({COM_CODE : COM_CODE, ZONE: ZONE, USER_ID: USER_ID, API_CERT_KEY: API_CERT_KEY}));
}