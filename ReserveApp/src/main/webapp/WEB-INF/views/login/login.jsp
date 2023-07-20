<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
	<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>Login</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		
		<link rel="icon" href="/static/assets/img/icon.ico" type="image/x-icon"/>
	
		<!-- Fonts and icons -->
		<script src="/static/assets/js/plugin/webfont/webfont.min.js"></script>
		<script>
			WebFont.load({
				google: {"families":["Open+Sans:300,400,600,700"]},
				custom: {"families":["Flaticon", "Font Awesome 5 Solid", "Font Awesome 5 Regular", "Font Awesome 5 Brands"], urls: ['/static/assets/css/fonts.css']},
				active: function() {
					sessionStorage.fonts = true;
				}
			});
		</script>
		
		<!-- CSS Files -->
		<link rel="stylesheet" href="/static/assets/css/bootstrap.min.css">
		<link rel="stylesheet" href="/static/assets/css/azzara.min.css">
		<link rel="stylesheet" href="/static/common/css/common.css" />
		<link rel="stylesheet" href="/static/common/css/tui/tui-date-picker.css" />

		
	</head>
	<body class="login">
		<div class="wrapper wrapper-login">
			<div class="container container-login animated fadeIn">
				<h3 class="text-center">로그인</h3>
					<form class="login-form" method="post" name="f" action="loginProc">
						<div class="form-group form-floating-label">
							<input id="id" name="id" type="text" class="form-control input-border-bottom" required>
							<label for="id" class="placeholder">ID</label>
						</div>
						<div class="form-group form-floating-label">
							<input id="password" name="password" type="password" class="form-control input-border-bottom" required>
							<label for="password" class="placeholder">Password</label>
							<div class="show-password">
								<i class="flaticon-interface"></i>
							</div>
						</div>
						<div class="row form-sub m-0">
							<div class="custom-control custom-checkbox" tabindex="0" data-toggle="tooltip" data-placement="bottom" title="30일간 유지됩니다.">
								<input type="checkbox" class="custom-control-input" id="rememberme" name="rememberme">
								<label class="custom-control-label" for="rememberme">로그인 유지하기</label>
							</div>
							
							<span class="link float-right" id="forgotPwdSpan" style="color:blue;cursor:pointer;">Forget Password ?</span>
						</div>
						<div id="forgotPwdDiv" style="display:none;">
							<span class="float-right" style="color:red;">관리자에게 문의 바랍니다.</span>
						</div>
						<div class="form-action mb-3">
							<button class="btn btn-secondary btn-rounded btn-login" type="submit">로그인</button>
						</div>
					</form>
					<div class="login-account">
						<a href="#" id="show-signup" class="link">회원 가입</a>
					</div>
			</div>
			<div class="container container-signup animated fadeIn">
				<h3 class="text-center">회원 가입</h3>
				<div class="signup-form">
					<div class="form-group form-floating-label row pb-0">
						<div class="form-group form-floating-label col-sm-9">
							<input id="id_signup" name="id_signup" type="text" class="form-control input-border-bottom" required>
							<label for="id_signup" class="placeholder">ID</label>
						</div>
						<div class="form-group form-floating-label col-sm-3">
							<button id="btn_checkId_signup" type="button" class="btn btn-secondary btn-rounded btn-sm">중복 확인</button>
						</div>
					</div>
					<div class="row form-sub m-0" id="div_checkId_msg" >
						<span class="float-left" id="span_checkId_msg" style="color:red; cursor:pointer; display:flex; justify-content:center;"></span>
					</div>
					<div class="form-group form-floating-label">
						<input id="pwd_signup" name="pwd_signup" type="password" class="form-control input-border-bottom" required>
						<label for="pwd_signup" class="placeholder">Password</label>
						<div class="show-password">
							<i class="flaticon-interface"></i>
						</div>
					</div>
					<div class="row form-sub m-0" id="div_pwdLength_msg">
						<span class="float-left" id="span_pwdLength_msg" style="color:red; cursor:pointer; display:flex; justify-content:center;"></span>
					</div>
					<div class="form-group form-floating-label">
						<input id="checkPwd_signup" name="checkPwd_signup" type="password" class="form-control input-border-bottom" required>
						<label for="checkPwd_signup" class="placeholder">Confirm Password</label>
						<div class="show-password">
							<i class="flaticon-interface"></i>
						</div>
					</div>
					<div class="row form-sub m-0" id="div_checkPwd_msg">
						<span class="float-left" id="span_checkPwd_msg" style="color:red; cursor:pointer; display:flex; justify-content:center;"></span>
					</div>
					<div class="form-group form-floating-label">
						<input  id="name_signup" name="name_signup" type="text" class="form-control input-border-bottom" required>
						<label for="name_signup" class="placeholder">이름</label>
					</div>
					<div class="form-group form-floating-label">
						<input  id="number_signup" name="number__signup" class="form-control input-border-bottom" type="text" maxlength="13" autofocus>
						<label for="number_signup" class="placeholder">전화번호</label>
					</div>
					<div class="form-group form-floating-label row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2">출산 예정일</label>
						</div>
						<div class="col-sm-9">
							<div class="tui-datepicker-input tui-datetime-input">
								<input type="text" id="dueDate_signup" aria-label="Date-Time">
								<span class="tui-ico-date"></span>
							</div>
							<div id="wrapper_signup" style="margin-top: -1px;"></div>
						</div>
					</div>
					<div class="form-group form-floating-label">
						<input  id="joinCode_signup" name="joinCode_signup" type="text" class="form-control input-border-bottom" required>
						<label for="joinCode_signup" class="placeholder">Code</label>
					</div>
					<div class="form-action">
						<a href="#" id="btn_cancel_signup" class="btn btn-danger btn-rounded btn-login mr-3">취소</a>
						<a href="#" id="btn_signup" class="btn btn-primary btn-rounded btn-login">회원가입</a>
					</div>
				</div>
			</div>
		</div>
		
		<script src="/static/assets/js/core/jquery.3.2.1.min.js"></script>
		<script src="/static/assets/js/plugin/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
		<script src="/static/assets/js/core/popper.min.js"></script>
		<script src="/static/assets/js/core/bootstrap.min.js"></script>
		<script src="/static/assets/js/ready.js"></script>
		<script src="/static/assets/js/ready.js"></script>
		<script src="/static/common/js/tui/tui-date-picker.js"></script>
		<script src="/static/common/js/common.js"></script>
	<script>
	$(document).ready(function() {
		
		const urlSearchParams = new URLSearchParams(window.location.search); 
		const params = Object.fromEntries(urlSearchParams.entries());
	
		if (params.error === 'true' && params.exception === 'Invaild Username or Password') {
			alert('ID 또는 패스워드를 확인해주세요')
		}		
		$('#forgotPwdSpan').click(function() {
			$('#forgotPwdDiv').css('display','block')
		});
		//Datepicker 객체(출산 예정일)
		const signupDatepicker = new tui.DatePicker('#wrapper_signup', {
				language: 'ko',
				date: '',
				input: {
					element: '#dueDate_signup',
					format: 'yyyy-MM-dd'
				}
		});		//출산 예정일 datepicker
		// 초기 설정
		let id_check = false;		// id 확인 여부
		let orgPwd_check = false;	// 비밀번호 확인 여부
		let pwd_check = false;		// 확인용 비밀번호 확인 여부
		let name_check = false;		// 이름 확인 여부
		let number_check = false;	// 전화번호 확인 여부
		let code_check = false;		// 가입코드 확인 여부
		
		$('#div_checkId_msg').hide();
		$('#div_pwdLength_msg').hide();
		$('#div_checkPwd_msg').hide(); //*/
		
		
		$('#pwd_signup').blur(function(){
			let pwd = $('#pwd_signup').val();
			console.log('pwd : ', pwd);
			if(pwd == ''){// 공백 확인
				$('#span_pwdLength_msg').text('비밀번호를 입력해주세요.');
				$('#div_pwdLength_msg').show();
				$('#checkPwd_signup').attr('disabled', true);
				$('#pwd_signup').focus();// 이전 input로 커서 옮김
			} else if(pwd == ' ') {// space 확인
				$('#span_pwdLength_msg').text('비밀번호를 올바르게 입력해주세요.');
				$('#div_pwdLength_msg').show();
				$('#checkPwd_signup').attr('disabled', true);
				$('#pwd_signup').val('');
				$('#pwd_signup').focus();
			} else if(pwd.length < 7){// 비밀번호 8자 미만인 경우
				$('#span_pwdLength_msg').text('비밀번호는 8자 입니다.');
				$('#div_pwdLength_msg').show();
				$('#checkPwd_signup').attr('disabled', true);
				$('#pwd_signup').val('');
				$('#pwd_signup').focus();
			} else {
				$('#div_pwdLength_msg').hide();
				$('#checkPwd_signup').attr('disabled', false);
				$('#checkPwd_signup').focus();
				orgPwd_check = true;
			}
		});
		$('#checkPwd_signup').blur(function(){
			let pwd = $('#pwd_signup').val();
			let checkPwd = $('#checkPwd_signup').val();
			console.log('checkpwd : ', checkPwd);
			
			if(pwd == '' || checkPwd == '' ){// 공백 확인
				$('#span_checkPwd_msg').text('비밀번호를 입력해주세요.');
				$('#div_checkPwd_msg').show();
				$('#checkPwd_signup').focus();
			} else if(pwd == ' ' || checkPwd == ' ') {// space 확인
				$('#checkPwd_signup').val('');
				$('#span_checkPwd_msg').text('비밀번호를 올바르게 입력해주세요.');
				$('#div_checkPwd_msg').show();
				$('#checkPwd_signup').focus();
			} else if(checkPwd != pwd) {// 비밀번호가 다른 경우
				$('#checkPwd_signup').val('');
				$('#span_checkPwd_msg').text('동일한 비밀번호를 입력해주세요.');
				$('#div_checkPwd_msg').show();
				$('#checkPwd_signup').focus();
			} else if(orgPwd_check != false) {
				//$('#div_checkPwd_msg').hide();
				$('#pwd_signup').attr('disabled', true);
				$('#checkPwd_signup').attr('disabled', true);
				$('#div_pwdLength_msg ').css('display','none');// 에러 메세지 지우기
				$('#div_checkPwd_msg ').css('display','none');// 에러 메세지 지우기
				$('#name_signup').focus();// 다음 input로 커서 옮김
				pwd_check = true;	// 비밀번호 중복확인(완)
			}
		});
		// Ajax
		// 아이디 중복 확인
		function checkId(param) {
			//$('#div_checkId_msg').hide();
			$.doPost({
				url	 	: "/join/checkId",
				data 	: param,
				success	: function(result) {
					if(result.msg == "fail") {// 아이디 중복일 경우
						$('#span_checkId_msg').text('입력하신 아이디는 이미 사용중입니다.');
						$('#div_checkId_msg').show();
					} else if(result.msg == "success"){
						$('#span_checkId_msg').text('사용 가능한 아이디 입니다.');
						$('#span_checkId_msg').css('color',"blue");
						$('#div_checkId_msg').show();
						$('#id_signup').attr('disabled', true);
						$("#pwd_signup").focus();
						id_check = true;	// 아이디 중복확인(완)
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.(아이디 중복)');
				}
			});
		}
		// 회원가입
		function signup(param){
			$.doPost({
				url	 	: "/join/signup",
				data 	: param,
				success	: function(result) {
					if(result.msg == "success") {
						alert('등록되었습니다.');
						location.reload();
					} else if(result.msg == "notFoundCode") {
						alert('가입 코드 불일치');
						$('#joinCode_signup').val('');
						$('#joinCode_signup').focus();
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.(회원가입)');
				}
			});
		}
		//정규 표현식
		// 아이디 유효성 검사
		/* function validation(){
			var inputPwd = $('#pwd_signup').val();
			var inputName = $('#name_signup').val();
			var inputNumber = $('#number_signup').val();
			var inputDuedate = $('#dueDate_signup').val();
			var inputJoincode = $('#joinCode_signup').val();
			
			// 영문/숫자만
			var pwd_RegExp = /^[a-zA-Z0-9]$/;
			// 한글만
			var name_RegExp = /^[가-힣]$/;
			// 숫자만
			var num_RegExp = /^[0-9]$/;
			// 특수문자
			var spe_RegExp = /[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi;
			// 한글
			var kor_RegExp = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/gi;
			
			// 비밀번호 검사
			if(!pwd_RegExp.test(inputPwd)){
				alert("비밀번호는 영문, 숫자만 입력 가능합니다.");
				id_check = false;
				return false;
			}
			// 특수문자, 한글 검사(주석)
			if(spe_RegExp.test(inputId)==false || kor_RegExp.test(inputId)==false)) {
				alert("아이디는 영문, 숫자만 입력 가능합니다.");
				return false;
			} 
			// 이름 검사
			if(inputName == ''){
				alert("이름을 입력해주세요.");
				$('#name_signup').focus();
				return false;
			} else if(!name_RegExp.test(inputName)){
				alert("이름은 특수문자,영어,숫자는 사용할수 없습니다. 한글만 입력하여주세요.");
				$('#name_signup').focus();
				return false;
			} else {
				name_check = true;
			}
			// 전화번호 검사
			if(inputNumber == ''){
				alert("전화번호를 입력해주세요.");
				$('#number_signup').focus();
				return false;
			} else if(!num_RegExp.test(inputNumber)){
				alert("전화번호는 숫자만 사용 가능합니다.");
				$('#number_signup').focus();
				return false;
			} else {
				number_check = true;
			}
			// 출산 예정일 검사
			if($('#dueDate_signup').val() == ''){
				alert('출산 예정일을 입력해주세요.');
				$('#dueDate_signup').focus();
				return false;
			}
			// 가입 코드 검사
			if($('#joinCode_signup').val() == '') {
				alert('가입 코드를 입력해주세요');
				$('#joinCode_signup').focus();
				return false;
			}
			// 모두 만족할 경우
			return true;
		} //*/
		// 전화번호 형식
		/* function phoneFormat(phoneNumber) {
			// 숫자 외 문자 모두 제거
			const value = phoneNumber.replace(/[^0-9]/g, '');
			// 00- / 000-
			const firstLength = value.length > 9 ? 3 : 2;
			
			return [
				value.slice(0, firstLength),				// 첫번째
				vlaue.slice(firstLength, value.length-4),	// 두번째
				value.slice(value.length-4)					// 남은 숫자
			].join('-');	// 구분 문자(-)
		} */
		// Button Click Event
		// 아이디 중복 확인 Button(회원 가입)
		$('#btn_checkId_signup').click(function(){
			let param = {	id : $('#id_signup').val()	}
			let id = $('#id_signup').val();
			//console.log('아이디: ',RegExp.test(id));
			// 영문/숫자만
			var RegExp = /^[a-z]+[a-z0-9]$/g;
			
			if(id == '') {// 값이 없는 경우
				alert('ID를 입력해주세요');
				return false;
			}
			/* if(RegExp.test(id) == false){
				alert("아이디는 영문, 숫자만 입력 가능합니다.");
				$('#id_signup').val('');
				return false;
			} */
			
			checkId(param);
		});
		// 회원가입 Button
		$('#btn_signup').click(function(){
			//validation();	// 유효성 검사
			
			// 가입 전 공백 확인
			if(id_check == false) {
				alert('아이디를 확인해주세요.');
				return false;
			} else if(!pwd_check) {
				alert('비밀번호를 확인해주세요.');
				return false;
			} else if($('#name_signup').val() == ''){
				alert('이름을 입력해주세요.');
				$('#name_signup').focus();
				return false;
			} else if($('#number_signup').val() == ''){
				alert('전화번호를 입력해주세요.');
				$('#number_signup').focus();
				return false;
			} else if($('#dueDate_signup').val() == ''){
				alert('출산 예정일을 입력해주세요.');
				$('#dueDate_signup').focus();
				return false;
			} else if($('#joinCode_signup').val() == '') {
				alert('가입 코드를 입력해주세요');
				$('#joinCode_signup').focus();
				return false;
			} else {
				//let phoneNumber = phoneFormat($('#number_signup').val());	// 전화번호 형식 변경
				//console.log('전화번호: ',phoneNumber);
				// 정보 DB에 추가
				let param = {
					id			: $('#id_signup').val(),		// id
					password	: $('#pwd_signup').val(),		// 비밀번호
					name 		: $('#name_signup').val(),		// 이름
					phone_number: $('#number_signup').val(),	// 전화번호
					due_date	: signupDatepicker.getDate() != null ? cfn_tuiDateFormat(signupDatepicker.getDate()) : '',// 출산 예정일
					join_code	: $('#joinCode_signup').val(),	// 가입 코드
				}
					
				signup(param);	//DB에 가입 정보 추가
			}
		});
		//취소 Button
		$('#btn_cancel_signup').click(function(){
			location.reload();
		});
		
	});//End ready()
	</script>
	</body>
</html>

