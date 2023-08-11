<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
$(document).ready(function() {
	let calendarEl = document.getElementById('calendar');
	let calendarList = [];
	let modalPicker;
	let changeRsvGrid;
	let joinGrid;
	let recentRsvGrid;
	let nonRecentRsvGrid;
	let nonConfirmGrid;
	let nonConfirmData;
	let recentJoinData;
	let recentRsvData;
	let nonRsvData;
	
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
	
	$('.fc-prev-button').attr('title', '이전 달');
	$('.fc-next-button').attr('title', '다음 달');

	$('.fc-daygrid-day-events').css('font-weight', 'bolder');
	$('.fc-daygrid-day-events').css('margin-top','15px');
	$('.fc-daygrid-day-events').css('font-size','18px');
	$('.fc-scroller').css('overflow', 'hidden hidden')
	
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
							if(item.open_rsv_cnt != 0) {
								let liColor;
								item.reservation_cnt > 0 ? liColor = '#716aca' : liColor = 'gray';
								calendar.addEvent({
									title		: '예약: ' + item.reservation_cnt + '건 / ' + item.open_rsv_cnt +'건',
									start		: item.rsv_date,
									end			: item.rsv_date,
									color		: liColor
								});
							}
							
						})
						
						calendar.refetchEvents();
						$('.fc-daygrid-day-events').css('font-weight', 'bolder');
						$('.fc-daygrid-day-events').css('margin-top','15px');
						$('.fc-daygrid-day-events').css('font-size','18px');
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
					if(typeof result.theaderData != 'undefined' && result.rsvUserList.length >= 0){
						fnCom.createTable(result)
					}
					
					$('#click_dt').text(date);
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
					super_branch_code : $('#select-branch').val(),
					today			: fnCom.getToday()
				}
			} else {
				param = {
					branch_code : '',
					today			: fnCom.getToday()
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
					
					if(result.nonConfirmData.length > 0) {
						$('#nonConfirmCnt').text(result.nonConfirmData.length + ' 건');
						nonConfirmData = result.nonConfirmData;
					} else {
						$('#nonConfirmCnt').text(0 + ' 건');
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
		},
		updateRsvStatus: function(param, ori){
			$.doPost({
				url	 	: "/admin/updateRsvStatus",
				data 	: param,
				success	: function(result) {
					if(result.msg == 'success') {
						alert('변경되었습니다.');
						if(ori == 'modal'){
							$('#user_modal').modal('hide');
							ajaxCom.getSeletedDateReservationList(param.rsv_date);
						} else {
							ajaxCom.getNonConfirmData();
						}
					} else {
						alert('오류가 발생했습니다.');
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		removeReservation: function(param){
			$.doPost({
				url	 	: "/admin/removeReservationByAdmin",
				data 	: param,
				success	: function(result) {
					if(result.msg == 'success') {
						alert('취소되었습니다.');
						$('#user_modal').modal('hide');
						ajaxCom.getCalendarEvent(fnCom.getToday());
						ajaxCom.getSeletedDateReservationList(param.rsv_date);
					} else {
						alert('오류가 발생했습니다.');
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		getReservationList: function() {
			let date = $('#input_datepicker_modal').val();
			let month = date.substring(0,7);
			let superBranchCode;
			
			if($('#role').val() == 'SUPERADMIN'){
				superBranchCode = $('#select-branch').val();
			}
			
			$.doPost({
				url	 	: "/admin/getReservationList",
				data 	: {
					rsv_date			: date,
					rsv_month			: month,
					super_branch_code	: superBranchCode
				},
				success	: function(result) {
					let newData = [];
					result.reservationList.forEach( d => {
						if(d.cnt != 0) {
							newData.push(d);
						}
					})

					changeRsvGrid.resetData(newData);
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		updateReservation: function(param){
			$.doPost({
				url	 	: "/admin/updateReservation",
				data 	: param,
				success	: function(result) {
					if(result.msg == 'success') {
						alert('예약이 변경되었습니다.');
						$('#changeRsv_modal').modal('hide');
						ajaxCom.getCalendarEvent(fnCom.getToday());
						ajaxCom.getSeletedDateReservationList(param.rsv_date);
					} else {
						alert('오류가 발생했습니다.');
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		getNonConfirmData : function() {
			
			if($('#role').val() == 'SUPERADMIN'){
				let superBranchCode = $('#select-branch');
			}
			
			if($('#select-branch').val() != ''){
				superBranchCode = $('#select-branch').val();
			} else {
				superBranchCode = '';
			}
			
			$.doPost({
				url	 	: "/admin/getNonConfirmData",
				data 	: {
					today			: fnCom.getToday(),
					super_branch_code 	: superBranchCode,
				},
				success	: function(result) {
					if(result.nonConfirmData.length > 0){
						nonConfirmData = result.nonConfirmData;
						nonConfirmGrid.resetData(result.nonConfirmData);
						$('#nonConfirmCnt').text(nonConfirmData.length + ' 건');
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		}
	};
	
	btnCom = {
		btn_getJoinGrid: function(){
			ajaxCom.getRecentJoinData();
		},
		btn_download_joinGrid: function(){
			tuiGrid.dataExport(joinGrid,'7일내_가입한_회원.xlsx');
		},
		btn_getRsvGrid: function(){
			ajaxCom.getRecentRsvData();
		},
		btn_download_rsvGrid: function(){
			tuiGrid.dataExport(recentRsvGrid,'7일간_예약_내역.xlsx');
		},
		btn_getNonRsvGrid: function() {
			ajaxCom.getNonRsvData();
		},
		btn_download_NonRsvGrid: function(){
			tuiGrid.dataExport(nonRecentRsvGrid,'미완료_예약_회원.xlsx');
		},
		btn_getNonConfirmGrid: function(){
			ajaxCom.getNonConfirmData();
		},
		btn_download_NonConfirmGrid: function(){
			tuiGrid.dataExport(nonConfirmGrid,'마사지_미완료_회원.xlsx');
		},
		btn_change: function(){
			if($('#select_status').val() == 'Y'){
				alert('마사지 완료를 미완료로 변경 후 예약을 변경해주세요.');
				return false;
			} 
			
			$('#user_modal').modal('hide');
			
			modalPicker = new tui.DatePicker('#div_datepicker_modal', {
				date: new Date($('#rsv_date').val()),
				language: 'ko',
				input: {
					element: '#input_datepicker_modal',
					format: 'yyyy-MM-dd'
				}
			});
			
			$('#changeRsv_modal').modal('show');
			tuiGrid.destroyGrid(changeRsvGrid);
			
			modalPicker.on('change', function(){
				let currentDate = fnCom.getToday();
				let selectedDate = $('#input_datepicker_modal').val();
				
				if(selectedDate < currentDate){
					alert('오늘보다 이전 날짜로 예약일을 변경할 수 없습니다.');
					return false;
				} else {
					ajaxCom.getReservationList();
				}
			});
			
		},
		btn_cancel: function(){
			if (confirm("예약을 취소하시겠습니까?")) {
				let param = {
					user_id : $('#input_id').val(),
					select_time : $('#rsv_time').val(),
					rsv_date : $('#rsv_date').val(),
					flag		: 'd'
				}
				ajaxCom.removeReservation(param);
			}
		},
		
	}
	
	fnCom = {
		getToday: function() {
			const now = new Date();
			const year = now.getFullYear();
			const month = String(now.getMonth() + 1).padStart(2, '0');
			const day = String(now.getDate()).padStart(2, '0');
			return year + '-' + month + '-' + day;
		},
		createTable : function(result){
			$('#rsv_theader > tr> .rsvth').each(function() {
				$(this).remove();
			});
			
			$('#rsv_tbody').empty();
			
			let stdData = result.theaderData;
			let rsvUserList = result.rsvUserList;
			let keys = Object.keys(stdData).filter(function(key) {
				return key.endsWith('_times');
			});
			keys.sort();

			for(let i = 1; i <= stdData.max_rsv; i++) {
				$('#rsv_theader tr').append('<th scope="col" class="rsvth">예약자 ' + (i) + '</th>');
			}
			
			for (let i = 0; i < keys.length; i++) {
				let rowHtml = '<tr>';
				rowHtml += '<td style="text-align: center;">' + stdData[keys[i]].substring(0,5) + '</td>';
			
				let tdCnt = stdData.max_rsv;
				let reservedUsers = rsvUserList.filter(user => user.select_time == keys[i].split('_')[0]);
				let availableCount = stdData[keys[i] + '_cnt'];
				let rsvDate = stdData.rsv_date;
				let currentDate = fnCom.getToday();
			
				for (let j = 0; j < stdData.max_rsv; j++) {
					if (tdCnt > 0) {
						if (j < reservedUsers.length) {
							let userName = reservedUsers[j].name != '' ? reservedUsers[j].name : '예약 가능';
							if(userName != '예약 가능'){
								rowHtml += '<td class="userClick" style="text-align: center; text-decoration: underline; cursor: pointer;" user_id="'+reservedUsers[j].user_id+'" rsv_times="'+reservedUsers[j].select_time+'" phone="'+reservedUsers[j].phone_number+'" rsv_status="'+reservedUsers[j].rsv_status+'" rsv_date="'+stdData.rsv_date+'">' + userName + '</td>';
							} else {
								if(rsvDate < currentDate){
									rowHtml += '<td style="text-align: center; color:gray;">예약 안됨</td>';
								} else {
									rowHtml += '<td style="text-align: center; color:blue;">' + userName + '</td>';
								}
							}
							
						} else {
							if (j < availableCount) {
								if(rsvDate < currentDate){
									rowHtml += '<td style="text-align: center; color:gray;">예약 안됨</td>';
								} else {
									rowHtml += '<td style="text-align:center; color:blue;">예약 가능</td>';
								}
							} else {
								rowHtml += '<td style="text-align: center; color:red;">예약 불가</td>';
							}
						}
						tdCnt--;
					}
				}
				rowHtml += '</tr>';
				$('#rsv_tbody').append(rowHtml);
			}
			
			$('.table-responsive').css('overflow-x', 'auto');
			$('.table-responsive').css('max-width', '470px;'); 
			$('.rsvth').css('min-width', '100px');
			
			$('.userClick').on('click', function(){
				$('#input_id').val($(this).attr('user_id'));
				$('#input_nm').val($(this).text());
				$('#input_phone').val($(this).attr('phone'));
				$('#select_status').val($(this).attr('rsv_status'));
				$('#rsv_time').val($(this).attr('rsv_times'));
				$('#rsv_date').val($(this).attr('rsv_date'));
				
				$('#user_modal').modal('show');
			})
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
		},
		changeRsvModal: function(props, rowKey){
			let data = props.grid.getRow(rowKey);
			let rsvDate = $('#input_datepicker_modal').val();
			let rsvMonth = rsvDate.substring(0,7);
			let rsvTime = data.rsv_time.substring(0, 5);
			let superBranchCode
			
			if($('#role').val() == 'SUPERADMIN'){
				superBranchCode = $('#select-branch');
			}
			
			if (confirm("기존 예약이 취소됩니다. 예약을 변경하시겠습니까?")) {
				let param = {
					user_id			: $('#input_id').val(),
					pre_rsv_date	: $('#rsv_date').val(),
					pre_select_time	: $('#rsv_time').val(),
					rsv_month		: rsvMonth,
					rsv_date		: rsvDate,
					select_time		: data.col,
					super_branch_code	: superBranchCode
				}
				
				ajaxCom.updateReservation(param);
			}
		},
	}

	ajaxCom.getCalendarEvent(cfn_yearMonthFormat(new Date()));
	ajaxCom.getDashboardInfo();

	$('#select-branch').on('change', function(){
		ajaxCom.getCalendarEvent(cfn_yearMonthFormat(new Date()));
		ajaxCom.getDashboardInfo();
	});
	
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
						{header : '아이디',			name : 'id',			align:'left',	 sortable: true},
						{header : '이름',			name : 'name',			align:'left',	 sortable: true},
						{header : '전화번호',		name : 'phone_number',	align:'left',	 sortable: true},
						{header : '가입일',		name : 'created_dt',	align:'center', sortable: true},
						{header : '예약 완료 여부',	name : 'reserve_cnt_status',	align:'center', sortable: true, formatter: 'listItemText', disabled:true, editor: { type: 'select', options: { listItems: [{text:'YES', value:'Y'},{text:'NO',value:'N'}]}}},
						{header : '알림 상태',	name : 'msg_status',	 align:'center', sortable: true, formatter: 'listItemText', disabled:true, editor: { type: 'select', options: { listItems: [{text:'전송', value:'Y'},{text:'미전송',value:'N'}]}}},
						{header : '알림 상태 변경',		name : 'change',	align:'center', 
							renderer: {
								type : ButtonRenderer,
								options : {
									value : '변경',
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
						{header : '아이디',			name : 'user_id',			align:'left',	 sortable: true},
						{header : '예약일',		name : 'rsv_date',			align:'center',	 sortable: true},
						{header : '예약 시간',		name : 'select_time_nm',	align:'center',	 sortable: true},
						{header : '예약한 날짜',	name : 'created_dt',		align:'center', sortable: true},
						{header : '알림 상태',			name : 'msg_status',	 align:'center', sortable: true, formatter: 'listItemText', disabled:true, editor: { type: 'select', options: { listItems: [{text:'전송', value:'Y'},{text:'미전송',value:'N'}]}}},
						{header : '알림 상태 변경',		name : 'change',			align:'center',  
							renderer: {
								type : ButtonRenderer,
								options : {
									value : '변경',
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
						{header : '아이디',			name : 'id',				align:'left',	 sortable: true},
						{header : '전화번호',			name : 'phone_number',		align:'center',	 sortable: true},
						{header : '잔여 마사지 횟수',	name : 'free_rsv_cnt',		align:'center', sortable: true},
						{header : '전체 마사지 횟수',	name : 'massage_total',		align:'center', sortable: true},
						{header : '출산 예정일',		name : 'due_date',			align:'center', sortable: true},
						{header : '임신 주수',			name : 'pregnancy_weeks',	align:'center', sortable: true},
						{header : '알림 상태',			name : 'msg_status',		align:'center', sortable: true, formatter: 'listItemText', disabled:true, editor: { type: 'select', options: { listItems: [{text:'전송', value:'Y'},{text:'미전송',value:'N'}]}}},
						{header : '알림 상태 변경',		name : 'change',			align:'center', 
							renderer: {
								type : ButtonRenderer,
								options : {
									value : '변경',
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
	
	$('#nonConfirm').click(function(){
		tuiGrid.destroyGrid(nonConfirmGrid);
		$('#nonConfirmModal').modal('show');
	})
	
	$('#nonConfirmModal').on('shown.bs.modal', function(e){
		nonConfirmGrid = tuiGrid.createGrid (
				{
					gridId : 'nonConfirmGrid',
					height : 400,
					scrollY : true,
					readOnlyColorFlag : false,
					rowHeaders: ['rowNum'],
					rowHeight : 32,
					minRowHeight : 25,
					columns: [
						
						{header : '예약일',			name : 'rsv_date',			align:'center',	 sortable: true},
						{header : '예약시간',			name : 'reservation_time',	align:'center', sortable: true},
						{header : 'id',				name : 'user_id',			align:'left',	 sortable: true},
						{header : '마사지 확인',			name : 'rsv_status',	align:'center', sortable: true, style:'cursor:pointer;text-decoration:underline;',
							formatter: 'listItemText', disabled:false, 
							editor: { type: 'select', options: { listItems: [{text:'완료', value:'Y'},{text:'미완료',value:'N'}]}}},
						{header : '예약시간',			name : 'select_time',		hidden:true}
					]
				},
				nonConfirmData,
				{
					afteredit: function(rowKey,colName,preval,newval,grid){
						if(colName == 'rsv_status'){
							let data = nonConfirmGrid.getRow(rowKey);
							
							let param = {
								user_id : data.user_id,
								select_time : data.select_time,
								rsv_date : data.rsv_date,
								rsv_status : newval
							}
							
							if(preval == 'N') {
								if(confirm('마사지 완료로 변경하시겠습니까?')){
									ajaxCom.updateRsvStatus(param, 'grid');
								}
							} else {
								if(confirm('마사지 미완료로 변경하시겠습니까?')){
									ajaxCom.updateRsvStatus(param, 'grid');
								}
							}
						}
						
					}
				}
		);
	});
	
	$('#goToRsvMaster').click(function(){
		window.location.href = '/admin/reservation_master';
	})
	
	$('#select_status').on('change', function(){
		let param = {
			user_id : $('#input_id').val(),
			select_time : $('#rsv_time').val(),
			rsv_date : $('#rsv_date').val(),
			rsv_status : $('#select_status').val()
		}
		
		if($('#select_status').val() == 'Y') {
			if(confirm('마사지 완료로 변경하시겠습니까?')){
				ajaxCom.updateRsvStatus(param, 'modal');
			}
		} else {
			if(confirm('마사지 미완료로 변경하시겠습니까?')){
				ajaxCom.updateRsvStatus(param, 'modal');
			}
		}
	});
	
	$('#changeRsv_modal').on('shown.bs.modal', function(e){
		changeRsvGrid = tuiGrid.createGrid (
				{
					gridId : 'grid_changeRsv_modal',
					height : 250,
					rowHeight : 32,
					minRowHeight : 25,
					scrollY : true,
					readOnlyColorFlag : false,
					columns: [
						{header : '예약 가능 시간',		name : 'rsv_time',	width: 250,	align:'center', sortable: true},
						{header : '예약한 시간',		name : 'remark',	hidden:true},
						{header : '예약 변경',			name : 'change',	width: 200,	align:'center', 
							renderer: {
								type : ButtonRenderer,
								options : {
									value : '변경',
									click: fnCom.changeRsvModal
								}
							}
						}
					]
				},
				[],
				{}
			);
			ajaxCom.getReservationList();
	});
})
</script>

<style>
a:link {
	color : black;
}
.table td{
	font-size: 15px!important;
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
.fc-daygrid-day-events'{
	font-weight : bolder;
	margin-top : 15px;
	font-size : 18px;
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
					<div class="card mb-2">
						<div class="card-header pb-0">
							<h2 class="fw-bold">알림</h2>
						</div>
						<div class="card-body">
							<div class="d-flex" style="cursor:pointer;" id="goToRsvMaster">
								<div class="avatar">
									<span class="avatar-title rounded-circle border border-white bg-info"><i class="fas fa-calendar-alt"></i></span>
								</div>
								<div class="flex-1 ml-3 pt-3 mb-3">
									<h4 class="fw-bold mb-1">마지막 예약 생성 월<span class="text-warning pl-3" id="rsvLstMonth"></span></h4>
								</div>
							</div>
							<div class="d-flex" style="cursor:pointer;" id="nonRsv">
								<div class="avatar">
									<span class="avatar-title rounded-circle border border-white bg-danger"><i class="fas fa-bullhorn"></i></span>
								</div>
								<div class="flex-1 ml-3 pt-3 mb-3">
									<h4 class="fw-bold mb-1">예약이 완료되지 않은 회원 <span class="text-warning pl-3" id="nonRsvCnt"></span></h4>
								</div>
							</div>
							<div class="d-flex" style="cursor:pointer;" id="recentJoin">
								<div class="avatar">
									<span class="avatar-title rounded-circle border border-white bg-success"><i class="fas fa-user-clock"></i></span>
								</div>
								<div class="flex-1 ml-3 pt-3 mb-3">
									<h4 class="fw-bold mb-1">7일 내 가입한 회원<span class="text-warning pl-3" id="recentJoinCnt"></span></h4>
								</div>
							</div>
							<div class="d-flex" style="cursor:pointer;" id="recentRsv">
								<div class="avatar">
									<span class="avatar-title rounded-circle border border-white bg-primary"><i class="far fa-calendar-plus"></i></span>
								</div>
								<div class="flex-1 ml-3 pt-3 mb-3">
									<h4 class="fw-bold mb-1">7일 간 예약 내역<span class="text-warning pl-3" id="recentRsvCnt"></span></h4>
								</div>
							</div>
							<div class="d-flex" style="cursor:pointer;" id="nonConfirm">
								<div class="avatar">
									<span class="avatar-title rounded-circle border border-white bg-warning"><i class="fas fa-check"></i></span>
								</div>
								<div class="flex-1 ml-3 pt-3 mb-3">
									<h4 class="fw-bold mb-1">마사지 완료가 되지 않은 예약 내역<span class="text-warning pl-3" id="nonConfirmCnt"></span></h4>
								</div>
							</div>
						</div>
					</div>
					
					<div class="card" style="min-height:300px;">
						<div class="card-header pb-0">
							<div class="row">
								<h2 class="fw-bold"><span id="click_dt" class="ml-3"></span>&nbsp;예약 확인</h2>
							</div>
						</div>
						<div class="card-body pb-0" >
							<div class="table-responsive" style="overflow-y: auto;max-height: 350px;">
								<table class="table table-head-bg-secondary">
									<thead id="rsv_theader" style="text-align:center;">
										<tr>
											<th scope="col" id="rsv_times">시간</th>
										</tr>
									</thead>
									<tbody id="rsv_tbody">
									</tbody>
								</table>
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
				<h2 class="modal-title" id="alertModalLabel">7일 내 가입한 회원</h2>
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
				<h2 class="modal-title" id="alertModalLabel">7일 간 예약 내역</h2>
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
				<h2 class="modal-title" id="alertModalLabel">예약이 완료 되지 않은 회원</h2>
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

<div class="modal fade " id="nonConfirmModal" tabindex="-1" aria-labelledby="alertModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable" style="max-width: 1000px!important;">
		<div class="modal-content">
			<div class="modal-header">
				<h2 class="modal-title" id="alertModalLabel">마사지 완료가 되지 않은 예약 내역</h2>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div>
					<div class="col-sm-12">
						<div class="button-list float-right">
							<button type="button" id="btn_getNonConfirmGrid" class="btn btn-icon btn-round btn-warning float-left ml-1 mb-2 btn-sm" data-toggle="tooltip" data-placement="bottom" title="조회"><i class="fas fa-sync"></i></button>
							<button type="button" id="btn_download_NonConfirmGrid" class="btn btn-icon btn-round btn-warning float-left ml-1 mb-2 btn-sm" data-toggle="tooltip" data-placement="bottom" title="다운로드"><i class="fas fa-file-excel"></i></button>
						</div>
					</div>
				</div>
				<div>
					<div id="nonConfirmGrid"></div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="user_modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">예약자 정보</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="col-12">
					<div class="form-group row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2">예약자 ID</label>
						</div>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="input_id" disabled>
						</div>
					</div>
					<div class="form-group row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2">예약자 이름</label>
						</div>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="input_nm" disabled>
						</div>
					</div>
					<div class="form-group row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2">전화번호</label>
						</div>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="input_phone" disabled>
						</div>
					</div>
					<div class="form-group row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2">마사지 완료</label>
						</div>
						<div class="col-sm-9">
							<select class="form-control" id="select_status">
								<option value="N">미완료</option>
								<option value="Y">완료</option>
							</select>
						</div>
					</div>
					<input type="text" id="rsv_time" style="display:none;">
					<input type="text" id="rsv_date" style="display:none;">
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" id="btn_cancel">예약 취소</button>
				<button type="button" class="btn btn-secondary" id="btn_change">예약 변경</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="changeRsv_modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">예약 변경</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="form-group pb-0" style="margin: 6px;">
				<label class="control-label mt-2 mr-3">예약할 날짜 선택</label>
				<div class="tui-datepicker-input tui-datetime-input tui-has-focus"
					style="margin-bottom: 6px;">
					<input type="text" id="input_datepicker_modal" aria-label="date">
					<span class="tui-ico-date"></span>
				</div>
				<div class="datepicker-cell" id="div_datepicker_modal"></div>
			</div>
			<div class="modal-body">
				<div>
					<div id="grid_changeRsv_modal"></div>
				</div>
			</div>
		</div>
	</div>
</div>