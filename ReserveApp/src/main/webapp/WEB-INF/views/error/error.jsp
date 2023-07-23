<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<title>Error</title>
	<link href="https://fonts.googleapis.com/css?family=Nunito:400,700" rel="stylesheet">
	<link type="text/css" rel="stylesheet" href="/static/common/css/errorStyle.css" />
</head>

<body>

	<div id="notfound">
		<div class="notfound">
			<div class="notfound-404"></div>
			<h1>${errorCode}</h1>
			<h2 style="margin-bottom:10px">Oops!</h2>
			<h2 style="margin-bottom:10px">${errorMessage}</h2>
<!-- 			<p>Sorry but the page you are looking for does not exist, have been removed. name changed or is temporarily unavailable</p> -->
			<a href="/">메인페이지로 이동</a>
		</div>
	</div>

</body>

</html>
