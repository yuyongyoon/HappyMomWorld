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
				<ul class="navbar-nav topbar-nav ml-md-auto align-items-center">
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
					<li class="nav-item dropdown hidden-caret">
						<a class="nav-link dropdown-toggle" href="#" id="userMenu" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							<i class="la flaticon-settings"></i>
						</a>
						
						<ul class="dropdown-menu dropdown-user animated fadeIn" aria-labelledby="userMenu">
							<sec:authorize access="hasAnyRole('ROLE_USER')">
								<li>
									<a class="dropdown-item" href="/user/userInfo">정보 변경</a>
								</li>
								<li>
									<a class="dropdown-item" href="/user/reservation">예약 확인</a>
								</li>
							</sec:authorize>
							<%--<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
								<li>
									<a class="dropdown-item" href="/admin/user">회원 관리</a>
								</li>
								<li>
									<a class="dropdown-item" href="/admin/search">예약 현황 조회</a>
								</li>
								<li>
									<a class="dropdown-item" href="/admin/management">예약 관리</a>
								</li>
								<li>
									<a class="dropdown-item" href="/admin/master">마스터 관리</a>
								</li>
							</sec:authorize> --%>							
							<!-- nav 추가 -->
							<li id="updateUserInfo"> 
								<a class="dropdown-item" href="#" onclick="document.getElementById('updateUserInfo').submit();">
									<span>사용자 정보 수정</span>
								</a>
								<form id="updateUserInfo" action="/updateUserInfo" method="POST"></form>
							</li>
							<li id="logOut">
								<a class="dropdown-item" href="#" onclick="document.getElementById('logout').submit();">
									<span>로그아웃</span>
								</a>
								<form id="logout" action="/logout" method="POST"></form>
							</li>
						</ul>
					</li>
				</ul>
			</div>
		</nav>
		<!-- End Navbar -->
	</div>