<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
	<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>Login</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		
		<link rel="icon" href="/static/assets/img/icon.ico" type="image/x-icon"/>
	
		<!-- Fonts and icons -->
		<script src="/static/assets/js/plugin/webfont/webfont.min.js"></script>
		<script>
			WebFont.load({
				google: {"families":["Open+Sans:300,400,600,700"]},
				custom: {"families":["Flaticon", "Font Awesome 5 Solid", "Font Awesome 5 Regular", "Font Awesome 5 Brands"], urls: ['/static/assets/css/fonts.css']},
				active: function() {
					sessionStorage.fonts = true;
				}
			});
		</script>
		
		<!-- CSS Files -->
		<link rel="stylesheet" href="/static/assets/css/bootstrap.min.css">
		<link rel="stylesheet" href="/static/assets/css/azzara.min.css">
		
		<style>
			html, body {
				width: 100%;
				height: 100%;
				margin: 0;
				padding: 0;
				overflow: hidden;
			}

			.wrapper.wrapper-login {
				position: fixed;
				top: 0;
				left: 0;
				width: 100%;
				height: 100%;
				overflow: auto;
			}

			.container.container-login {
				height: 100%;
				display: flex;
				flex-direction: column;
				justify-content: center;
				align-items: center;
			}
		</style>
		
	</head>
	<body class="login">
		<div class="wrapper wrapper-login">
			<div class="container container-login animated fadeIn">
				<h3 class="text-center">로그인</h3>
					<form class="login-form" method="post" name="f" action="loginProc">
						<div class="form-group form-floating-label">
							<input id="id" name="id" type="text" class="form-control input-border-bottom" required>
							<label for="id" class="placeholder">ID</label>
						</div>
						<div class="form-group form-floating-label">
							<input id="password" name="password" type="password" class="form-control input-border-bottom" required>
							<label for="password" class="placeholder">Password</label>
							<div class="show-password">
								<i class="flaticon-interface"></i>
							</div>
						</div>
						<div class="row form-sub m-0">
							<div class="custom-control custom-checkbox" tabindex="0" data-toggle="tooltip" data-placement="bottom" title="30일간 유지됩니다.">
								<input type="checkbox" class="custom-control-input" id="rememberme" name="rememberme">
								<label class="custom-control-label" for="rememberme">로그인 유지하기</label>
							</div>
							
							<span class="link float-right" id="forgotPwdSpan" style="color:blue;cursor:pointer;">Forget Password ?</span>
						</div>
						<div id="forgotPwdDiv" style="display:none;">
							<span class="float-right" style="color:red;">관리자에게 문의 바랍니다.</span>
						</div>
						<div class="form-action mb-3">
							<button class="btn btn-secondary btn-rounded btn-login" type="submit">로그인</button>
						</div>
					</form>
					<div class="login-account">
						<a href="#" id="show-signup" class="link">회원 가입</a>
					</div>
			</div>
			
			<div class="container container-signup animated fadeIn">
				<h3 class="text-center">Sign Up</h3>
				<div class="login-form">
					<div class="form-group form-floating-label">
						<input  id="fullname" name="fullname" type="text" class="form-control input-border-bottom" required>
						<label for="fullname" class="placeholder">Fullname</label>
					</div>
					<div class="form-group form-floating-label">
						<input  id="email" name="email" type="email" class="form-control input-border-bottom" required>
						<label for="email" class="placeholder">Email</label>
					</div>
					<div class="form-group form-floating-label">
						<input  id="passwordsignin" name="passwordsignin" type="password" class="form-control input-border-bottom" required>
						<label for="passwordsignin" class="placeholder">Password</label>
						<div class="show-password">
							<i class="flaticon-interface"></i>
						</div>
					</div>
					<div class="form-group form-floating-label">
						<input  id="confirmpassword" name="confirmpassword" type="password" class="form-control input-border-bottom" required>
						<label for="confirmpassword" class="placeholder">Confirm Password</label>
						<div class="show-password">
							<i class="flaticon-interface"></i>
						</div>
					</div>
					<div class="row form-sub m-0">
						<div class="custom-control custom-checkbox">
							<input type="checkbox" class="custom-control-input" name="agree" id="agree">
							<label class="custom-control-label" for="agree">I Agree the terms and conditions.</label>
						</div>
					</div>
					<div class="form-action">
						<a href="#" id="show-signin" class="btn btn-danger btn-rounded btn-login mr-3">Cancel</a>
						<a href="#" class="btn btn-primary btn-rounded btn-login">Sign Up</a>
					</div>
				</div>
			</div>
		</div>
		
		<script src="/static/assets/js/core/jquery.3.2.1.min.js"></script>
		<script src="/static/assets/js/plugin/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
		<script src="/static/assets/js/core/popper.min.js"></script>
		<script src="/static/assets/js/core/bootstrap.min.js"></script>
		<script src="/static/assets/js/ready.js"></script>
		<script>
			$(document).ready(function() {
				const urlSearchParams = new URLSearchParams(window.location.search); 
				const params = Object.fromEntries(urlSearchParams.entries());
			
				if (params.error === 'true' && params.exception === 'Invaild Username or Password') {
					alert('ID 또는 패스워드를 확인해주세요')
				}
				
				$('#forgotPwdSpan').click(function() {
					$('#forgotPwdDiv').css('display','block')
				})
			})
		</script>
	</body>
</html>

