<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%> --%>

<div class="sidebar sidebar-hide-to-small sidebar-shrink sidebar-gestures">
	<div class="nano">
		<div class="nano-content">
			<ul>
				<div class="logo">
					<a href="/"><img src="/static/assets/ci/aida_ci.png" alt="" style="width:200px;"/></a>
					<span>Marketing Analysis System</span>
				</div>
				<li class="label">Main</li>
				<li><a href="/"><i class="ti-home"></i>대시보드</a></li>

<!-- 				<li class="label">판매</li> -->
<!-- 				<li><a href="/sales/salesManagement"><i class="ti-receipt"></i> 판매 관리 </a></li> -->
<!-- 				<li><a href="/sales/salesAnalysis"><i class="ti-bar-chart-alt"></i> 판매 분석 </a></li> -->
<!-- 				<li><a href="/sales/salesPrediction"><i class="ti-stats-up"></i> 판매 예측 </a></li> -->
				
<!-- 				<li class="label">제품리뷰</li> -->
<!-- 				<li><a href="/review/review"><i class="ti-comment-alt"></i> 리뷰 관리 </a></li> -->
<!-- 				<li><a href="/review/reviewAnalysis"><i class="ti-target"></i> 리뷰 감정 분석 </a></li> -->
<!-- 				<li><a href="/review/reviewRank"><i class="ti-thumb-up"></i> 제품 리뷰 순위 </a></li> -->
				
<!-- 				<sec:authorize access="hasAnyRole('ROLE_ADMIN', 'SUPERUSER')"> -->
<!-- 					<li class="label">인스타그램</li> -->
<!-- 					<li><a href="/aida/hashTagSummary"><i class="ti-archive"></i> 인스타그램 분석 </a></li> -->
<!-- 				</sec:authorize> -->
				
<!-- 				<li class="label">리포트</li> -->
<!-- 				<li><a href="/report/incomeStatement"><i class="ti-view-list-alt"></i> 매출 종합 분석</a></li> -->
<!-- 				<li><a href="/report/vvipMember"><i class="ti-star"></i> VVIP 회원관리 </a></li> -->
								
<!-- 				<sec:authorize access="hasAnyRole('ROLE_ADMIN')"> -->
					<li class="label" data-link="admin">관리자</li>
<!-- 					<li data-link="admin"><a href="/instagram/viewInfluencerManagement"><i class="ti-view-list-alt"></i> 인플루언서 관리 </a></li> -->
					<li data-link="admin"><a href="/admin/user"><i class="ti-user"></i> 사용자 관리 </a></li>

<!-- 					<li data-link="admin"><a href="/admin/code2"><i class="ti-harddrives"></i> 코드 관리 </a></li> -->
<!-- 					<li data-link="admin"><a href="/admin/member"><i class="ti-id-badge"></i> 회원 관리 </a></li> -->
<!-- 					<li data-link="admin"><a href="/admin/customer"><i class="ti-agenda"></i> 거래처 관리 </a></li> -->
<!-- 					<li data-link="admin"><a href="/admin/item"><i class="ti-clipboard"></i> 품목 관리 </a></li> -->
<!-- 					<li data-link="admin"><a href="/admin/stock"><i class="ti-dashboard"></i> 재고 관리 </a></li> -->
<!-- 				</sec:authorize> -->
			</ul>
		</div>
	</div>
</div>