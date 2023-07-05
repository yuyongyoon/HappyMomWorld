<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<div class="sidebar">
	<div class="sidebar-background"></div>
	<div class="sidebar-wrapper scrollbar-inner">
		<div class="sidebar-content">
			<ul class="nav">
				<li class="nav-item">
					<a href="/">
						<i class="fas fa-calendar"></i>
						<p>예약 캘린더</p>
					</a>
				</li>
				<li class="nav-item">
					<a href="/">
						<i class="fas fa-unlock-alt"></i>
						<p>정보 변경</p>
					</a>
				</li>
				<li class="nav-item">
					<a href="/">
						<i class="fas fa-tasks"></i>
						<p>예약 확인</p>
					</a>
				</li>
				<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
					<li class="nav-section">
						<span class="sidebar-mini-icon">
							<i class="fa fa-ellipsis-h"></i>
						</span>
						<h4 class="text-section">Administrator</h4>
					</li>
					<li class="nav-item">
						<a data-toggle="collapse" href="#base">
							<i class="fas fa-desktop"></i>
							<p>관리자 메뉴</p>
							<span class="caret"></span>
						</a>
						<div class="collapse" id="base">
							<ul class="nav nav-collapse">
								<li>
									<a href="/admin/user">
										<span class="sub-item">회원 관리</span>
									</a>
								</li>
								<li>
									<a href="">
										<span class="sub-item">예약 관리</span>
									</a>
								</li>
							</ul>
						</div>
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