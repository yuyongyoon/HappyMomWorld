<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

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
								<select class="form-control form-control-sm" id="smallSelect" style="border: 1px solid white;background-color: white;">
									<option>지점 선택</option>
									<option>2</option>
									<option>3</option>
									<option>4</option>
									<option>5</option>
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
								<li id="updateUserInfo">
									<a class="dropdown-item" style="cursor:pointer;">개인 정보 변경</a>
								</li>
								</sec:authorize>
								
								<li id="logOut">
									<a class="dropdown-item" href="#" onclick="document.getElementById('logout').submit();">
										<span>로그아웃</span>
									</a>
									<form id="logout" action="/logout" method="POST"></form>
								</li>
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
		<div class="modal fade" id="nav-updateinfo-modal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="user_edit_modalTitle">개인 정보 변경</h4>
				</div>
				<div class="modal-body">
					<div class="col-12">
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label for="input_checkId_add" class="control-label mt-2">ID</label>
							</div>
							<div class="col-sm-7">
								<input type="text" class="form-control" id="" value="<sec:authentication property="principal.id" />">
								
							</div>
						</div>
						<div class="col-sm-12 pb-0 mt-2" id="checkPwd_msg_add_div">
							<span id="checkPwd_msg_add" style="color: red;display: flex;justify-content: center;"></span>
						</div>
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label class="control-label mt-2" style="border: 0px;">이름</label>
							</div>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="" maxlength='12' value="<sec:authentication property="principal.name" />">
							</div>
						</div>
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label class="control-label mt-2" style="border: 0px;">전화번호</label>
							</div>
							<div class="col-sm-9">
								<input type="tel" class="form-control" id="" maxlength='13' value="<sec:authentication property="principal.phone_number" />">
							</div>
						</div>
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label class="control-label mt-2">출산 예정일</label>
							</div>
							<div class="col-sm-9">
								<div class="tui-datepicker-input tui-datetime-input tui-has-focus">
									<input type="text" id="input_dueDate_add" aria-label="Date-Time">
									<span class="tui-ico-date"></span>
								</div>
								<div id="wrapper_add" style="margin-top: -1px;"></div>
							</div>
						</div>
						<div class="form-group row pb-0">
							<div class="col-sm-3">
								<label class="control-label mt-2" style="border: 0px;">출산 병원</label>
							</div>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="" value="<sec:authentication property="principal.hospital" />">
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" id="">비밀번호 변경</button>
					<button type="button" class="btn btn-secondary" id="">정보 저장</button>
					<button type="button" class="btn btn-info" id="">취소</button>
				</div>
			</div>
		</div>
	</div>
	</sec:authorize>
<script>
$(document).ready(function() {
	$('#updateUserInfo').click(function() {
		$('#nav-updateinfo-modal').modal('show');
	})
})
</script>
