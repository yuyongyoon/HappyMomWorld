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
	
	let recentJoinData;
	let recentRsvData;
	let nonRsvData;
	
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
							if(item.open_rsv_cnt != 0) {
								let liColor;
								item.reservation_cnt > 0 ? liColor = '#716aca' : liColor = 'gray';
								calendar.addEvent({
									title		: '예약: ' + item.reservation_cnt + '건',
									start		: item.rsv_date,
									end			: item.rsv_date,
									color		: liColor
								});
							}
							
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
			
		},
		getDashboardInfo : function(){
			let param;
			
			if($('#select-branch').val() != '' && $('#role').val() == 'SUPERADMIN') {
				param = {
					super_branch_code : $('#select-branch').val()
				}
			} else {
				param = {
					branch_code : ''
				}
			}
			
			$.doPost({
				url		: "/admin/getDashInfo",
				data	: param,
				success	: function(result){
					if(result.rsvLastMonth != null) {
						$('#rsvLstMonth').text(result.rsvLastMonth.rsv_month);
					} else {
						$('#rsvLstMonth').text('생성된 예약이 없습니다.');
					}
					
					if(result.recentJoinData.length > 0) {
						$('#recentJoinCnt').text(result.recentJoinData.length + ' 명');
						recentJoinData = result.recentJoinData;
					} else {
						$('#recentJoinCnt').text(0 + ' 건');
					}
					
					if(result.recentRsvData.length > 0) {
						$('#recentRsvCnt').text(result.recentRsvData.length + ' 건');
						recentRsvData = result.recentRsvData;
					} else {
						$('#recentRsvCnt').text(0 + ' 건');
					}
					
					if(result.nonRsvData.length > 0) {
						$('#nonRsvCnt').text(result.nonRsvData.length + ' 명');
						nonRsvData = result.nonRsvData;
					} else {
						$('#nonRsvCnt').text(0 + ' 명');
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		getRecentJoinData: function(){
			let param;
			if($('#select-branch').val() != '' && $('#role').val() == 'SUPERADMIN') {
				param = {
					super_branch_code : $('#select-branch').val()
				}
			} else {
				param = {
					branch_code : ''
				}
			}
			
			$.doPost({
				url		: "/admin/getRecentJoinData",
				data	: param,
				success	: function(result){
					if(result.recentJoinData.length > 0){
						joinGrid.resetData(result.recentJoinData);
						recentJoinData = result.recentJoinData;
					}
				}
			})
		},
		saveMsgLog: function(param, flag){
			$.doPost({
				url		: "/admin/saveMsgLog",
				data	: param,
				success	: function(result){
					if(result.msg == 'success'){
						alert('저장되었습니다.');
						if(flag == 'join') {
							ajaxCom.getRecentJoinData();
						} else if(flag == 'rsv') {
							ajaxCom.getRecentRsvData();
						} else {
							ajaxCom.getNonRsvData();
						}
					} else {
						alert('오류가 발생하였습니다.');
					}
				}
			})
		},
		getRecentRsvData: function(){
			let param;
			if($('#select-branch').val() != '' && $('#role').val() == 'SUPERADMIN') {
				param = {
					super_branch_code : $('#select-branch').val()
				}
			} else {
				param = {
					branch_code : ''
				}
			}
			
			$.doPost({
				url		: "/admin/getRecentRsvData",
				data	: param,
				success	: function(result){
					if(result.recentRsvData.length > 0){
						recentRsvGrid.resetData(result.recentRsvData);
						recentRsvData = result.recentRsvData;
					}
				}
			})
		},
		getNonRsvData: function(){
			let param;
			if($('#select-branch').val() != '' && $('#role').val() == 'SUPERADMIN') {
				param = {
					super_branch_code : $('#select-branch').val()
				}
			} else {
				param = {
					branch_code : ''
				}
			}
			
			$.doPost({
				url		: "/admin/getNonRsvData",
				data	: param,
				success	: function(result){
					if(result.nonRsvData.length > 0){
						nonRecentRsvGrid.resetData(result.nonRsvData);
						nonRsvData = result.nonRsvData;
					}
				}
			})
		}
	};
	
	btnCom = {
		btn_getJoinGrid: function(){
			ajaxCom.getRecentJoinData();
		},
		btn_download_joinGrid: function(){
			tuiGrid.dataExport(joinGrid,'최근_가입한_회원.xlsx');
		},
		btn_getRsvGrid: function(){
			ajaxCom.getRecentRsvData();
		},
		btn_download_rsvGrid: function(){
			tuiGrid.dataExport(recentRsvGrid,'최근_예약한_회원.xlsx');
		},
		btn_getNonRsvGrid: function() {
			ajaxCom.getNonRsvData();
		},
		btn_download_NonRsvGrid: function(){
			tuiGrid.dataExport(nonRecentRsvGrid,'미완료_예약_회원.xlsx');
		}
	}
	
	fnCom = {
		createTr : function(data){
			$("#reservation_tbody").empty();
			
			data.forEach((reservation, index) => {
				let row = '<tr><td>'+Number(index+1)+'</td><td>'+reservation.rsv_date+'</td><td>'+reservation.user_id+'</td>'+reservation.user_id+'<td>'+reservation.reservation_time+'</td></tr>';
				
				$("#reservation_tbody").append(row);
			});
		},
		joinGridConfirm : function(props, rowKey){
			let rowData = joinGrid.getRow(rowKey);
			let param;
			
			if(rowData.msg_status == 'Y') {
				param = {
						msg_type : 'join',
						user_id : rowData.id,
						msg_status : 'N'
				}
			} else {
				param = {
						msg_type : 'join',
						user_id : rowData.id,
						msg_status : 'Y'
				}
			}
			
			if(confirm('상태를 변경하시겠습니까?')) {
				ajaxCom.saveMsgLog(param, 'join');
			}
		},
		recentRsvGridConfirm : function(props, rowKey){
			let rowData = recentRsvGrid.getRow(rowKey);
			let param;
			
			if(rowData.msg_status == 'Y') {
				param = {
						msg_type : 'rsv',
						user_id : rowData.user_id,
						rsv_date : rowData.rsv_date,
						msg_status : 'N'
				}
			} else {
				param = {
						msg_type : 'rsv',
						user_id : rowData.user_id,
						rsv_date : rowData.rsv_date,
						msg_status : 'Y'
				}
			}
			
			if(confirm('상태를 변경하시겠습니까?')) {
				ajaxCom.saveMsgLog(param, 'rsv');
			}
		},
		nonRsvGridConfirm: function(props, rowKey){
			let rowData = nonRecentRsvGrid.getRow(rowKey);
			let param;
			
			if(rowData.msg_status == 'Y') {
				param = {
						msg_type : 'non_rsv',
						user_id : rowData.id,
						msg_status : 'N'
				}
			} else {
				param = {
						msg_type : 'non_rsv',
						user_id : rowData.id,
						msg_status : 'Y'
				}
			}
			
			if(confirm('상태를 변경하시겠습니까?')) {
				ajaxCom.saveMsgLog(param, 'non_rsv');
			}
		}
	}

	ajaxCom.getCalendarEvent(cfn_yearMonthFormat(new Date()));
	ajaxCom.getDashboardInfo();

	$('#select-branch').on('change', function(){
		ajaxCom.getCalendarEvent(cfn_yearMonthFormat(new Date()));
		ajaxCom.getDashboardInfo();
	});
	
	let joinGrid;
	let recentRsvGrid;
	let nonRecentRsvGrid;
	
	$('#recentJoin').click(function() {
		tuiGrid.destroyGrid(joinGrid);
		$('#joinModal').modal('show');
	})
	
	$('#joinModal').on('shown.bs.modal', function(e){
		joinGrid = tuiGrid.createGrid (
				{
					gridId : 'joinGrid',
					height : 400,
					scrollY : true,
					readOnlyColorFlag : false,
					rowHeaders: ['rowNum'],
					rowHeight : 32,
					minRowHeight : 25,
					columns: [
						{header : 'id',			name : 'id',			align:'left',	 sortable: true},
						{header : '이름',			name : 'name',			align:'left',	 sortable: true},
						{header : '전화번호',		name : 'phone_number',	align:'left',	 sortable: true},
						{header : '가입일',		name : 'created_dt',	align:'center', sortable: true},
						{header : '예약 완료 여부',	name : 'reserve_cnt_status',	align:'center', sortable: true, formatter: 'listItemText', disabled:true, editor: { type: 'select', options: { listItems: [{text:'YES', value:'Y'},{text:'NO',value:'N'}]}}},
						{header : '상태',	name : 'msg_status',	 align:'center', sortable: true, formatter: 'listItemText', disabled:true, editor: { type: 'select', options: { listItems: [{text:'확인', value:'Y'},{text:'미확인',value:'N'}]}}},
						{header : '상태 확인',		name : 'change',	width : 80, align:'center', 
							renderer: {
								type : ButtonRenderer,
								options : {
									value : '확인',
									click: fnCom.joinGridConfirm
								}
							}
						},
					]
				},
				recentJoinData,
				{}
		);
	});
	
	$('#recentRsv').click(function() {
		tuiGrid.destroyGrid(recentRsvGrid);
		$('#recentRsvModal').modal('show');
	});
	
	$('#recentRsvModal').on('shown.bs.modal', function(e){
		recentRsvGrid = tuiGrid.createGrid (
				{
					gridId : 'recentRsvGrid',
					height : 400,
					scrollY : true,
					readOnlyColorFlag : false,
					rowHeaders: ['rowNum'],
					rowHeight : 32,
					minRowHeight : 25,
					columns: [
						{header : 'id',			name : 'user_id',			align:'left',	 sortable: true},
						{header : '예약일',		name : 'rsv_date',			align:'center',	 sortable: true},
						{header : '예약 시간',		name : 'select_time_nm',	align:'center',	 sortable: true},
						{header : '예약한 시간',	name : 'created_dt',		align:'center', sortable: true},
						{header : '상태',			name : 'msg_status',	 align:'center', sortable: true, formatter: 'listItemText', disabled:true, editor: { type: 'select', options: { listItems: [{text:'확인', value:'Y'},{text:'미확인',value:'N'}]}}},
						{header : '상태 확인',		name : 'change',			align:'center', width : 100, 
							renderer: {
								type : ButtonRenderer,
								options : {
									value : '확인',
									click: fnCom.recentRsvGridConfirm
								}
							}
						},
					]
				},
				recentRsvData,
				{}
		);
	});
	
	$('#nonRsv').click(function() {
		tuiGrid.destroyGrid(nonRecentRsvGrid);
		$('#nonRecentRsvModal').modal('show');
	})
	
	$('#nonRecentRsvModal').on('shown.bs.modal', function(e){
		nonRecentRsvGrid = tuiGrid.createGrid (
				{
					gridId : 'nonRecentRsvGrid',
					height : 400,
					scrollY : true,
					readOnlyColorFlag : false,
					rowHeaders: ['rowNum'],
					rowHeight : 32,
					minRowHeight : 25,
					columns: [
						{header : 'id',				name : 'id',			align:'left',	 sortable: true},
						{header : '전화번호',			name : 'phone_number',			align:'center',	 sortable: true},
// 						{header : '완료 예약 건수',		name : 'massage_cnt',	align:'center',	 sortable: true},
						{header : '잔여 예약 건수',		name : 'free_rsv_cnt',		align:'center', sortable: true},
						{header : '전체 마사지 횟수',	name : 'massage_total',		align:'center', sortable: true},
						{header : '임신 주수',			name : 'pregnancy_weeks',		align:'center', sortable: true},
						{header : '상태',			name : 'msg_status',	 align:'center', sortable: true, formatter: 'listItemText', disabled:true, editor: { type: 'select', options: { listItems: [{text:'확인', value:'Y'},{text:'미확인',value:'N'}]}}},
						{header : '상태 확인',			name : 'change',			align:'center', width : 100, 
							renderer: {
								type : ButtonRenderer,
								options : {
									value : '확인',
									click: fnCom.nonRsvGridConfirm
								}
							}
						},
					]
				},
				nonRsvData,
				{}
		);
	});
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
/* .modal-btn{ */
/* 	height: 35px!important */
/* } */
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
							<div class="d-flex mb-2">
								<div class="avatar">
									<span class="avatar-title rounded-circle border border-white bg-info"><i class="fas fa-calendar-alt"></i></span>
								</div>
								<div class="flex-1 ml-3 pt-3 mb-3">
									<h3 class="text-uppercase fw-bold mb-1">마지막 예약 생성 달<span class="text-warning pl-3" id="rsvLstMonth"></span></h3>
								</div>
							</div>
							<div class="d-flex mb-2" style="cursor:pointer;" id="recentJoin">
								<div class="avatar">
									<span class="avatar-title rounded-circle border border-white bg-success"><i class="fas fa-user-clock"></i></span>
								</div>
								<div class="flex-1 ml-3 pt-3 mb-3">
									<h3 class="text-uppercase fw-bold mb-1">최근에 가입한 회원 <span class="text-warning pl-3" id="recentJoinCnt"></span></h3>
								</div>
							</div>
							<div class="d-flex mb-2" style="cursor:pointer;" id="recentRsv">
								<div class="avatar">
									<span class="avatar-title rounded-circle border border-white bg-primary"><i class="far fa-calendar-plus"></i></span>
								</div>
								<div class="flex-1 ml-3 pt-3 mb-3">
									<h3 class="text-uppercase fw-bold mb-1">최근에 예약한 회원 <span class="text-warning pl-3" id="recentRsvCnt"></span></h3>
								</div>
							</div>
							<div class="d-flex mb-2" style="cursor:pointer;" id="nonRsv">
								<div class="avatar">
									<span class="avatar-title rounded-circle border border-white bg-danger"><i class="fas fa-bullhorn"></i></span>
								</div>
								<div class="flex-1 ml-3 pt-3 mb-3">
									<h3 class="text-uppercase fw-bold mb-1">예약 하지 않은 회원 <span class="text-warning pl-3" id="nonRsvCnt"></span></h3>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade " id="joinModal" tabindex="-1" aria-labelledby="alertModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable" style="max-width: 1000px!important;">
		<div class="modal-content">
			<div class="modal-header">
				<h2 class="modal-title" id="alertModalLabel">최근에 가입한 회원</h2>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div>
					<div class="col-sm-12">
						<div class="button-list float-right">
							<button type="button" id="btn_getJoinGrid" class="btn btn-icon btn-round btn-warning float-left ml-1 mb-2 btn-sm" data-toggle="tooltip" data-placement="bottom" title="조회"><i class="fas fa-sync"></i></button>
							<button type="button" id="btn_download_joinGrid" class="btn btn-icon btn-round btn-warning float-left ml-1 mb-2 btn-sm" data-toggle="tooltip" data-placement="bottom" title="다운로드"><i class="fas fa-file-excel"></i></button>
						</div>
					</div>
				</div>
				<div>
					<div id="joinGrid"></div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade " id="recentRsvModal" tabindex="-1" aria-labelledby="alertModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable" style="max-width: 1000px!important;">
		<div class="modal-content">
			<div class="modal-header">
				<h2 class="modal-title" id="alertModalLabel">최근에 예약한 회원</h2>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div>
					<div class="col-sm-12">
						<div class="button-list float-right">
							<button type="button" id="btn_getRsvGrid" class="btn btn-icon btn-round btn-warning float-left ml-1 mb-2 btn-sm" data-toggle="tooltip" data-placement="bottom" title="조회"><i class="fas fa-sync"></i></button>
							<button type="button" id="btn_download_rsvGrid" class="btn btn-icon btn-round btn-warning float-left ml-1 mb-2 btn-sm" data-toggle="tooltip" data-placement="bottom" title="다운로드"><i class="fas fa-file-excel"></i></button>
						</div>
					</div>
				</div>
				<div>
					<div id="recentRsvGrid"></div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade " id="nonRecentRsvModal" tabindex="-1" aria-labelledby="alertModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable" style="max-width: 1000px!important;">
		<div class="modal-content">
			<div class="modal-header">
				<h2 class="modal-title" id="alertModalLabel">예약하지 않은 회원</h2>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div>
					<div class="col-sm-12">
						<div class="button-list float-right">
							<button type="button" id="btn_getNonRsvGrid" class="btn btn-icon btn-round btn-warning float-left ml-1 mb-2 btn-sm" data-toggle="tooltip" data-placement="bottom" title="조회"><i class="fas fa-sync"></i></button>
							<button type="button" id="btn_download_NonRsvGrid" class="btn btn-icon btn-round btn-warning float-left ml-1 mb-2 btn-sm" data-toggle="tooltip" data-placement="bottom" title="다운로드"><i class="fas fa-file-excel"></i></button>
						</div>
					</div>
				</div>
				<div>
					<div id="nonRecentRsvGrid"></div>
				</div>
			</div>
		</div>
	</div>
</div>