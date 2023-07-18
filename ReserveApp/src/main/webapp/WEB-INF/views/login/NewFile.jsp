<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
	<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>Login</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	
	<script>
	$(document).ready(function() {
		const urlSearchParams = new URLSearchParams(window.location.search); 
		const params = Object.fromEntries(urlSearchParams.entries());
	
		if (params.error === 'true' && params.exception === 'Invaild Username or Password') {
			alert('ID 또는 패스워드를 확인해주세요')
		}
		
		$('#forgotPwdSpan').click(function() {
			$('#forgotPwdDiv').css('display','block')
		})
	
		
		let id_check = false;	// id 중복체크 여부
		let pwd_check = false;	// 비밀번호 동일 여부 
		let name_check;
		
		//Datepicker 객체(출산 예정일)
		const signupDatepicker = new tui.DatePicker('#wrapper_signup', {
				language: 'ko',
				date: '',
				input: {
					element: '#dueDate_signup',
					format: 'yyyy-MM-dd'
				}
			});;		//출산 예정일 datepicker
		
		ajaxCom = {
			// 회원가입
			signup : function(param){
				$.doPost({
					url	 	: "/login/signup",
					data 	: param,
					success	: function(result) {
						if(result.msg == 'success') {
							alert('등록되었습니다.');
							cfn_clearField('user_add_modal'); //모달 id 값을 파라미터로 넘겨주세요
							$('#user_add_modal').modal('hide');//창 닫기
							ajaxCom.getUserList();	// 조회
							$('#btn_get').click();
						}
					},
					error	: function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			},
			// 아이디 중복 확인
			checkId : function(param) {
				$('#checkId_msg_add_div').hide();
				$.doPost({
					url	 	: "/login/checkId",
					data 	: param,
					success	: function(result) {
						if(result.idCnt >= 1) {
							$('#checkId_msg_add').text('중복된 ID가 있습니다. 다른 ID를 입력해주세요.');
							$('#checkId_msg_add_div').show();
						} else{
							$('#input_checkId_add').attr('disabled', true);
							$("#input_userPwd_add").focus();
							id_check = true;	// 아이디 중복확인(완)
						}
					},
					error	: function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			} //*/
		};//End ajaxCom
		
		btnCom = {
			// 아이디 중복 확인 버튼(회원 가입)
			btn_checkId_signup : function(){
				if($('#input_checkId_add').val() == '') {
					alert('ID를 입력해주세요');
					return false;
				}
				
				let param = {
					add_id : $('#input_checkId_add').val()
				};
				
				ajaxCom.checkId(param);
			}, //*/
			// 회원가입 버튼
			btn_signup : function(){
				// 필수항목 확인 여부
				/*if($('#input_checkId_add').val() == ''){// 아이디 입력 여부
					alert('아이디를 입력해주세요.');
					return false;
				} else if(id_check == false){// 아이디 중복 확인 여부
					alert('아이디 중복 확인해주세요.');
					return false;
				} else if($('#input_userPwd_add').val() == '' || $('#input_checkPwd_add').val() == ''){// 비번 입력 여부
					alert('비밀번호를 입력해주세요.');
					return false;
				} else if(pwd_check == false){// 비번 중복 확인 여부
					alert('비밀번호를 확인해주세요.');
					return false;
				} else if($('#input_userName_add').val() == ''){// 이름 입력 여부
					alert('이름을 입력해주세요.');
					return false;
				} */
				
				// 정보 DB에 추가
				let param = {
					id			: $('#id_signup').val(),		// id
					password	: $('#pwd_signup').val(),		// 비밀번호
					name 		: $('#name_signup').val(),		// 이름
					phone_number: $('#number_signup').val(),	// 전화번호
					due_date	: signupDatepicker.getDate() != null ? cfn_tuiDateFormat(signupDatepicker.getDate()) : '',// 출산 예정일
					join_code	: $('#joinCode_signup').val(),		// 가입 코드
				}
				
				//ajaxCom.signup(param);
				console.log('param >', param);
			},
			//취소 버튼
			/*btn_cancel_signup : function() {
				let modalId = $(this).closest(".modal").attr("id");
				
				if (confirm("창을 닫으면 수정한 내용이 모두 지워집니다. 닫으시겠습니까?")) {
					$('#input_checkId_add').attr('disabled', false);
					cfn_clearField('user_add_modal');
					$('#checkId_msg_add_div').css('display', 'none');
					$('#checkPwd_msg_add_div').css('display', 'none');
					$('#' + modalId).modal('hide');
				} else {
					$('#btn_signupClose').blur();
				}
			} //*/
		};//End btnCom
	});//End ajaxCom
	</script>
	
	<style>
		html, body {
			width: 100%;
			height: 100%;
			margin: 0;
			padding: 0;
			overflow: hidden;
		}

		.wrapper.wrapper-login {
			position: fixed;
			top: 0;
			left: 0;
			width: 100%;
			height: 100%;
			overflow: auto;
		}

		.container.container-login {
			height: 100%;
			display: flex;
			flex-direction: column;
			justify-content: center;
			align-items: center;
		}
	</style>

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
		<!---------------------------------회원 가입(작업중)-------------------------------->
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
				<div class="form-group form-floating-label">
					<input id="pwd_signup" name="pwd_signup" type="password" class="form-control input-border-bottom" required>
					<label for="pwd_signup" class="placeholder">Password</label>
					<div class="show-password">
						<i class="flaticon-interface"></i>
					</div>
				</div>
				<div class="row form-sub m-0">
					<span class="float-left" id="pwdLength_msg_singup" style="color:red; cursor:pointer;">비밀번호는 8자 이상입니다.</span>
				</div>
				<div class="form-group form-floating-label">
					<input id="checkPwd_signup" name="checkPwd_signup" type="password" class="form-control input-border-bottom" required>
					<label for="checkPwd_signup" class="placeholder">Confirm Password</label>
					<div class="show-password">
						<i class="flaticon-interface"></i>
					</div>
				</div>
				<div class="row form-sub m-0">
					<span class="float-left" id="checkPwd_msg_singup" style="color:red; cursor:pointer;">비밀번호가 다릅니다.</span>
				</div>
				<div class="form-group form-floating-label">
					<input  id="name_signup" name="name_signup" type="text" class="form-control input-border-bottom" required>
					<label for="name_signup" class="placeholder">이름</label>
				</div>
				<div class="form-group form-floating-label">
					<input  id="number_signup" name="number__signup" type="tel" class="form-control input-border-bottom" required>
					<label for="number_signup" class="placeholder">전화번호</label>
				</div>
				<div class="form-group form-floating-label row pb-0">
					<div class="col-sm-3">
						<label class="control-label mt-2">출산 예정일</label>
					</div>
					<div class="col-sm-9">
						<div class="tui-datepicker-input tui-datetime-input">
							<input type="date" id="dueDate_signup" aria-label="Date-Time">	<!-- 나중에 datepicker적용 시 type: date -> text 변경 -->
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