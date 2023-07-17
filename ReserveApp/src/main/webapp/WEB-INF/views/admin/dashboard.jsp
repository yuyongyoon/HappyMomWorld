<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
$(document).ready(function() {
	let calendarEl = document.getElementById('calendar');
	let calendarList = [];
	calendar = new FullCalendar.Calendar(calendarEl, {
		initialView: 'dayGridMonth',
		height: 750,
		timeZone: 'local',
		locale: 'ko',
		fixedWeekCount:false,
		headerToolbar :{
			start:'',
			center:'prev,title,next',
			end:''
		},
		eventTimeFormat: {
			hour: '2-digit',
			minute: '2-digit',
			hour12: false,
			meridiem: false
		},
		nowIndicator: true, // 현재 시간 마크        
		dayMaxEvents: true, // 이벤트가 오버되면 높이 제한 (+ 몇 개식으로 표현)
		events : [],
	});
	calendar.render();
}); //$(document).ready END
</script>

<style>
a:link {
	color : black;
}
.fc-daygrid-event{
	height:25px !important;
	margin-top:1px !important;
	margin-bottom:1px !important;
}
.fc-view-harness-active > .fc-view{
	margin-top:0px !important;
}
.fc-prev-button{
	float:left !important;
	margin-right:5px !important;
	height:30px !important;
}
.fc-next-button{
	float:left !important;
	margin-left:5px !important;
	height:30px !important;
}
.fc-prev-button span,.fc-next-button span{
	line-height: 15px;
}
.fc-toolbar-title{
	float:left !important;
}
.fc-header-toolbar{
	margin-top:5px !important;
	margin-bottom:5px !important;
}
.calendar_control_panel{
	width:100%;
	height:20px;
}
.fc-toolbar-chunk .fc-button-group .fc-saveEventBtn-button {
	margin-right: 10px;
	border-radius: 2px;
}
</style>


<div class="main-panel">
	<div class="content">
		<div class="page-inner">
			<div class="row">
				<div class="col-md-8">
					<div class="card">
						<div class="card-body">
							<div id='calendar'></div>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<div class="card">
						<div class="card-body pb-0">
							<h4 class="mb-1 fw-bold">Tasks Progress</h4>
							<div id="task-complete" class="chart-circle mt-4 mb-3"></div>
						</div>
					</div>
					<div class="card">
						<div class="card-body">
							<h4 class="mb-1 fw-bold">Tasks Progress</h4>
							<div id="task-complete" class="chart-circle mt-4 mb-3"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>