<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script>
$(document).ready(function() {
	let orgPwd_check = false;
	let newPwd_check = false;
	let updateInfo_datePicker = '';
	
	//통신 객체
	ajaxCom = {
		// 개인 정보 가져오기
		getUserInfo : function() {
			let param = { user_id : $('#input_userId_info').val() };
			
			$.doPost({
				url	 	: "/user/getUserInfo",
				data 	: param,
				success	: function(result) {
					$('#input_phoneNumber_info').val(result.phone_number);
					$('#input_dueDate_info').val(result.due_date);
					$('#input_hospital_info').val(result.hospital);
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		// 개인 정보 변경
		updateUserInfo : function(param) {
			$.doPost({
				url	 	: "/user/updateUserInfo",
				data 	: param,
				success	: function(result) {
					if(result.msg == 'success') {
						alert('등록되었습니다.');
						$('#nav-updateInfo-modal').modal('hide');//창 닫기
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		// 새 비밀번호 변경
		updateUserPwd : function(param) {
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
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		}
	}; //ajaxCom END
	
	btnCom = {
		// 정보 저장 버튼 클릭 시(개인 정보 변경 modal)
		btn_updateInfo_save : function() {
			let param = {
					id			: $('#input_userId_info').val(),		// id
					name 		: $('#input_userName_info').val(),		// 이름
					phone_number: $('#input_phoneNumber_info').val(),	// 전화번호
					due_date	: updateInfo_datePicker.getDate() != null ? cfn_tuiDateFormat(updateInfo_datePicker.getDate()) : '',// 출산 예정일
					hospital	: $('#input_hospital_info').val()		// 병원 정보
			}
			ajaxCom.updateUserInfo(param);
		},
		btn_updateInfo_close : function() {
			let modalId = $(this).closest(".modal").attr("id");
			
			if (confirm("창을 닫으면 수정한 내용이 모두 지워집니다. 닫으시겠습니까?")) {
				$('#' + modalId).modal('hide');
			} else {
				$('#btn_updateAccountClose').blur();
			}
		},
		btn_updatePwd_save : function(){
			let orgPwd = $('#input_orgPwd_pwd').val();
			let newPwd = $('#input_newPwd_pwd').val();
			
			let param = {
				org_pwd : orgPwd,
				new_pwd : newPwd
			}
			
			ajaxCom.updateUserPwd(param);
		},
		btn_updatePwd_close : function() {
			let modalId = $(this).closest(".modal").attr("id");
			
			if (confirm("창을 닫으면 수정한 내용이 모두 지워집니다. 닫으시겠습니까?")) {
				cfn_clearField('nav-updatePwd-modal');
				$('#checkNewPwd_msg_div').css('display', 'none');
				$('#' + modalId).modal('hide');
			} else {
				$('#btn_updateAccountClose').blur();
			}
		}
	}
	
	// 개인 정보 변경 버튼 클릭 시
	$('#updateUserInfo_list').click(function() {
		ajaxCom.getUserInfo();
		$('#nav-updateInfo-modal').modal('show');
		
		// 출산 예정일 input datepicker(사용자 정보 추가 modal)
		updateInfo_datePicker = new tui.DatePicker('#wrapper_info', {
			language: 'ko',
			date: $('#input_dueDate_info').val() != '' ? new Date($('#input_dueDate_info').val()) : null,
			input: {
				element: '#input_dueDate_info',
				format: 'yyyy-MM-dd'
			}
		});
	});
	
	//------------------------------------- 비밀 번호 변경 -------------------------------------
	// 비밀번호 변경 버튼 클릭 시
	$('#updateUserPwd_list').click(function() {
		$('#nav-updatePwd-modal').modal('show');

		//새로운 비밀번호 확인
		$('#input_checkNewPwd_pwd').blur(function() {
			let pwd = $('#input_newPwd_pwd').val();
			let checkPwd = $('#input_checkNewPwd_pwd').val();
			
			if(pwd != checkPwd) {// 비밀 번호가 다를 경우
				console.log('여기1')
				$('#input_checkNewPwd_pwd').val(''); // 비번 초기화
				$('#checkNewPwd_msg').text('비밀 번호가 다릅니다.');
				$('#checkNewPwd_msg_div').css('display', '');
			} else if(pwd == '' || checkPwd == '' ){// 값이 없을 경우
				console.log('여기2')
				$('#checkNewPwd_msg').text('비밀번호를 입력해주세요.');
				$('#checkNewPwd_msg_div').css('display', 'flex');
			} else if(pwd == ' ' || checkPwd == ' ') {
				console.log('여기3')
				$('#checkNewPwd_msg').text('비밀번호를 입력해주세요.');
				$('#checkNewPwd_msg_div').css('display', 'flex');
			} else {// 비밀 번호가 동일할 경우
				console.log('여기4')
				$('#input_newPwd_pwd').attr('disabled', true);
				$('#input_checkNewPwd_pwd').attr('disabled', true);
				$('#checkNewPwd_msg_div').css('display','none');// 에러 메세지 지우기
			}
		});
		
	});
})
</script>

<div class="wrapper">
	<div class="main-header" data-background-color="purple">
		<!-- Logo Header -->
		<div class="logo-header">
			
			<a href="/" class="logo">
<!-- 				<img src="/static/assets/img/logoazzara.svg" alt="navbar brand" class="navbar-brand"> -->
				<span>HappyMamWorld</span>
			</a>
			<button class="navbar-toggler sidenav-toggler ml-auto" type="button" data-toggle="collapse" data-target="collapse" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon">
					<i class="fa fa-bars"></i>
				</span>
			</button>
			<button class="topbar-toggler more"><i class="fa fa-ellipsis-v"></i></button>
			<div class="navbar-minimize">
				<button class="btn btn-minimize btn-rounded">
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
								<select class="form-control form-control-sm" id="select_branch" style="border: 1px solid white;background-color: white;">
									<option value="">=====지점 선택====</option>
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
								<span><sec:authentication property="principal.name" /> 님</span>
							</a>
							
							<ul class="dropdown-menu dropdown-user animated fadeIn" aria-labelledby="userMenu">
								<sec:authorize access="hasAnyRole('ROLE_USER')">
								<li id="updateUserInfo_list">
									<a class="dropdown-item" style="cursor:pointer;">개인 정보 변경</a>
								</li>
								</sec:authorize>
								</li>
								<li id="updateUserPwd_list">
									<a class="dropdown-item" style="cursor:pointer;">비밀번호 변경</a>
								</li>								
								<li id="logOut_list">
									<a class="dropdown-item" href="#" onclick="document.getElementById('logout').submit();">
										<span>로그아웃</span>
									</a>
									<form id="logout" action="/logout" method="POST"></form>
							</ul>
						</li>
					
						<li class="nav-item dropdown hidden-caret">
							<a class="nav-link dropdown-toggle" href="#" id="notifDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								<i class="fa fa-bell"></i>
								<span class="notification">4</span>
							</a>
							<ul class="dropdown-menu notif-box animated fadeIn" aria-labelledby="notifDropdown">
								<li>
									<div class="dropdown-title">You have 4 new notification</div>
								</li>
								<li>
									<div class="notif-scroll scrollbar-outer">
										<div class="notif-center">
											<a href="#">
												<div class="notif-icon notif-primary"> <i class="fa fa-user-plus"></i> </div>
												<div class="notif-content">
													<span class="block">
														New user registered
													</span>
													<span class="time">5 minutes ago</span> 
												</div>
											</a>
											<a href="#">
												<div class="notif-icon notif-success"> <i class="fa fa-comment"></i> </div>
												<div class="notif-content">
													<span class="block">
														Rahmad commented on Admin
													</span>
													<span class="time">12 minutes ago</span> 
												</div>
											</a>
											<a href="#">
												<div class="notif-icon notif-danger"> <i class="fa fa-heart"></i> </div>
												<div class="notif-content">
													<span class="block">
														Farrah liked Admin
													</span>
													<span class="time">17 minutes ago</span> 
												</div>
											</a>
										</div>
									</div>
								</li>
								<li>
									<a class="see-all" href="javascript:void(0);">See all notifications<i class="fa fa-angle-right"></i> </a>
								</li>
							</ul>
						</li>
						<li class="nav-item dropdown hidden-caret"></li>
				</ul>
			</div>
		</nav>
		<!-- End Navbar -->
	</div>
	<sec:authorize access="hasAnyRole('ROLE_USER')">
		<!-- 개인 정보 변경 modal -->
		<div class="modal fade" id="nav-updateInfo-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="updateInfo_modalTitle">개인 정보 변경</h4>
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
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label class="control-label mt-2" style="border: 0px;">출산 병원</label>
							</div>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="input_hospital_info">
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
	<sec:authorize access="hasAnyRole('ROLE_USER')">
		<!-- 비밀 번호 변경 modal -->
		<div class="modal fade" id="nav-updatePwd-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="updatePwd_modalTitle">비밀 번호 변경</h4>
				</div>
				<div class="modal-body">
					<div class="col-12">
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label for="input_orgPwd_pwd" class="control-label mt-2">기존 비밀번호</label>
							</div>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="input_orgPwd_pwd" />
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
								<input type="text" class="form-control" id="input_newPwd_pwd" maxlength='13'> 
							</div>
						</div>
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label class="control-label mt-2" style="border: 0px;">새 비밀번호 확인</label>
							</div>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="input_checkNewPwd_pwd" maxlength='13'> 
							</div>
						</div>
						<div class="col-sm-12 pb-0 mt-2" id="checkNewPwd_msg_div">
							<span id="checkNewPwd_msg" style="color: red; display: flex;justify-content: center;"></span>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" id="btn_updatePwd_save">비밀번호 변경</button>
					<button type="button" class="btn btn-pwd" id="btn_updatePwd_close">취소</button>
				</div>
			</div>
		</div>
	</div>
	</sec:authorize>