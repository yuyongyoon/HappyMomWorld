<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Login</title>
		<meta content='width=device-width, initial-scale=1.0, shrink-to-fit=no' name='viewport' />
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
	</head>
	<body class="login">
		<div class="wrapper wrapper-login">
			<div class="container container-login animated fadeIn" style="width:500px">
				<h3 class="text-center">Sign In</h3>
					<form class="login-form" method="post" name="f" action="loginProc">
						<div class="form-group form-floating-label">
							<input id="id" name="id" type="text" class="form-control input-border-bottom" required>
							<label for="id" class="placeholder">Username</label>
						</div>
						<div class="form-group form-floating-label">
							<input id="password" name="password" type="password" class="form-control input-border-bottom" required>
							<label for="password" class="placeholder">Password</label>
							<div class="show-password">
								<i class="flaticon-interface"></i>
							</div>
						</div>
						<div class="row form-sub m-0">
							<div class="custom-control custom-checkbox">
								<input type="checkbox" class="custom-control-input" id="rememberme">
								<label class="custom-control-label" for="rememberme">Remember Me</label>
							</div>
							
							<a href="" class="link float-right">Forget Password ?</a>
						</div>
						<div class="form-action mb-3">
							<button class="btn btn-secondary btn-rounded btn-login" type="submit">Sign In</button>
						</div>
					</form>
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
			})
		</script>
	</body>
</html>

