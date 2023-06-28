<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%> --%>

<div class="header">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<div class="float-left">
<!-- 					<div class="hamburger sidebar-toggle"> -->
<!-- 						<span class="line"></span> -->
<!-- 						<span class="line"></span> -->
<!-- 						<span class="line"></span> -->
<!-- 					</div> -->
				</div>
				<div class="float-right">
					<div class="dropdown dib">
						<div class="header-icon" data-toggle="dropdown">
							<span class="user-avatar"><i class="ti-angle-down f-s-10"></i></span> <!-- <sec:authentication property="principal.user_name"/>(<sec:authentication property="principal.username"/>) -->
							<div class="drop-down dropdown-profile dropdown-menu dropdown-menu-right">
								<div class="dropdown-content-body">
									<ul>
										<li id="logOut">
											<a href="#" onclick="document.getElementById('logout').submit();">
												<i class="ti-power-off"></i><span>Logout</span>
											</a>
											<form id="logout" action="/logout" method="POST"></form>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<style>
.header{
	height:50px;	
}
</style>
