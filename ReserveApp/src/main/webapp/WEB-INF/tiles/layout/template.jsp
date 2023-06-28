<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!DOCTYPE html>
<html  lang="ko">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		
		<title>AIDA Marketing Analysis System</title>
	</head>
	<body>
		<tiles:insertAttribute name="common" />
		<tiles:insertAttribute name="nav" />
		<tiles:insertAttribute name="sidebar" />
		<tiles:insertAttribute name="body" />	
		<img id="img_loading" src="/static/assets/images/loading/loading2.gif" style="position:absolute;width:400px;z-index:9999;display:none;"/>
	</body>
</html>