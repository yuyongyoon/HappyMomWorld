<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
<!--   Core JS Files   -->
<script src="/static/assets/js/core/jquery.3.2.1.min.js"></script>
<script src="/static/assets/js/core/popper.min.js"></script>
<script src="/static/assets/js/core/bootstrap.min.js"></script>

<!-- jQuery UI -->
<script src="/static/assets/js/plugin/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
<script src="/static/assets/js/plugin/jquery-ui-touch-punch/jquery.ui.touch-punch.min.js"></script>
<script src="/static/assets/js/plugin/bootstrap-toggle/bootstrap-toggle.min.js"></script>

<!-- jQuery Scrollbar -->
<script src="/static/assets/js/plugin/jquery-scrollbar/jquery.scrollbar.min.js"></script>

<script src="/static/assets/js/ready.min.js"></script>

<!-- Grid & tui -->
<link rel="stylesheet" href="/static/common/css/tui/tui-pagination.css" />
<link rel="stylesheet" href="/static/common/css/tui/tui-grid.css" />
<link rel="stylesheet" href="/static/common/css/tui/tui.css" />
<link rel="stylesheet" href="/static/common/css/tui/tui-date-picker.css" />
<script src="/static/common/js/tui/tui-pagination.js"></script>
<script src="/static/common/js/tui/tui-com.js"></script>
<script src="/static/common/js/tui/tui-grid.js"></script>
<script src="/static/common/js/tui/FileSaver.min.js"></script>
<script src="/static/common/js/tui/xlsx.full.min.js"></script>
<script src="/static/common/js/tui/xlsx.style.min.js"></script>
<script src="/static/common/js/tui/tui-date-picker.js"></script>
<script src="/static/common/fullcalendar-6.1.8/dist/index.global.js"></script>

<!-- CSS Files -->
<link rel="stylesheet" href="/static/assets/css/bootstrap.min.css">
<link rel="stylesheet" href="/static/assets/css/azzara.min.css">

<!-- 공통코드 -->
<link rel="stylesheet" href="/static/common/css/common.css" />
<script src="/static/common/js/common.js"></script>