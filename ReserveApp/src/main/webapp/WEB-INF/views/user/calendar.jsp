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
		nowIndicator: true,
		events : [],
		eventClick: function(info) {
			if(info.event._def.title == '선택') {
				
				let clickedDate = info.event.start;
				let param = {
						rsv_month : cfn_yearMonthFormat(clickedDate),
						rsv_date : cfn_tuiDateFormat(clickedDate)
				}
				
				ajaxCom.getAvailableList(param);
				
				$('#reservation-modal').modal('show');
			}
		},
		customButtons: {
			refresh: {
				text: '',
				click: function() {
					let currentDate = cfn_yearMonthFormat(calendar.getDate());
					ajaxCom.getAvailableDate(currentDate);
				}
			}
		},
	});
	calendar.render();
	
	let refreshButton = $('.fc-refresh-button');
	let spanTag = $('<span>').addClass('btn-label').html('<i class="fas fa-sync"></i>');
	refreshButton.append(spanTag);
	
	$('.fc-prev-button').attr('title', '이전 달');
	$('.fc-next-button').attr('title', '다음 달');
	
	$('.fc-prev-button').click(function() {
		let currentDate = cfn_yearMonthFormat(calendar.getDate());
		ajaxCom.getAvailableDate(currentDate);
	})

	$('.fc-next-button').click(function() {
		let currentDate = cfn_yearMonthFormat(calendar.getDate());
		ajaxCom.getAvailableDate(currentDate);
	})
	
	ajaxCom = {
		getAvailableDate: function(rsvMonth){
			let param;

			param = {
				rsv_month : rsvMonth
			}
			
			$.doPost({
				url		: "/user/getAvailableDate",
				data	: param,
				success	: function(result){
					if(result.calendarList.length > 0){
						calendar.removeAllEvents();
						
						result.calendarList.forEach(item => {
							if(item.rsv_cnt > 0){
								if(item.rsv_date == cfn_tuiDateFormat(new Date())){
									item.is_available = 'NO'
								}
								
								let liColor;
								let title;

								if(item.is_available == 'YES'){
									liColor = '#716aca';
									title = '선택';
								} else {
									liColor = 'gray';
									title = '마감';
								}
								
								calendar.addEvent({
									title		: title,
									start		: item.rsv_date,
									end			: item.rsv_date,
									color		: liColor
								});
							}
						})
						
						calendar.refetchEvents();
						
						const fcEvents = $('.fc-event');
						for (let i = 0; i < fcEvents.length; i++) {
							const eventTitle = $(fcEvents[i]).find('.fc-event-title').text();
							if (eventTitle === '선택') {
								$(fcEvents[i]).css('cursor', 'pointer');
							}
						}
						
						if(cfn_yearMonthFormat(new Date()) == cfn_yearMonthFormat(calendar.getDate())) {
							$('.fc-prev-button').attr('disabled', true);
						} else {
							$('.fc-prev-button').attr('disabled', false);
						}
						
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		getAvailableList: function(param){
			$.doPost({
				url		: "/user/getAvailableData",
				data	: param,
				success	: function(result){
					fnCom.createOption(result);
				}
			})
		},
		saveReservation: function(param){
			$.doPost({
				url		: "/user/saveReservation",
				data	: param,
				success	: function(result){
					if(result.msg == 'success'){
						alert('예약되었습니다.\n 예약 확인 페이지에서 예약 내역을 확인할 수 있습니다.');
						$('#reservation-modal').modal('hide');
					} else if(result.msg == 'Reservation not allowed'){
						alert('기존 예약을 취소 한 후 예약해주세요.\n 예약 관련 문의사항이 있을 경우 마사지샵에 연락해주세요.');
						return false;
					} else if(result.msg == 'Duplicate reservation found'){
						alert('동일 시간대에 이미 예약하셨습니다. 예약 내역을 확인해주세요.');
						return false;
					} else {
						alert('오류가 발생하였습니다. 잠시 후 다시 시도해주세요.');
						return false;
					}
				}
			})
		}
	};
	
	fnCom = {
		createOption: function(data){
			$("#selectRsv").empty();
			let rsvInfo = data.reservationTimeInfo;
			let availableData = data.availableData;
			
			let keysWithValueNotZero = [];
			let keys = Object.keys(availableData);

			keys.forEach(function(key) {
				let value = availableData[key];
				if (value > 0) {
					keysWithValueNotZero.push(key);
				}
			});
			
			let opt;
			
			opt = '<option value="none">예약 시간 선택</option>'
			keysWithValueNotZero.sort().forEach(key => {
				let name = key+'_name';
				opt += '<option value="'+key+'">'+rsvInfo[name].substring(0,5)+'</option>'
			})
			
			let dateVal = data.rsv_date.split('-');
			$('#selectDate').text(dateVal[0] + '년 ' + dateVal[1] + '월 ' + dateVal[2] + '일');
			
			$('#rsvDate').val(data.rsv_date);
			
			$('#selectRsv').append(opt);
		}
	};
	
	btnCom = {
		btn_close: function(){
			$('#reservation-modal').modal('hide');
		},
		btn_save_rsv: function(){
			if($('#selectRsv').val()!='none'){
				let param = {
					rsv_month	: $('#rsvDate').val().substring(0,7),
					rsv_date	: $('#rsvDate').val(),
					select_time : $('#selectRsv').val(),
					flag		: 'i'
				}
				ajaxCom.saveReservation(param);
			} else {
				alert('예약 시간을 선택해주세요');
				return false;
			}
		}
	};

	ajaxCom.getAvailableDate(cfn_yearMonthFormat(new Date()));
});

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
.fc-event-title-container{
	text-align: center;
}
.fc-event-title{
	font-size:15px;
}
</style>

<div class="main-panel">
	<div class="content">
		<div class="page-inner">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<div id='calendar'></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="reservation-modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="updateInfo_modalTitle">예약 하기</h4>
			</div>
			<div class="modal-body">
				<div class="col-12">
					<div class="form-group pb-0">
						<div class="row">
							<div class="col-sm-3 mb-2">
								<label class="control-label mt-2">선택한 시간</label>
							</div>
							<div class="col-sm-9 p-2 pl-3">
								<span id="selectDate"></span>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-3">
								<label for="selectRsv" class="control-label mt-2">예약 가능한 시간</label>
							</div>
							<div class="col-sm-9">
								<select class="form-control" id="selectRsv"></select>
							</div>
						</div>
						
						
						<div style="display:none;">
							<input type="text" id="rsvDate">
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" id="btn_save_rsv">예약하기</button>
				<button type="button" class="btn btn-info" id="btn_close">취소</button>
			</div>
		</div>
	</div>
</div>