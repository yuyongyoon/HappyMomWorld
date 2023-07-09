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
						<a href="/admin/search"><i class="far fa-calendar-alt"></i><p>예약 현황 조회</p></a>
					</li>
					<li class="nav-item">
						<a href="/admin/master"><i class="far fa-calendar-plus"></i><p>마스터 관리</p></a>
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
		$('.sidebar .nav-item').removeClass('active'); // .sidebar .nav-item에서 active 클래스 제거
		$(this).addClass('active'); // 클릭한 .sidebar .nav-item에 active 클래스 추가
	});
});
</script>