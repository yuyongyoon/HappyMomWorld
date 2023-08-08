<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script>
$(document).ready(function() {
	let doubleCheckPwd = false;
	let updateInfo_datePicker = '';
	
	$('#btn_updateInfo_save').click(function(){
		let param = {
				id			: $('#input_userId_info').val(),		// id
				name 		: $('#input_userName_info').val(),		// 이름
				phone_number: $('#input_phoneNumber_info').val(),	// 전화번호
				due_date	: updateInfo_datePicker.getDate() != null ? cfn_tuiDateFormat(updateInfo_datePicker.getDate()) : '',// 출산 예정일
		};
		updateUserInfo(param);
	})
	
	$('#btn_updateInfo_close').click(function() {
		let modalId = $(this).closest(".modal").attr("id");
		
		if (confirm("창을 닫으면 수정한 내용이 모두 지워집니다. 닫으시겠습니까?")) {
			$('#' + modalId).modal('hide');
		} else {
			$('#btn_updateAccountClose').blur();
		}
	})
	
	$('#btn_updatePwd_save').click(function(){
		
		if($('#input_orgPwd_pwd').val() == '' || $('#input_newPwd_pwd').val() == '' || $('#input_checkNewPwd_pwd').val() == ''){
			alert('비밀번호 입력 칸들을 채워주세요.');
			return false;
		} else if($('#input_orgPwd_pwd').val() == $('#input_newPwd_pwd').val()){
			alert('기존 비밀번호와 새 비밀번호가 동일합니다.');
			$('#input_newPwd_pwd').attr('disabled', false);
			$('#input_checkNewPwd_pwd').attr('disabled', false);
			$('#input_newPwd_pwd').val('');
			$('#input_checkNewPwd_pwd').val('');
			return false;
		} else if(doubleCheckPwd){
			let orgPwd = $('#input_orgPwd_pwd').val();
			let newPwd = $('#input_newPwd_pwd').val();
			
			let param = {
				org_pwd : orgPwd,
				new_pwd : newPwd
			}
			updateUserPwd(param);
		}
	})
	
	$('#btn_updatePwd_close').click(function() {
		let modalId = $(this).closest(".modal").attr("id");
		
		if (confirm("창을 닫으면 수정한 내용이 모두 지워집니다. 닫으시겠습니까?")) {
			cfn_clearField('nav-updatePwd-modal');
			$('#checkNewPwd_msg_div').css('display', 'none');
			$('#' + modalId).modal('hide');
		} else {
			$('#btn_updateAccountClose').blur();
		}
	})

	// 비밀번호 변경 버튼 클릭 시
	$('.updateUserPwd_list').click(function() {
		console.log('클릭')
		$('#nav-updatePwd-modal').modal('show');
		//새로운 비밀번호 확인
		$('#input_checkNewPwd_pwd').blur(function() {
			let pwd = $('#input_newPwd_pwd').val().trim();
			let checkPwd = $('#input_checkNewPwd_pwd').val().trim();
			let pwdPattern = /^.{8,}$/;
			
			console.log($('#input_orgPwd_pwd').val().trim() )
			if($('#input_orgPwd_pwd').val().trim() == ''){
				$('#checkNewPwd_msg').text('기존 비밀번호를 입력해주세요');
				$('#checkNewPwd_msg_div').css('display', '');
				return false;
			} else if(!pwdPattern.test(pwd)){
				$('#input_newPwd_pwd').val('');
				$('#input_checkNewPwd_pwd').val(''); 
				$('#checkNewPwd_msg').text('비밀번호는 공백을 제외하고 8자 이상입니다.');
				$('#checkNewPwd_msg_div').css('display', '');
				return false;
			} else if(pwd != checkPwd) {// 비밀 번호가 다를 경우
				$('#input_checkNewPwd_pwd').val(''); // 비번 초기화
				$('#checkNewPwd_msg').text('비밀 번호가 다릅니다.');
				$('#checkNewPwd_msg_div').css('display', '');
				return false;
			} else { // 비밀 번호가 동일할 경우
				$('#input_newPwd_pwd').attr('disabled', true);
				$('#input_checkNewPwd_pwd').attr('disabled', true);
				$('#checkNewPwd_msg_div').css('display','none');// 에러 메세지 지우기
				doubleCheckPwd = true;
			}
		});
	});
	
	// 지점 선택
	if($('#role').val() == 'SUPERADMIN'){
		getBranch();
		
		$('#select-branch').on('change', function(){
			$('#btn_get').click();
		})
	}
	
	// 개인 정보 변경 버튼 클릭 시
	$('#updateUserInfo_list').click(function() {
		$('#nav-updateInfo-modal').modal('show');
		getUserInfo();
	});
	
	function getUserInfo(){
		let param = { user_id : $('#input_userId_info').val() };
		
		$.doPost({
			url	 	: "/user/getUserInfo",
			data 	: param,
			success	: function(result) {
				$('#input_phoneNumber_info').val(result.phone_number);
				$('#input_dueDate_info').val(result.due_date);
				
				updateInfo_datePicker = new tui.DatePicker('#wrapper_info', {
					language: 'ko',
					date: $('#input_dueDate_info').val() != '' ? new Date($('#input_dueDate_info').val()) : null,
					input: {
						element: '#input_dueDate_info',
						format: 'yyyy-MM-dd'
					}
				});
			},
			error	: function(xhr,status){
				alert('오류가 발생했습니다.');
			}
		});
	}
	
	function updateUserInfo(param) {
		$.doPost({
			url	 	: "/user/updateUserInfo",
			data 	: param,
			success	: function(result) {
				if(result.msg == 'success') {
					alert('정보가 변경되었습니다.');
					$('#nav-updateInfo-modal').modal('hide');
				}
			},
			error	: function(xhr,status){
				alert('오류가 발생했습니다.');
			}
		});
	}
	
	function updateUserPwd(param) {
		$.doPost({
			url	 	: "/user/updateUserPwd",
			data 	: param,
			success	: function(result) {
				if(result.msg == 'not found Pwd') {
					alert('기존 비밀번호가 틀렸습니다.');
					cfn_clearField('nav-updatePwd-modal');
					return false;
				} else{
					cfn_clearField('nav-updatePwd-modal');
					$('#nav-updatePwd-modal').modal('hide');//창 닫기
					alert('비밀번호가 변경되었습니다.');
					doubleCheckPwd = false;
				}
			},
			error	: function(xhr,status){
				alert('오류가 발생했습니다.');
			}
		});
	}
	
	function getBranch(param){
		$.doPost({
			url		: "/admin/getBranchNameList",
			success	: function(result){
				let opt = '';
				result.branchNameList.forEach(i => {
					opt += '<option value= "'+i.branch_code+'">'+i.branch_name+'</option>';
				})
				$('#select-branch').append(opt);
			},
			error	: function(xhr,status){
				alert('오류가 발생했습니다.');
			}
		});
	}
})
</script>

