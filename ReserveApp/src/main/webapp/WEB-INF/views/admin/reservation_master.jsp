<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
table > tr :{
	text-align: center;
}
</style>
<script>
$(document).ready(function() {
	let searchMonthPicker = new tui.DatePicker('#datepicker_search', {
		date: new Date(),
		language: 'ko',
		type: 'month',
		input: {
			element: '#datepicker_input_search',
			format: 'yyyy-MM'
		}
	})
	
	let stdMonthPicker = new tui.DatePicker('#datepicker_create', {
		date: new Date(),
		language: 'ko',
		type: 'month',
		input: {
			element: '#datepicker_input_create',
			format: 'yyyy-MM'
		}
	});
	
	//통신 객체
	ajaxCom = {
		getReservationMasterData: function(){
			let param = {
				rsv_month : searchMonthPicker.getDate().getMonth()+1
			}
			
			$.doPost({
				url		: "/admin/getReservationMasterData",
				data	: param,
				success	: function(result){
					if(result.masterList == 0) {
						$('#pills-basic-tab').click();
					} else {
						fnCom.createTable(result);
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		saveReservationMasterData: function(param){
			$.doPost({
				url		: "/admin/saveReservationMasterData",
				data	: {data : param,
							stdMonth : stdMonthPicker.getDate().getMonth() + 1
						},
				success	: function(result){
					if(result.msg == 'success') {
						alert('저장 되었습니다.');
					} else {
// 						alert(result.msg);
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
		btn_initCreate: function() {
			
			if($('#input_basicWorker').val() == null || $('#input_basicWorker').val() == ''){
				alert('기본 근무자 수를 입력해주세요.');
				return false;
			}
			
			$('#span_1t').text($('#input_1t').val());
			$('#span_2t').text($('#input_2t').val());
			$('#span_3t').text($('#input_3t').val());
			$('#span_4t').text($('#input_4t').val());
			$('#span_5t').text($('#input_5t').val());
			$('#span_6t').text($('#input_6t').val());
			$('#span_7t').text($('#input_7t').val());
			$('#span_8t').text($('#input_8t').val());
			$('#span_9t').text($('#input_9t').val());
			$('#span_10t').text($('#input_10t').val());
			
			let stdMonth = stdMonthPicker.getDate();
			let startOfMonth = new Date(stdMonth.getFullYear(), stdMonth.getMonth(), 1); // 기준 월의 시작일
			let endOfMonth = new Date(stdMonth.getFullYear(), stdMonth.getMonth() + 1, 0); // 기준 월의 마지막일
			let datesArray = [];
			let currentDate = new Date(startOfMonth);

			while (currentDate <= endOfMonth) {
					datesArray.push(new Date(currentDate));
				currentDate.setDate(currentDate.getDate() + 1);
			}

			let trData;
			
			if($('#input_basicWorker').val() > 0) {
				datesArray.forEach(day => {
					trData += '<tr value="'+cfn_tuiDateFormat(day)+'">'
					trData += '<td style="width:100px;text-align:center;">' + cfn_tuiDateFormat(day) +'</td>'
					trData += '<td style="text-align:center;">'+$('#input_basicWorker').val()+'</td>'
					trData += '<td style="text-align:center;background:#6aca71" value="1t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:#6aca71" value="2t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:#6aca71" value="3t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:#6aca71" value="4t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:#6aca71" value="5t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:#6aca71" value="6t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:#6aca71" value="7t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:#6aca71" value="8t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:#6aca71" value="9t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:#6aca71" value="10t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'	
					trData += '</tr>'
				})
			} else {
				datesArray.forEach(day => {
					trData += '<tr value="'+cfn_tuiDateFormat(day)+'">'
					trData += '<td style="width:100px;text-align:center;">' + cfn_tuiDateFormat(day) +'</td>'
					trData += '<td style="text-align:center;">'+$('#input_basicWorker').val()+'</td>'
					trData += '<td style="text-align:center;background:lightgray" value="1t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:lightgray" value="2t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:lightgray" value="3t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:lightgray" value="4t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:lightgray" value="5t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:lightgray" value="6t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:lightgray" value="7t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:lightgray" value="8t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:lightgray" value="9t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'
					trData += '<td style="text-align:center;background:lightgray" value="10t"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_basicWorker').val()+'"></td>'	
					trData += '</tr>'
				})
			}
			
			$('#reservation_tbody').append(trData);
			$('#btn_initCreate').attr('disabled', 'true');
			$("#pills-basic-tab").removeClass('active');
			$('#pills-modify-tab').click();
		},
		btn_resetInputTime: function(){
			$('#input_1t').val('');
			$('#input_2t').val('');
			$('#input_3t').val('');
			$('#input_4t').val('');
			$('#input_5t').val('');
			$('#input_6t').val('');
			$('#input_7t').val('');
			$('#input_8t').val('');
			$('#input_9t').val('');
			$('#input_10t').val('');
		},
		btn_reset: function(){
			$('#reservation_tbody').find('tr').remove();
			$('#btn_initCreate').removeAttr('disabled');
			
			$('#span_1t').text('');
			$('#span_2t').text('');
			$('#span_3t').text('');
			$('#span_4t').text('');
			$('#span_5t').text('');
			$('#span_6t').text('');
			$('#span_7t').text('');
			$('#span_8t').text('');
			$('#span_9t').text('');
			$('#span_10t').text('');
			
			$('#pills-basic-tab').click();
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
							input.val(inputValue);
							
							if (parseInt(inputValue) == 0) {
								column.css("background-color", "lightgray");
							} else {
								column.css("background-color", "#6aca71");
							}
						});
					}
				})
			})
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

			if (inputWorkerForTimeVal < 0 || inputWorkerForTimeVal === '') {
				alert('근무자 수를 입력해주세요.');
				return false;
			}

			let tdList = $("td");
			tdList.each(function() {
				let td = $(this);
				let tdValue = td.attr("value");

				if (editTime.includes(tdValue)) {
					let input = td.find("input");
					input.val(inputWorkerForTimeVal);

					if (inputWorkerForTimeVal == 0) {
						td.css("background-color", "lightgray");
					} else {
						td.css("background-color", "#6aca71");
					}
				}
			});
		},
		btn_save: function(){
			let selectMonth = stdMonthPicker.getDate().getMonth() + 1;
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
		}
	}; //btnCom END

	//기타 함수 객체
	fnCom = {
		createTable: function(list){
			//테이블 초기화
			$('#reservation_tbody').find('tr').remove();
			$('#btn_initCreate').removeAttr('disabled');
			
// 			$('#span_1t').text('');
// 			$('#span_2t').text('');
// 			$('#span_3t').text('');
// 			$('#span_4t').text('');
// 			$('#span_5t').text('');
// 			$('#span_6t').text('');
// 			$('#span_7t').text('');
// 			$('#span_8t').text('');
// 			$('#span_9t').text('');
// 			$('#span_10t').text('');

//trData += '<tr value="'+cfn_tuiDateFormat(day)+'">'
// 					trData += '<td style="width:100px;text-align:center;">' + cfn_tuiDateFormat(day) +'</td>'
// 					trData += '<td style="text-align:center;">'+$('#input_basicWorker').val()+'</td>'
			let trData;
			list.masterList.forEach(function(data){
				console.log(data)
				trData += '<tr value="'+data.rsv_date+'">'
				trData += '<td style="width:100px;text-align:center;">' + data.rsv_date +'</td>'
				trData += '<td style="text-align:center;">'+data.rsv_worker+'</td>'
				
			})
			
			$('#reservation_tbody').append(trData);
		}
	}; //fnCom END
	
	$('#input_basicWorker').blur(function(){
		if($('#input_basicWorker').val() < 0){
			$('#input_basicWorker').val(0);
		}
	});
	
	$('#pills-search-tab').click(function() {
		ajaxCom.getReservationMasterData();
	})
	
	ajaxCom.getReservationMasterData();
}); //END $(document).ready

// let checkUnload = true;
// $(window).on("beforeunload", function(){
// 	if(checkUnload) {
// 		return '변경사항이 저장되지 않을 수 있습니다.';
// 	}
// });
	
	
$(document).on('input', '#reservation_tbody input[type="number"]', function() {
	let value = $(this).val();
	let parentTd = $(this).parent();
	
	if (value == null || value === '' || value == 0) {
		parentTd.css('background', 'lightgray');
		$(this).css('background', 'transparent');
		$(this).css('color', 'white')
	} else if (value >= 1) {
		parentTd.css('background', '#6aca71');
		$(this).css('background', 'transparent');
		$(this).css('color', 'white');
	}
});


</script>
<style>
table tbody tr th {
	min-width: 100px;
}
</style>
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
												<button type="button" id="btn_reset" class="header-btn btn btn-secondary float-left ml-2 mb-2">초기화</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<ul class="nav nav-pills nav-success" id="pills-tab" role="tablist">
								<li class="nav-item">
									<a class="nav-link active" id="pills-search-tab" data-toggle="pill" href="#pills-search" role="tab" aria-controls="pills-search" aria-selected="true">예약 조회</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" id="pills-basic-tab" data-toggle="pill" href="#pills-basic" role="tab" aria-controls="pills-basic" aria-selected="true">예약 생성</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" id="pills-modify-tab" data-toggle="pill" href="#pills-modify" role="tab" aria-controls="pills-modify" aria-selected="false">예약 수정</a>
								</li>
							</ul>
							<div class="tab-content mt-2 mb-3" id="pills-tabContent">
								<div class="tab-pane fade show active" id="pills-search" role="tabpanel" aria-labelledby="pills-search-tab">
									<table class="table-sm mt-0 mb-2" style="border-top: 1px lightgray solid; border-bottom: 1px lightgray solid; width:100%;">
										<tbody>
											<tr>
												<th style="width:10%">조회 월</th>
												<td>
													<div class="tui-datepicker-input tui-datetime-input tui-has-focus">
														<input type="text" id="datepicker_input_search" aria-label="Year-Month">
														<span class="tui-ico-date"></span>
													</div>
													<div class="datepicker-cell" id="datepicker_search" style="margin-top: -1px;"></div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="tab-pane fade" id="pills-basic" role="tabpanel" aria-labelledby="pills-basic-tab">
									<table class="table-sm mt-0 mb-2" style="border-top: 1px lightgray solid; border-bottom: 1px lightgray solid;">
										<tbody>
											<tr>
												<th colspan="1">기준 월</th>
												<td colspan="4">
													<div class="tui-datepicker-input tui-datetime-input tui-has-focus">
														<input type="text" id="datepicker_input_create" aria-label="Year-Month">
														<span class="tui-ico-date"></span>
													</div>
													<div class="datepicker-cell" id="datepicker_create" style="margin-top: -1px;"></div>
												</td>
												<th>기본 근무자 수</th>
												<td>
													<input type="number" id="input_basicWorker" class="form-control form-control-sm" style="width:100%" min="0">
												</td>
											</tr>
											<tr>
												<th rowspan="2">시간대 설정</th>
												<th style="width: 30px;text-align: center;">1 Time</th>
												<td>
													<input type="text" id="input_1t" class="form-control form-control-sm" style="width:100%" value="09:00 ~ 10:00">
												</td>
												<th style="width: 30px;text-align: center;">2 Time</th>
												<td>
													<input type="text" id="input_2t" class="form-control form-control-sm" style="width:100%" value="10:00 ~ 11:00">
												</td>
												<th style="width: 30px;text-align: center;">3 Time</th>
												<td>
													<input type="text" id="input_3t" class="form-control form-control-sm" style="width:100%" value="11:00 ~ 12:00">
												</td>
												<th style="width: 30px;text-align: center;">4 Time</th>
												<td>
													<input type="text" id="input_4t" class="form-control form-control-sm" style="width:100%" value="12:00 ~ 13:00">
												</td>
												<th style="width: 30px;text-align: center;">5 Time</th>
												<td>
													<input type="text" id="input_5t" class="form-control form-control-sm" style="width:100%" value="13:00 ~ 14:00">
												</td>
											</tr>
											<tr>
												<th style="width: 30px;text-align: center;">6 Time</th>
												<td>
													<input type="text" id="input_6t" class="form-control form-control-sm" style="width:100%" value="14:00 ~ 15:00">
												</td>
												<th style="width: 30px;text-align: center;">7 Time</th>
												<td>
													<input type="text" id="input_7t" class="form-control form-control-sm" style="width:100%" value="15:00 ~ 16:00">
												</td>
												<th style="width: 30px;text-align: center;">8 Time</th>
												<td>
													<input type="text" id="input_8t" class="form-control form-control-sm" style="width:100%" value="16:00 ~ 17:00">
												</td>
												<th style="width: 30px;text-align: center;">9 Time</th>
												<td>
													<input type="text" id="input_9t" class="form-control form-control-sm" style="width:100%" value="17:00 ~ 18:00">
												</td>
												<th style="width: 30px;text-align: center;">10 Time</th>
												<td>
													<input type="text" id="input_10t" class="form-control form-control-sm" style="width:100%" value="18:00 ~ 19:00">
												</td>
											</tr>
											<tr>
												<td colspan="11" style="text-align: center;">
													<button type="button" id="btn_initCreate" class="header-btn btn btn-warning btn-sm">생성</button>
													<button type="button" id="btn_resetInputTime" class="header-btn btn btn-warning btn-sm">시간 설정 초기화</button>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="tab-pane fade" id="pills-modify" role="tabpanel" aria-labelledby="pills-modify-tab">
									<table class="table-sm mt-1 mb-2" style="border-top: 1px lightgray solid; border-bottom: 1px lightgray solid; width:100%">
										<tbody>
											<tr>
												<th>요일별 일괄 수정</th>
												<td colspan="2">
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
													<input type="number" id="input_workerForDay" class="form-control form-control-sm" style="width:100%">
												</td>
												<td style="text-align: center;">
													<button type="button" id="btn_modifyByday" class="header-btn btn btn-warning btn-sm">적용</button>
												</td>
											</tr>
											<tr>
												<th>Time별 일괄 수정</th>
												<td colspan="2">
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
													<input type="number" id="input_workerForTime" class="form-control form-control-sm" style="width:100%">
												</td>
												<td style="text-align: center;">
													<button type="button" id="btn_modifyByTime" class="header-btn btn btn-warning btn-sm">적용</button>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
							

							
							
							<div class="col-md-12 mt-3" style="max-height: 450px;overflow-y: scroll;">
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