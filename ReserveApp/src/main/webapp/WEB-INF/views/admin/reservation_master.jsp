<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
table tbody tr th {
	min-width: 100px;
}
#reservation_tbody input {
	width: 100%;
	border: 0px solid;
	background: transparent;
	color: white;
	text-align: center;
}
#reservation_tbody td[input_val] {
	background-color: #EC7357;
}
#reservation_tbody td[input_val="0"] {
	background-color: #bfc1c7;
}
#reservation_tbody td[input_val="1"] {
	background-color: #f5c542;
}
#reservation_tbody td[input_val="2"] {
	background-color: #a85ae6;
}
#reservation_tbody td[input_val="3"] {
	background-color: #8FBC94;
}
#reservation_tbody td[input_val="4"] {
	background-color: #6AAFE6;
}
#reservation_tbody td[input_val="5"] {
	background-color: #EE7785;
}
#reservation_tbody td[input_val="6"] {
	background-color: #d9534f;
}
#reservation_tbody td[input_val="7"] {
	background-color: #17a2b8;
}

</style>

<script>
let checkUnload = true;

$(document).ready(function() {
	const today = new Date();
	const stdMonthPicker = new tui.DatePicker('#datepicker_create', {
		date: today,
		language: 'ko',
		type: 'month',
		input: {
			element: '#datepicker_input_create',
			format: 'yyyy-MM'
		}
	});
	
	let firstDayForRangePicker = new Date(stdMonthPicker.getDate().getFullYear(), today.getMonth(), 1);
	let lastDayForRangePicker = new Date(stdMonthPicker.getDate().getFullYear(), today.getMonth() + 1, 0);

	let searchPicker = tui.DatePicker.createRangePicker({
		startpicker: {
			date: firstDayForRangePicker,
			input: '#input_startDate',
			container: '#startDate-container'
		},
		endpicker: {
			date: lastDayForRangePicker,
			input: '#input_endDate',
			container: '#endDate-container'
		},
		language: 'ko',
		format: 'YYYY-MM-dd',
		selectableRanges: [
			[firstDayForRangePicker, lastDayForRangePicker]
		]
	});
	
	$('#td_day').css('display', 'none');
	$('#td_time').css('display', 'none');
	$('.td_range').css('display', 'none');
	$('.td_filter').css('display', 'none');
	
	ajaxCom = {
		getReservationMasterData: function(){
			let param;
			
			if($('#select-branch').val() != '' && $('#role').val() == 'SUPERADMIN'){
				param = {
					rsv_month : $('#datepicker_input_create').val(),
					super_branch_code : $('#select-branch').val()
				}
			} else {
				param = {
					rsv_month : $('#datepicker_input_create').val()
				}
			}
			
			$.doPost({
				url		: "/admin/getReservationMasterData",
				data	: param,
				success	: function(result){
					if(result.masterList == 0) {
						$('#reservation_tbody').find('tr').remove();
						$('#btn_initCreate').css('display', '');
						$('#btn_tableReset').css('display', 'none');
						$('#btn_clearFilter').css('display', 'none');
						$('.td_filter').css('display', 'none');
						$('#td_day').css('display', 'none');
						$('#td_time').css('display', 'none');
						$('.td_range').css('display', 'none');
						$('.td_filter').css('display', 'none');
					} else {
						$('#btn_initCreate').css('display', 'none');
						$('#btn_tableReset').css('display', 'none');
						$('#btn_clearFilter').css('display', '');
						$('.td_filter').css('display', '');
						$('#input_basicWorker').val(result.branchInfo.worker_num);
						fnCom.createTable(result);
					}
					
					if($('#role').val() == 'SUPERADMIN'){
						$('#btn_initCreate').css('display', 'none');
						$('#btn_clearFilter').css('display', 'none');
						$('#td_day').css('display', 'none');
						$('#td_time').css('display', 'none');
						$('.td_range').css('display', 'none');
						$('.td_filter').css('display', 'none');
						
						$('#reservation_tbody tr').each(function() {
							$(this).find('td').each(function() {
								$(this).find('input').prop('disabled', true);
							});
						});
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		saveReservationMasterData: function(param){
			let deleteInfo = {
				stdMonth : $('#datepicker_input_create').val()
			}
			$.doPost({
				url		: "/admin/saveReservationMasterData",
				data	: { data : param,
							delInfo : deleteInfo
						},
				success	: function(result){
					if(result.msg == 'success') {
						checkUnload = false;
						$('#btn_tableReset').css('display','none');
						$('#select_filter').val('none');
						$('#td_day').css('display', 'none');
						$('#td_time').css('display', 'none');
						$('.td_range').css('display', 'none');
						cfn_tableResize('table_div', 300);
						alert('저장 되었습니다.');
					} else {
						alert('오류가 발생하였습니다.');
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
	}; //ajaxCom END
	
	//이벤트 객체 : id값을 주면 클릭 이벤트 발생
	btnCom = {
		btn_get: function(){
			ajaxCom.getReservationMasterData();
		},
		btn_initCreate: function() {
			$('#reservation_tbody').find('tr').remove();
			$('#btn_tableReset').css('display','');
			
			if($('#input_basicWorker').val() == null || $('#input_basicWorker').val() == ''){
				alert('기본 근무자 수를 입력해주세요.');
				return false;
			}
			
			for(let i = 0; i <= 10; i++) {
				$('#span_'+i+'t').text($('#input_'+i+'t').val());
			}
			
			let stdMonth = stdMonthPicker.getDate();
			let startOfMonth = new Date(stdMonth.getFullYear(), stdMonth.getMonth(), 1);
			let endOfMonth = new Date(stdMonth.getFullYear(), stdMonth.getMonth() + 1, 0);
			let datesArray = [];
			let currentDate = new Date(startOfMonth);

			while (currentDate <= endOfMonth) {
				datesArray.push(new Date(currentDate));
				currentDate.setDate(currentDate.getDate() + 1);
			}

			let trData;
			
			datesArray.forEach(day => {
				trData += '<tr value="'+cfn_tuiDateFormat(day)+'">'
				trData += '<td>' + cfn_tuiDateFormat(day) +'</td>'
				trData += '<td>'+$('#input_basicWorker').val()+'</td>'
				for(let i = 1; i <= 10; i++){
					trData += '<td value="'+i+'t" input_val="'+$('#input_basicWorker').val()+'"><input type="number" min="0" value="'+$('#input_basicWorker').val()+'"></td>'
				}
				trData += '</tr>'
			})
			
			$('#reservation_tbody').append(trData);
			$('#btn_initCreate').css('display', 'none');
			$('.td_filter').css('display','');
			$('#btn_clearFilter').css('display', '');
		},
		btn_modifyByday: function(){
			let editDay = [];
			$("input[name='selectDay']:checked").each(function() {
				editDay.push(Number($(this).val()));
			});

			if(editDay.length <= 0){
				alert('적용할 요일을 선택해주세요.');
				return false;
			}
			
			if($("#input_workerForDay").val() < 0 || $("#input_workerForDay").val() == '') {
				alert('근무자 수를 입력해주세요.');
				return false;
			}
			
			
			editDay.forEach(function(day) {
				let rows = $("#reservation_tbody tr");

				rows.each(function() {
					let row = $(this);
					let dateValue = row.attr("value");
					let date = new Date(dateValue);

					if (date.getDay() === day) {
						let inputColumns = row.find("td:nth-child(n+3):nth-child(-n+12)");
						inputColumns.each(function() {
							let column = $(this);
							let input = column.find("input");
							
							let inputValue = $("#input_workerForDay").val();
							let inputMinValue = input.attr('min');
							
							if (inputValue >= inputMinValue) {
								input.val(inputValue);
								column.attr('input_val', inputValue);
							}
						});
					}
				});
			});
		},
		btn_modifyByTime: function(){
			let editTime = [];
			$("input[name='selectTime']:checked").each(function() {
				editTime.push($(this).val());
			});

			if (editTime.length <= 0) {
				alert('적용할 요일을 선택해주세요.');
				return false;
			}

			let inputWorkerForTimeVal = $('#input_workerForTime').val();

			if (inputWorkerForTimeVal < 0 || inputWorkerForTimeVal == '') {
				alert('근무자 수를 입력해주세요.');
				return false;
			}

			let tdList = $('#reservation_tbody td');
			tdList.each(function() {
				let td = $(this);
				let tdValue = td.attr('value');

				if (editTime.includes(tdValue)) {
					let input = td.find('input');
					let inputMinValue = input.attr('min');
					
					if (inputWorkerForTimeVal >= inputMinValue) {
						input.val(inputWorkerForTimeVal);
						td.attr('input_val', inputWorkerForTimeVal);
					}
				}
			});
		},
		btn_modifyByRange : function(){
			let startDt = $('#input_startDate').val();
			let endDt = $('#input_endDate').val();
			let inputWorker = $('#input_workerForRange').val();
			let editDay = [];
			let editTime = [];
			
			$("input[name='selectRangeDay']:checked").each(function() {
				editDay.push(Number($(this).val()));
			});

			$("input[name='selectRangeTime']:checked").each(function() {
				editTime.push($(this).val());
			});
			
			
			if(editDay.length == 0 && editTime.length == 0) {
				alert('지정 조건을 선택해주세요.');
				return false;
			}
			
			if(inputWorker == '') {
				alert('변경할 근무자 수를 입력해주세요.');
				return false;
			}
			
			let rows = $("#reservation_tbody tr").filter(function() {
				let dateValue = $(this).attr("value");
				let date = new Date(dateValue);
				let startDate = new Date(startDt);
				let endDate = new Date(endDt);

				return date >= startDate && date <= endDate;
			});

			rows.each(function() {
				let row = $(this);
				let dayOfWeek = new Date(row.attr("value")).getDay();
				let inputColumns = row.find("td:nth-child(n+3):nth-child(-n+12)");

				let isDayMatched = editDay.length == 0 || editDay.includes(dayOfWeek);

				inputColumns.each(function() {
					let column = $(this);
					let timeValue = column.attr('value');
					let isTimeMatched = editTime.length === 0 || editTime.includes(timeValue);

					if (isDayMatched && isTimeMatched) {
						let input = column.find('input');
						let inputMinValue = input.attr('min');

						if (inputWorker >= inputMinValue) {
							input.val(inputWorker);
							column.attr('input_val', inputWorker);
						}
					}
				});
			});
		},
		btn_save: function(){
			let selectMonth = $('#datepicker_input_create').val();
			let trList = $('#reservation_tbody tr');
			let workerNum = $('#input_basicWorker').val();
			
			if(trList.length <= 0){
				alert('예약 테이블을 먼저 생성해주세요.');
				return false;
			}
				
			let data = [];
			trList.each(function() {
				let tr = $(this);
				let rsvDate = tr.attr('value');
				let obj = {
					rsv_month: selectMonth,
					rsv_date: rsvDate,
					rsv_worker: workerNum
				};

				for (var i = 1; i <= 10; i++) {
					var value = tr.find('td[value="' + i + 't"] input').val();
					obj[i + 't'] = Number(value);
				}

				data.push(obj);
			});
			
			ajaxCom.saveReservationMasterData(data);
		},
		btn_clearFilter: function(){
			$("input[name='selectDay']").prop('checked', false);
			$("input[name='selectTime']").prop('checked', false);
			$("input[name='selectRangeDay']").prop('checked', false);
			$("input[name='selectRangeTime']").prop('checked', false);

			$("#input_workerForDay").val('');
			$("#input_workerForTime").val('');
			$("#input_workerForRange").val('');
			
			fnCom.setRangePicker();
		},
		btn_tableReset: function(){
			if (confirm('입력된 내용들이 사라집니다.')) {
				$('#reservation_tbody').find('tr').remove();
				$('#btn_initCreate').css('display','');
				$('#btn_tableReset').css('display','none');
			}
		}
	}; //btnCom END

	//기타 함수 객체
	fnCom = {
		createTable: function(list){
			$('#reservation_tbody').find('tr').remove();
			
			for(let i = 0; i <=10; i++){
				$('#span_'+i+'t').text(list.branchInfo[i+'t_name']);
			}
			
			let trData;
			list.masterList.forEach(function(data){
				trData += '<tr value="'+data.rsv_date+'">'
				trData += '<td>' + data.rsv_date +'</td>'
				trData += '<td>'+data.rsv_worker+'</td>'
				for(let i = 1; i <= 10; i++){
					trData += '<td value="'+i+'t" input_val="'+data[i+'t']+'"><input type="number" min="'+data[i+'t_cnt']+'" value="'+data[i+'t']+'"></td>'
				}
				trData += '</tr>'
			})
			$('#reservation_tbody').append(trData);
		},
		setRangePicker(){
			firstDayForRangePicker = new Date(stdMonthPicker.getDate().getFullYear(), stdMonthPicker.getDate().getMonth(), 1);
			lastDayForRangePicker = new Date(stdMonthPicker.getDate().getFullYear(), stdMonthPicker.getDate().getMonth() + 1, 0);
			
			searchPicker = tui.DatePicker.createRangePicker({
				startpicker: {
					date: firstDayForRangePicker,
					input: '#input_startDate',
					container: '#startDate-container'
				},
				endpicker: {
					date: lastDayForRangePicker,
					input: '#input_endDate',
					container: '#endDate-container'
				},
				language: 'ko',
				format: 'YYYY-MM-dd',
				selectableRanges: [
					[firstDayForRangePicker, lastDayForRangePicker]
				]
			});
		}
	}; //fnCom END
	
	$('#input_basicWorker').blur(function(){
		if($('#input_basicWorker').val() < 0){
			$('#input_basicWorker').val(0);
		}
	});
	
	stdMonthPicker.on('change', function(){
		ajaxCom.getReservationMasterData();
		fnCom.setRangePicker();
	})
	
	$('#select_filter').on('change', function(){
		if($('#select_filter').val()=='day'){
			$('#td_day').css('display', '');
			$('#td_time').css('display', 'none');
			$('.td_range').css('display', 'none');
			cfn_tableResize('table_div', 350);
		} else if($('#select_filter').val()=='time') {
			$('#td_day').css('display', 'none');
			$('#td_time').css('display', '');
			$('.td_range').css('display', 'none');
			cfn_tableResize('table_div', 350);
		} else if($('#select_filter').val()=='range') {
			$('#td_day').css('display', 'none');
			$('#td_time').css('display', 'none');
			$('.td_range').css('display', '');
			cfn_tableResize('table_div', 430);
		} else {
			$('#td_day').css('display', 'none');
			$('#td_time').css('display', 'none');
			$('.td_range').css('display', 'none');
			cfn_tableResize('table_div', 300);
		}
	})
	
	ajaxCom.getReservationMasterData();
	cfn_tableResize('table_div', 300);
}); //END $(document).ready


$(window).on("beforeunload", function(){
	if(checkUnload) {
		return '변경사항이 저장되지 않을 수 있습니다.';
	}
});
	
$(document).on('input', '#reservation_tbody input[type="number"]', function() {
	let value = $(this).val();
	let parentTd = $(this).parent();

	if (value == null || value === '' || value == 0) {
		parentTd.css('background-color', '#bfc1c7');
	} else if (value == 1) {
		parentTd.css('background-color', '#f5c542');
	} else if (value == 2) {
		parentTd.css('background-color', '#a85ae6');
	} else if (value == 3) {
		parentTd.css('background-color', '#8FBC94');
	} else if (value == 4) {
		parentTd.css('background-color', '#6AAFE6');
	} else if (value == 5) {
		parentTd.css('background-color', '#EE7785');
	} else if (value == 6) {
		parentTd.css('background-color', '#d9534f');
	} else if(value == 7) {
		parentTd.css('background-color', '#17a2b8');
	} else {
		parentTd.css('background-color', '#EC7357');
	}
});



</script>

<div class="main-panel">
	<div class="content">
		<div class="page-inner">
			<div class="row">
				<div class="col-md-12">
					<div class="card">
						<div class="card-body d-flex flex-column">
							<div class="row">
								<div class="col-md-12">
									<div class="row">
										<div class="col-sm-6">
											<span class="row-title">예약 마스터 관리</span>
										</div>
										<div class="col-sm-6">
											<div class="button-list float-right">
												<button type="button" id="btn_get" class="header-btn btn btn-secondary float-left ml-2 mb-2">조회</button>
												<button type="button" id="btn_save" class="header-btn btn btn-secondary float-left ml-2 mb-2">저장</button>
											</div>
										</div>
									</div>

									<table class="table-sm mt-0 mb-2" style="border-top: 1px lightgray solid; border-bottom: 1px lightgray solid; width:100%">
										<tbody>
											<tr>
												<th colspan="1" style="width: 150px;">기준 월</th>
												<td colspan="1">
													<div class="tui-datepicker-input tui-datetime-input tui-has-focus" style="margin-bottom: 6px;">
														<input type="text" id="datepicker_input_create" aria-label="Year-Month">
														<span class="tui-ico-date"></span>
													</div>
													<div class="datepicker-cell" id="datepicker_create" style="margin-top: -1px;"></div>
												</td>
												<th>기본 근무자 수</th>
												<td>
													<input type="number" id="input_basicWorker" class="form-control form-control-sm" style="width:50%" min="0">
												</td>
												<td id="td_tableBtnList" style="text-align:center;">
													<button type="button" id="btn_initCreate" class="header-btn btn btn-warning btn-sm">생성</button>
													<button type="button" id="btn_tableReset" class="header-btn btn btn-warning btn-sm">테이블 초기화</button>
												</td>
												<th class="td_filter">적용 기준</th>
												<td class="td_filter">
													<div class="form-group">
														<select class="form-control form-control-sm" id="select_filter">
															<option value="none">기준 선택</option>
															<option value="day">요일</option>
															<option value="time">시간</option>
															<option value="range">사용자 지정</option>
														</select>
													</div>
												</td>
												<td style="text-align:center;">
													<button type="button" id="btn_clearFilter" class="header-btn btn btn-warning btn-sm">필터 초기화</button>
												</td>
											</tr>
											
											<tr id="td_day" style="border-bottom: 1px solid lightgray">
												<th>요일별 일괄 수정</th>
												<td colspan="4">
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_1" name="selectDay" class="custom-control-input" value="1">
														<label class="custom-control-label" for="checkbox_1">월</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_2" name="selectDay" class="custom-control-input" value="2">
														<label class="custom-control-label" for="checkbox_2">화</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_3" name="selectDay" class="custom-control-input" value="3">
														<label class="custom-control-label" for="checkbox_3">수</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_4" name="selectDay" class="custom-control-input" value="4">
														<label class="custom-control-label" for="checkbox_4">목</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_5" name="selectDay" class="custom-control-input" value="5">
														<label class="custom-control-label" for="checkbox_5">금</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_6" name="selectDay" class="custom-control-input" value="6">
														<label class="custom-control-label" for="checkbox_6">토</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_0" name="selectDay" class="custom-control-input" value="0">
														<label class="custom-control-label" for="checkbox_0">일</label>
													</div>
												</td>
												<th>변경할 근무자 수</th>
												<td>
													<input type="number" id="input_workerForDay" class="form-control form-control-sm" style="width:100%" min="0">
												</td>
												<td style="text-align: center;">
													<button type="button" id="btn_modifyByday" class="header-btn btn btn-warning btn-sm">적용</button>
												</td>
											</tr>
											<tr id="td_time" style="border-bottom: 1px solid lightgray">
												<th>Time별 일괄 수정</th>
												<td colspan="4">
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_1t" name="selectTime" class="custom-control-input" value="1t">
														<label class="custom-control-label" for="checkbox_1t">1 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_2t" name="selectTime" class="custom-control-input" value="2t">
														<label class="custom-control-label" for="checkbox_2t">2 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_3t" name="selectTime" class="custom-control-input" value="3t">
														<label class="custom-control-label" for="checkbox_3t">3 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_4t" name="selectTime" class="custom-control-input" value="4t">
														<label class="custom-control-label" for="checkbox_4t">4 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_5t" name="selectTime" class="custom-control-input" value="5t">
														<label class="custom-control-label" for="checkbox_5t">5 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_6t" name="selectTime" class="custom-control-input" value="6t">
														<label class="custom-control-label" for="checkbox_6t">6 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_7t" name="selectTime" class="custom-control-input" value="7t">
														<label class="custom-control-label" for="checkbox_7t">7 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_8t" name="selectTime" class="custom-control-input" value="8t">
														<label class="custom-control-label" for="checkbox_8t">8 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_9t" name="selectTime" class="custom-control-input" value="9t">
														<label class="custom-control-label" for="checkbox_9t">9 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_10t" name="selectTime" class="custom-control-input" value="10t">
														<label class="custom-control-label" for="checkbox_10t">10 Time</label>
													</div>
												</td>
												<th>변경할 근무자 수</th>
												<td>
													<input type="number" id="input_workerForTime" class="form-control form-control-sm" style="width:100%" min="0">
												</td>
												<td style="text-align: center;">
													<button type="button" id="btn_modifyByTime" class="header-btn btn btn-warning btn-sm">적용</button>
												</td>
											</tr>
											<tr class="td_range">
												<th rowspan="3">사용자 지정 조건 수정</th>
												<td colspan="7">
													<div class="tui-datepicker-input tui-datetime-input">
														<input id="input_startDate" type="text" aria-label="Date">
														<span class="tui-ico-date"></span>
														<div id="startDate-container" style="margin-left: -1px;"></div>
													</div>
													<span style="margin-left: 10px;margin-right: 10px;margin-top: 30px;vertical-align: bottom;">~</span>
													<div class="tui-datepicker-input tui-datetime-input">
														<input id="input_endDate" type="text" aria-label="Date">
														<span class="tui-ico-date"></span>
														<div id="endDate-container" style="margin-left: -1px;"></div>
													</div>
												</td>
											</tr>
											<tr class="td_range">
												<td colspan="7">
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_1" name="selectRangeDay" class="custom-control-input" value="1">
														<label class="custom-control-label" for="checkbox_range_1">월</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_2" name="selectRangeDay" class="custom-control-input" value="2">
														<label class="custom-control-label" for="checkbox_range_2">화</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_3" name="selectRangeDay" class="custom-control-input" value="3">
														<label class="custom-control-label" for="checkbox_range_3">수</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_4" name="selectRangeDay" class="custom-control-input" value="4">
														<label class="custom-control-label" for="checkbox_range_4">목</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_5" name="selectRangeDay" class="custom-control-input" value="5">
														<label class="custom-control-label" for="checkbox_range_5">금</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_6" name="selectRangeDay" class="custom-control-input" value="6">
														<label class="custom-control-label" for="checkbox_range_6">토</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_0" name="selectRangeDay" class="custom-control-input" value="0">
														<label class="custom-control-label" for="checkbox_range_0">일</label>
													</div>
												</td>
											</tr>
											<tr class="td_range">
												<td colspan="4">
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_1t" name="selectRangeTime" class="custom-control-input" value="1t">
														<label class="custom-control-label" for="checkbox_range_1t">1 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_2t" name="selectRangeTime" class="custom-control-input" value="2t">
														<label class="custom-control-label" for="checkbox_range_2t">2 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_3t" name="selectRangeTime" class="custom-control-input" value="3t">
														<label class="custom-control-label" for="checkbox_range_3t">3 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_4t" name="selectRangeTime" class="custom-control-input" value="4t">
														<label class="custom-control-label" for="checkbox_range_4t">4 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_5t" name="selectRangeTime" class="custom-control-input" value="5t">
														<label class="custom-control-label" for="checkbox_range_5t">5 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_6t" name="selectRangeTime" class="custom-control-input" value="6t">
														<label class="custom-control-label" for="checkbox_range_6t">6 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_7t" name="selectRangeTime" class="custom-control-input" value="7t">
														<label class="custom-control-label" for="checkbox_range_7t">7 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_8t" name="selectRangeTime" class="custom-control-input" value="8t">
														<label class="custom-control-label" for="checkbox_range_8t">8 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_9t" name="selectRangeTime" class="custom-control-input" value="9t">
														<label class="custom-control-label" for="checkbox_range_9t">9 Time</label>
													</div>
													<div class="custom-control custom-checkbox custom-control-inline">
														<input type="checkbox" id="checkbox_range_10t" name="selectRangeTime" class="custom-control-input" value="10t">
														<label class="custom-control-label" for="checkbox_range_10t">10 Time</label>
													</div>
												</td>
												<th>변경할 근무자 수</th>
												<td>
													<input type="number" id="input_workerForRange" class="form-control form-control-sm" style="width:100%" min="0">
												</td>
												<td style="text-align: center;">
													<button type="button" id="btn_modifyByRange" class="header-btn btn btn-warning btn-sm">적용</button>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
							<div class="col-md-12 mt-3" id="table_div" style="overflow-y: scroll;">
								<div class="table-responsive" >
									<table class="table table-bordered" id="table_reserve">
										<thead>
											<tr>
												<th scope="col" style="width: 100px;">날짜</th>
												<th scope="col" style="width: 100px;">기본 근무자 수</th>
												<th scope="col" style="width: 80px;">1 Time<br><span id="span_1t"></span></th>
												<th scope="col" style="width: 80px;">2 Time<br><span id="span_2t"></span></th>
												<th scope="col" style="width: 80px;">3 Time<br><span id="span_3t"></span></th>
												<th scope="col" style="width: 80px;">4 Time<br><span id="span_4t"></span></th>
												<th scope="col" style="width: 80px;">5 Time<br><span id="span_5t"></span></th>
												<th scope="col" style="width: 80px;">6 Time<br><span id="span_6t"></span></th>
												<th scope="col" style="width: 80px;">7 Time<br><span id="span_7t"></span></th>
												<th scope="col" style="width: 80px;">8 Time<br><span id="span_8t"></span></th>
												<th scope="col" style="width: 80px;">9 Time<br><span id="span_9t"></span></th>
												<th scope="col" style="width: 80px;">10 Time<br><span id="span_10t"></span></th>
											</tr>
										</thead>
										<tbody id="reservation_tbody">
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
</div>