<div class="wrapper">
	<div class="main-header" data-background-color="purple">
		<!-- Logo Header -->
		<div class="logo-header" style="background-color:white!important">
			
			<div class="logo" >
				<a href="/" class="logo">
					<img src="/static/common/img/logo2.png" alt="navbar brand" class="navbar-brand">
				</a>
			</div>
			<button class="navbar-toggler sidenav-toggler ml-auto" type="button" data-toggle="collapse" data-target="collapse" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon">
					<i class="fa fa-bars" style="color: #6610f2!important;"></i>
				</span>
			</button>
			<button class="topbar-toggler more"><i class="fa fa-ellipsis-v" style="color: #6610f2!important;"></i></button>
			<div class="navbar-minimize">
				<button class="btn btn-minimize btn-rounded" style="color: #6610f2!important;">
					<i class="fa fa-bars"></i>
				</button>
			</div>
		</div>
		<!-- End Logo Header -->

		<!-- Navbar Header -->
		<nav class="navbar navbar-header navbar-expand-lg">
			<div class="container-fluid">
				<sec:authorize access="hasAnyRole('ROLE_SUPERADMIN')">
					<div class="collapse" id="search-nav">
						<form class="navbar-left navbar-form nav-search mr-md-3" style="background-color: transparent;">
							<div class="form-group">
								<select class="form-control form-control-sm" id="select-branch" style="border: 1px solid white;background-color: white;">
									<option value="">지점 선택</option>
								</select>
							</div>
						</form>
					</div>
				</sec:authorize>
					
				<ul class="navbar-nav topbar-nav ml-md-auto align-items-center">
					<sec:authorize access="hasAnyRole('ROLE_SUPERADMIN')">
						<li class="nav-item toggle-nav-search hidden-caret">
							<a class="nav-link" data-toggle="collapse" href="#search-nav" role="button" aria-expanded="false" aria-controls="search-nav">
								<i class="fa fa-search"></i>
							</a>
						</li>
					</sec:authorize>
					
						<li class="nav-item dropdown hidden-caret">
							<a class="nav-link dropdown-toggle" href="#" id="userMenu" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								<i class="fas fa-user"></i><span style="margin-left:10px"><sec:authentication property="principal.name" /> 님</span>
							</a>
							
							<ul class="dropdown-menu dropdown-user animated fadeIn" aria-labelledby="userMenu">
								<sec:authorize access="hasAnyRole('ROLE_USER')">
									<li id="updateUserInfo_list">
										<a class="dropdown-item" style="cursor:pointer;">회원정보 변경</a>
									</li>
									
									<li class="updateUserPwd_list">
										<a class="dropdown-item" style="cursor:pointer;">비밀번호 변경</a>
									</li>
								</sec:authorize>
								
								<sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_SUPERADMIN')">
									<li class="updateUserPwd_list">
										<a class="dropdown-item" style="cursor:pointer;">비밀번호 변경</a>
									</li>
								</sec:authorize>
								
								<li id="logOut_list">
									<a class="dropdown-item" href="#" onclick="document.getElementById('logout').submit();">
										<span>로그아웃</span>
									</a>
									<form id="logout" action="/logout" method="POST"></form>
								</li>
							</ul>
						</li>
						
						<li class="nav-item dropdown hidden-caret" style="display:none;">
								<input id="role" value="<sec:authentication property="principal.user_role" />" disabled style="display:none;"/>
						</li>
				</ul>
				
			</div>
		</nav>
	</div>
	
	<sec:authorize access="hasAnyRole('ROLE_USER')">
		<div class="modal fade" id="nav-updateInfo-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="updateInfo_modalTitle">회원 정보 변경</h4>
				</div>
				<div class="modal-body">
					<div class="col-12">
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label for="input_userId_info" class="control-label mt-2">ID</label>
							</div>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="input_userId_info" value="<sec:authentication property="principal.id" />" readonly>
							</div>
						</div>
						<div class="col-sm-12 pb-0 mt-2" id="checkId_msg_info_div">
							<span id="checkId_msg_info" style="color: red;display: flex;justify-content: center;"></span>
						</div>
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label class="control-label mt-2" style="border: 0px;">이름</label>
							</div>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="input_userName_info" maxlength='12' value="<sec:authentication property="principal.name" />" readonly>
							</div>
						</div>
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label class="control-label mt-2" style="border: 0px;">전화번호</label>
							</div>
							<div class="col-sm-9">
								<input type="tel" class="form-control" id="input_phoneNumber_info" maxlength='13'>
							</div>
						</div>
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label class="control-label mt-2">출산 예정일</label>
							</div>
							<div class="col-sm-9">
								<div class="tui-datepicker-input tui-datetime-input tui-has-focus">
									<input type="text" id="input_dueDate_info" aria-label="Date-Time">
									<span class="tui-ico-date"></span>
								</div>
								<div id="wrapper_info" style="margin-top: -1px;"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<!-- <button type="button" class="btn btn-secondary" id="">비밀번호 변경</button> -->
					<button type="button" class="btn btn-secondary" id="btn_updateInfo_save">정보 저장</button>
					<button type="button" class="btn btn-info" id="btn_updateInfo_close">취소</button>
				</div>
			</div>
		</div>
	</div>
	</sec:authorize>

	<div class="modal fade" id="nav-updatePwd-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="updatePwd_modalTitle">비밀 번호 변경</h4>
				</div>
				<div class="modal-body">
					<form>
						<div class="col-12">
							<div class="form-group row pb-0">
								<div class="col-sm-3">
									<label for="input_orgPwd_pwd" class="control-label mt-2">기존 비밀번호</label>
								</div>
								<div class="col-sm-9">
									<input type="password" class="form-control" id="input_orgPwd_pwd" autoComplete="off"/>
								</div>
							</div>
							<div class="col-sm-12 pb-0 mt-2" id="checkOrgPwd_msg_div">
								<span id="checkOrgPwd_msg" style="color: red; display: flex;justify-content: center;"></span>
							</div>
							<div class="form-group row pb-0">
								<div class="col-sm-3">
									<label class="control-label mt-2" style="border: 0px;">새 비밀번호</label>
								</div>
								<div class="col-sm-9">
									<input type="password" class="form-control" id="input_newPwd_pwd" maxlength='13' autoComplete="off"> 
								</div>
							</div>
							<div class="form-group row pb-0">
								<div class="col-sm-3">
									<label class="control-label mt-2" style="border: 0px;">새 비밀번호 확인</label>
								</div>
								<div class="col-sm-9">
									<input type="password" class="form-control" id="input_checkNewPwd_pwd" maxlength='13' autoComplete="off"> 
								</div>
							</div>
							<div class="col-sm-12 pb-0 mt-2" id="checkNewPwd_msg_div">
								<span id="checkNewPwd_msg" style="color: red; display: flex;justify-content: center;"></span>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" id="btn_updatePwd_save">비밀번호 변경</button>
					<button type="button" class="btn btn-pwd" id="btn_updatePwd_close">취소</button>
				</div>
			</div>
		</div>
	</div>
	