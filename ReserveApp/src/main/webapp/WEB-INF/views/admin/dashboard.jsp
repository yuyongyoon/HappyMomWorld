<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
$(document).ready(function() {
	let calendarEl = document.getElementById('calendar');
	let calendarList = [];
	calendar = new FullCalendar.Calendar(calendarEl, {
		initialView: 'dayGridMonth',
		height: 700,
		timeZone: 'local',
		locale: 'ko',
		fixedWeekCount:false,
		headerToolbar :{
			start:'',
			center:'prev,title,next',
			end: 'refresh'
		},
		eventTimeFormat: {
			hour: '2-digit',
			minute: '2-digit',
			hour12: false,
			meridiem: false
		},
		nowIndicator: true,
		events : [],
		eventClick: function(info) {
			ajaxCom.getSeletedDateReservationList(cfn_tuiDateFormat(info.event._instance.range.start));
		},
		customButtons: {
			refresh: {
				text: '',
				click: function() {
					let currentDate = cfn_yearMonthFormat(calendar.getDate());
					ajaxCom.getCalendarEvent(currentDate);
				}
			}
		},
	});
	calendar.render();
	
	let refreshButton = $('.fc-refresh-button');
	let spanTag = $('<span>').addClass('btn-label').html('<i class="fas fa-sync"></i>');
	refreshButton.append(spanTag);
	
	$('.fc-prev-button').click(function() {
		let currentDate = cfn_yearMonthFormat(calendar.getDate());
		ajaxCom.getCalendarEvent(currentDate);
	})

	$('.fc-next-button').click(function() {
		let currentDate = cfn_yearMonthFormat(calendar.getDate());
		ajaxCom.getCalendarEvent(currentDate);
	})
	
	ajaxCom = {
		getCalendarEvent: function(rsvMonth){
			let param;

			if($('#select-branch').val() != '' && $('#role').val() == 'SUPERADMIN'){
				param = {
					rsv_month : rsvMonth,
					super_branch_code : $('#select-branch').val()
				}
			} else if($('#select-branch').val() == '' && $('#role').val() == 'SUPERADMIN'){
				return false;
			} else {
				param = {
					rsv_month : rsvMonth
				}
			}
			
			$.doPost({
				url		: "/admin/getCalendarEvent",
				data	: param,
				success	: function(result){
					if(result.calendarList.length > 0){
						calendar.removeAllEvents();
						
						result.calendarList.forEach(item => {
							let liColor;
							item.reservation_cnt > 0 ? liColor = '#716aca' : liColor = 'gray';
							calendar.addEvent({
								title		: '예약: ' + item.reservation_cnt + '건',
								start		: item.rsv_date,
								end			: item.rsv_date,
								color		: liColor
							});
						})
						
						calendar.refetchEvents()
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		getSeletedDateReservationList: function(date){
			let param;
			
			if($('#select-branch').val() != '' && $('#role').val() == 'SUPERADMIN'){
				param = {
					rsv_date : date,
					super_branch_code : $('#select-branch').val()
				}
			} else {
				param = {
					rsv_date : date
				}
			}
			
			$.doPost({
				url		: "/admin/getSeletedDateReservationList",
				data	: param,
				success	: function(result){
					fnCom.createTr(result.reservationList)
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
			
		}
	};
	
	fnCom = {
		createTr : function(data){
			$("#reservation_tbody").empty();
			
			data.forEach((reservation, index) => {
				let row = '<tr><td>'+Number(index+1)+'</td><td>'+reservation.rsv_date+'</td><td>'+reservation.user_id+'</td>'+reservation.user_id+'<td>'+reservation.reservation_time+'</td></tr>';
				
				$("#reservation_tbody").append(row);
			});
		},
	}

	ajaxCom.getCalendarEvent(cfn_yearMonthFormat(new Date()));
});

$('#select-branch').on('change', function(){
	ajaxCom.getCalendarEvent(cfn_yearMonthFormat(new Date()));
})


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
	margin-right:10px !important;
	height:30px !important;
}
.fc-next-button{
	float:left !important;
	margin-left:10px !important;
	height:30px !important;
}
.fc-prev-button span,.fc-next-button span{
	line-height: 15px;
}
.fc-prev-button, .fc-next-button, .fc-refresh-button{
	background: #6f42c1 !important;
	color: white !important;
	border: 0px !important;
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
.fc-event {
	cursor: pointer;
}
.fc-event-title-container{
	text-align: center;
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
					<div class="card" style="min-height:390px;">
						<div class="card-body pb-0" style="margin-bottom:53px;">
							<h2 class="mb-1 fw-bold">예약 리스트</h2>
							<div class="table-responsive" style="overflow-y: auto;max-height: 300px;">
								<table class="table table-head-bg-secondary">
									<thead>
										<tr>
											<th scope="col" id="idx">#</th>
											<th scope="col" id="rsv_date">예약일</th>
											<th scope="col" id="user_id">아이디</th>
											<th scope="col" id="reservation_time">예약시간</th>
										</tr>
									</thead>
									<tbody id="reservation_tbody">
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="card">
						<div class="card-body">
							<ol class="activity-feed" style="font-size: 15px;margin-bottom: 0px;">
								<li class="feed-item feed-item-secondary">
									<time class="date" datetime="9-25">1</time>
<!-- 									<span class="text">Responded to need <a href="#">"Volunteer opportunity"</a></span> -->
									<a href="/admin/reservation_master"><span class="text">예약 생성은 2023년 8월까지 되어 있습니다.</span></a>
								</li>
								<li class="feed-item feed-item-success">
									<time class="date" datetime="9-24">2</time>
<!-- 									<span class="text">Added an interest <a href="#">"Volunteer Activities"</a></span> -->
									<a href="/admin/reservation_status"><span>8월 예약 생성 30건 중 15건이 예약 되었습니다.</span></a>
								</li>
								<li class="feed-item feed-item-info">
									<time class="date" datetime="9-23">3</time>
<!-- 									<span class="text">Joined the group <a href="single-group.php">"Boardsmanship Forum"</a></span> -->
									<a href="/admin/user"><span class="text">어제 가입한 회원은 총 3명 입니다.</span></a>
								</li>
								<li class="feed-item feed-item-warning">
									<time class="date" datetime="9-21">4</time>
<!-- 									<span class="text">Responded to need <a href="#">"In-Kind Opportunity"</a></span> -->
									<a href="/admin/user"><span>가입 후 예약하지 않은 회원은 10명입니다.</span></a>
								</li>
							</ol>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>