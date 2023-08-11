<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<div class="sidebar">
	<div class="sidebar-background"></div>
	<div class="sidebar-wrapper scrollbar-inner">
		<div class="sidebar-content">
			<ul class="nav">
				<sec:authorize access="hasAnyRole('ROLE_SUPERADMIN', 'ROLE_ADMIN')">
					<li class="nav-section">
						<span class="sidebar-mini-icon">
							<i class="fa fa-ellipsis-h"></i>
						</span>
						<h4 class="text-section">Administrator</h4>
					</li>
					<li class="nav-item" id="dashboard">
						<a href="/admin/dashboard"><i class="fas fa-desktop"></i><p>예약 관리</p></a>
					</li>
					<li class="nav-item" id="user">
						<a href="/admin/user"><i class="fas fa-user-alt"></i><p>회원 관리</p></a>
					</li>
					<li class="nav-item" id="reservation_master">
						<a href="/admin/reservation_master"><i class="far fa-calendar-alt"></i><p>예약 생성</p></a>
					</li>
					<li class="nav-item" id="info_master">
						<a href="/admin/info_master"><i class="fas fa-info-circle"></i><p>지점 정보 관리</p></a>
					</li>
				</sec:authorize>
				
				<sec:authorize access="hasAnyRole('ROLE_SUPERADMIN')">
					<li class="nav-item" id="branch_manager">
						<a href="/admin/branch_manager"><i class="fas fa-code-branch"></i><p>지점 관리</p></a>
					</li>
					<li class="nav-item" id="qrcode_manager">
						<a href="/admin/qrcode_manager"><i class="fas fa-qrcode"></i><p>QR코드 관리</p></a>
					</li>
				</sec:authorize>
				
				<sec:authorize access="hasAnyRole('ROLE_USER')">
					<li class="nav-item" id="calendarli">
						<a href="/user/calendar"><i class="fas fa-calendar"></i><p>예약 캘린더</p></a>
					</li>
					<li class="nav-item" id="reservation">
						<a href="/user/reservation"><i class="fas fa-tasks"></i><p>예약 확인</p></a>
					</li>
				</sec:authorize>
			</ul>
		</div>
	</div>
</div>
<style>
p{
	font-size: 16px!important;
	font-weight: bolder!important;
}
</style>
<script>
$(document).ready(function() {
	let url = window.location.href.split('/');
	let param = url[url.length-1];
	
	if(param == 'dashboard'){
		$('#dashboard').addClass('active');
	} else if(param == 'user'){
		$('#user').addClass('active');
	} else if(param == 'reservation_status'){
		$('#reservation_status').addClass('active');
	} else if(param == 'reservation_master'){
		$('#reservation_master').addClass('active');
	} else if(param == 'info_master'){
		$('#info_master').addClass('active');
	} else if(param == 'branch_manager'){
		$('#branch_manager').addClass('active');
	} else if(param == 'qrcode_manager'){
		$('#qrcode_manager').addClass('active');
	} else if(param == 'reservation'){
		$('#reservation').addClass('active');
	} else if(param == 'calendar'){
		$('#calendarli').addClass('active');
	}

});
</script>