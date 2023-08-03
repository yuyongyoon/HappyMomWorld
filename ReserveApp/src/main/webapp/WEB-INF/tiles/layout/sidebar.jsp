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
					<li class="nav-item">
						<a href="/admin/dashboard"><i class="fas fa-desktop"></i><p>대시보드</p></a>
					</li>
					<li class="nav-item">
						<a href="/admin/user"><i class="fas fa-user-alt"></i><p>회원 관리</p></a>
					</li>
					<li class="nav-item">
						<a href="/admin/reservation_status"><i class="far fa-calendar-alt"></i><p>예약 현황</p></a>
					</li>
					<li class="nav-item">
						<a href="/admin/reservation_master"><i class="fas fa-cog"></i><p>예약 마스터 관리</p></a>
					</li>
					<li class="nav-item">
						<a href="/admin/info_master"><i class="fas fa-info-circle"></i><p>지점 정보 관리</p></a>
					</li>
				</sec:authorize>
				
				<sec:authorize access="hasAnyRole('ROLE_SUPERADMIN')">
					<li class="nav-item">
						<a href="/admin/branch_manager"><i class="fas fa-code-branch"></i><p>지점 관리</p></a>
					</li>
					<li class="nav-item">
						<a href="/admin/qrcode_manager"><i class="fas fa-qrcode"></i><p>QR코드 관리</p></a>
					</li>
				</sec:authorize>
				
				<sec:authorize access="hasAnyRole('ROLE_USER')">
					<li class="nav-item">
						<a href="/user/calendar"><i class="fas fa-calendar"></i><p>예약 캘린더</p></a>
					</li>
					<li class="nav-item">
						<a href="/user/reservation"><i class="fas fa-tasks"></i><p>예약 확인</p></a>
					</li>
				</sec:authorize>
			</ul>
		</div>
	</div>
</div>
		
<script>
$(document).ready(function() {
	$('.sidebar .nav-item').click(function() {
		$('.sidebar .nav-item').removeClass('active');
		$(this).addClass('active');
	});
});
</script>