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
.cell-with-memo {
	position: relative;
}

.cell-with-memo::before {
	content: "";
	position: absolute;
	top: 0;
	left: 0;
	border-style: solid;
	border-width: 10px 10px 0 0;
	border-color: red transparent transparent transparent;
	pointer-events: none;
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

	let std_worker;
	let std_1t;
	let std_2t;
	let std_3t;
	let std_4t;
	let std_5t;
	let std_6t;
	let std_7t;
	let std_8t;
	let std_9t;
	let std_10t;

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
// 						$('#role').val() == 'SUPERADMIN' ? $('#input_stdWorker').val('') : $('#input_stdWorker').val(result.branchReservationInfo.worker_num);
						if($('#role').val() != 'SUPERADMIN'){
							fnCom.createTable(result);
						}
					} else {
						$('#btn_initCreate').css('display', 'none');
						$('#btn_tableReset').css('display', 'none');
						$('#btn_clearFilter').css('display', '');
						$('.td_filter').css('display', '');
// 						$('#role').val() == 'SUPERADMIN' ? $('#input_stdWorker').val('') : $('#input_stdWorker').val(result.branchReservationInfo.worker_num);
						fnCom.createTable(result);
					}
					
					if($('#role').val() == 'SUPERADMIN'){
						$('#btn_initCreate').css('display', 'none');
						$('#td_day').css('display', 'none');
						$('#td_time').css('display', 'none');
						$('#btn_set').css('display', 'none');
						$('#btn_save').css('display', 'none');
// 						$('.stdWorker').css('display', 'none');
						$('.td_filter').css('display', 'none');
						$('#btn_clearFilter').css('display','none')
						
						$('#reservation_tbody tr').each(function() {
							$(this).find('td').each(function() {
								$(this).find('input').prop('disabled', true);
							});
						});
						
						cfn_tableResize('table_div', 300);
					} else {
// 						std_worker = result.branchReservationInfo.worker_num;
// 						std_1t = result.branchReservationInfo.t1_name;
// 						std_2t = result.branchReservationInfo.t2_name;
// 						std_3t = result.branchReservationInfo.t3_name;
// 						std_4t = result.branchReservationInfo.t4_name;
// 						std_5t = result.branchReservationInfo.t5_name;
// 						std_6t = result.branchReservationInfo.t6_name;
// 						std_7t = result.branchReservationInfo.t7_name;
// 						std_8t = result.branchReservationInfo.t8_name;
// 						std_9t = result.branchReservationInfo.t9_name;
// 						std_10t = result.branchReservationInfo.t10_name;
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
			
			let ranchReservationInfo = {
					rsv_month	: $('#datepicker_input_create').val(),
// 					worker_num	: $('#input_stdWorker').val(),
					t1_name		: std_1t,
					t2_name		: std_2t,
					t3_name		: std_3t,
					t4_name		: std_4t,
					t5_name		: std_5t,
					t6_name		: std_6t,
					t7_name		: std_7t,
					t8_name		: std_8t,
					t9_name		: std_9t,
					t10_name	: std_10t
			}
			
			$.doPost({
				url		: "/admin/saveReservationMasterData",
				data	: { data : param,
							delInfo : deleteInfo,
							branchReservationInfo : ranchReservationInfo
						},
				success	: function(result){
					if(result.msg == 'success') {
						checkUnload = false;
						$('#btn_tableReset').css('display','none');
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
		saveBranchReservationInfo: function(param){
			$.doPost({
				url		: "/admin/saveBranchReservationInfo",
				data	: param,
				success	: function(result){
					if(result.msg == 'success') {
						std_worker = param.worker_num;
						std_1t = param.t1_name;
						std_2t = param.t2_name;
						std_3t = param.t3_name;
						std_4t = param.t4_name;
						std_5t = param.t5_name;
						std_6t = param.t6_name;
						std_7t = param.t7_name;
						std_8t = param.t8_name;
						std_9t = param.t9_name;
						std_10t = param.t10_name;
// 						$('#input_stdWorker').val(std_worker);
						$('#btn_get').click();
						alert('저장되었습니다.');
						$('#rsv_set_modal').modal('hide');
					} else {
						alert('오류가 발생하였습니다.');
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		}
	};
	
	btnCom = {
		btn_get: function(){
			ajaxCom.getReservationMasterData();
		},
		btn_initCreate: function() {
			$('#reservation_tbody').find('tr').remove();
			$('#btn_tableReset').css('display','');
			
// 			if($('#input_stdWorker').val() == null || $('#input_stdWorker').val() == ''){
// 				alert('기준 근무자 수를 입력해주세요.');
// 				return false;
// 			}
			
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
// 				trData += '<td>'+$('#input_stdWorker').val()+'</td>'
				for(let i = 1; i <= 10; i++){
// 					trData += '<td value="'+i+'t" input_val="'+$('#input_stdWorker').val()+'"><input type="number" min="0" value="0"></td>'
					trData += '<td value="'+i+'t" input_val="0"><input type="number" min="0" value="0"></td>'
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
		btn_save: function(){
			let selectMonth = $('#datepicker_input_create').val();
			let trList = $('#reservation_tbody tr');
// 			let workerNum = $('#input_stdWorker').val();
// 			std_worker = $('#input_stdWorker').val();
			
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
// 					rsv_worker: workerNum
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

			$("#input_workerForDay").val('');
			$("#input_workerForTime").val('');

			
		},
		btn_tableReset: function(){
			if (confirm('입력된 내용들이 사라집니다.')) {
				$('#reservation_tbody').find('tr').remove();
				$('#btn_initCreate').css('display','');
				$('#btn_tableReset').css('display','none');
// 				$('#select_filter').val('none');
// 				$('.td_filter').css('display', 'none');
// 				$('#btn_clearFilter').css('display','none');
// 				$('#td_day').css('display','none');
// 				$('#td_time').css('display','none');
// 				$('.td_range').css('display','none');
			}
		},
		btn_set: function(){
			$('#rsv_set_modal').modal('show');
			$('#input_worker').val(std_worker);
			$('#modal_1t').val(std_1t);
			$('#modal_2t').val(std_2t);
			$('#modal_3t').val(std_3t);
			$('#modal_4t').val(std_4t);
			$('#modal_5t').val(std_5t);
			$('#modal_6t').val(std_6t);
			$('#modal_7t').val(std_7t);
			$('#modal_8t').val(std_8t);
			$('#modal_9t').val(std_9t);
			$('#modal_10t').val(std_10t);
		},
		btn_cancle: function(){
			$('#rsv_set_modal').modal('hide');
		},
		btn_saveBranchReservationInfo(){
			if( $('#input_worker').val() != '' 
				&& $('#modal_1t').val() != '' && $('#modal_2t').val() != '' && $('#modal_3t').val() != '' && $('#modal_4t').val() != '' 
				&& $('#modal_5t').val() != '' && $('#modal_6t').val() != '' && $('#modal_7t').val() != '' && $('#modal_8t').val() != '' 
				&& $('#modal_9t').val() != '' && $('#modal_10t').val() != '') {
				
				let param = {
						rsv_month	: $('#datepicker_input_create').val(),
						worker_num	: $('#input_worker').val(),
						t1_name		: $('#modal_1t').val(),
						t2_name		: $('#modal_2t').val(),
						t3_name		: $('#modal_3t').val(),
						t4_name		: $('#modal_4t').val(),
						t5_name		: $('#modal_5t').val(),
						t6_name		: $('#modal_6t').val(),
						t7_name		: $('#modal_7t').val(),
						t8_name		: $('#modal_8t').val(),
						t9_name		: $('#modal_9t').val(),
						t10_name	: $('#modal_10t').val()
				}
				ajaxCom.saveBranchReservationInfo(param);
			} else {
				alert('칸을 모두 입력해주세요.');
				return false;
			}

		}
	};

	fnCom = {
		createTable: function(list){
			$('#reservation_tbody').find('tr').remove();
			for(let i = 0; i <=10; i++){
				$('#span_'+i+'t').text(list.branchReservationInfo['t'+i+'_name']);
			}
			
			let trData;
			list.masterList.forEach(function(data){
				trData += '<tr value="'+data.rsv_date+'">'
				trData += '<td>' + data.rsv_date +'</td>'
// 				trData += '<td>'+data.worker_num+'</td>'
				for(let i = 1; i <= 10; i++){
					if(data[i+'t_cnt'] == 0){
						trData += '<td value="'+i+'t" input_val="'+data[i+'t']+'"><input type="number" min="'+data[i+'t_cnt']+'" value="'+data[i+'t']+'"></td>'
					} else {
						trData += '<td value="'+i+'t" input_val="'+data[i+'t']+'" class="cell-with-memo" data-toggle="tooltip"  data-placement="bottom" title="예약된 건수: '+data[i+'t_cnt']+'"><input type="number" min="'+data[i+'t_cnt']+'" value="'+data[i+'t']+'"></td>'
					}
					
				}
				trData += '</tr>'
			})
			$('#reservation_tbody').append(trData);
		}
	};
	
// 	$('#input_stdWorker').blur(function(){
// 		if($('#input_stdWorker').val() < 0){
// 			$('#input_stdWorker').val(0);
// 		}
// 	});
	
	stdMonthPicker.on('change', function(){
		ajaxCom.getReservationMasterData();
	})
	
	ajaxCom.getReservationMasterData();
	cfn_tableResize('table_div', 380);
});


$(window).on("beforeunload", function(){
	if($('#role').val() == 'SUPERADMIN'){
		checkUnload = false;
	}
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
												<button type="button" id="btn_set" class="header-btn btn btn-secondary float-left ml-2 mb-2">설정</button>
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
<!-- 												<th class="stdWorker">기준 근무자 수</th> -->
<!-- 												<td class="stdWorker"> -->
<!-- 													<input type="number" id="input_stdWorker" class="form-control form-control-sm" style="width:50%" min="0"> -->
<!-- 												</td> -->
												<td colspan="4" id="td_tableBtnList" style="text-align:center;">
													<button type="button" id="btn_initCreate" class="header-btn btn btn-warning btn-sm">테이블 생성</button>
													<button type="button" id="btn_tableReset" class="header-btn btn btn-warning btn-sm">테이블 초기화</button>
													<button type="button" id="btn_clearFilter" class="header-btn btn btn-warning btn-sm">필터 초기화</button>
												</td>
<!-- 												<td style="text-align:center;"> -->
													
<!-- 												</td> -->
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
												<th>근무자 수</th>
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
												<th>근무자 수</th>
												<td>
													<input type="number" id="input_workerForTime" class="form-control form-control-sm" style="width:100%" min="0">
												</td>
												<td style="text-align: center;">
													<button type="button" id="btn_modifyByTime" class="header-btn btn btn-warning btn-sm">적용</button>
												</td>
											</tr>

										</tbody>
									</table>
								</div>
							</div>
							
							<div class="col-md-12 mt-3" id="table_div" style="overflow-y: auto;">
								<div class="table-responsive" >
									<table class="table table-bordered" id="table_reserve">
										<thead>
											<tr>
												<th scope="col" style="width: 100px;">날짜</th>
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
			
			<div class="modal fade" id="rsv_set_modal" tabindex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title" >예약 설정</h4>
						</div>
						<div class="modal-body">
							<form>
							<div class="col-12">
								<div class="form-group row pb-0">
									<div class="col-sm-3">
										<label for="input_worker" class="control-label mt-2">기준 근무자 수</label>
									</div>
									<div class="col-sm-9">
										<input type="number" class="form-control" id="input_worker">
									</div>
								</div>
								<hr>
								<div class="col-sm-12 col-sm-12 pl-2 pb-1 pt-1">
									<span>고객에게 보여질 시간</span>
								</div>
								<div class="form-group row pb-0">
									<div class="col-sm-2">
										<label class="control-label mt-2" style="border: 0px;" for="modal_1t">1 Time</label>
									</div>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="modal_1t">
									</div>
									<div class="col-sm-2">
										<label class="control-label mt-2" style="border: 0px;" for="modal_2t">2 Time</label>
									</div>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="modal_2t">
									</div>
								</div>
								<div class="form-group row pb-0">
									<div class="col-sm-2">
										<label class="control-label mt-2" style="border: 0px;" for="modal_3t">3 Time</label>
									</div>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="modal_3t">
									</div>
									<div class="col-sm-2">
										<label class="control-label mt-2" style="border: 0px;" for="modal_4t">4 Time</label>
									</div>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="modal_4t">
									</div>
								</div>
								<div class="form-group row pb-0">
									<div class="col-sm-2">
										<label class="control-label mt-2" style="border: 0px;" for="modal_5t">5 Time</label>
									</div>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="modal_5t">
									</div>
									<div class="col-sm-2">
										<label class="control-label mt-2" style="border: 0px;" for="modal_6t">6 Time</label>
									</div>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="modal_6t">
									</div>
								</div>
								<div class="form-group row pb-0">
									<div class="col-sm-2">
										<label class="control-label mt-2" style="border: 0px;" for="modal_7t">7 Time</label>
									</div>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="modal_7t">
									</div>
									<div class="col-sm-2">
										<label class="control-label mt-2" style="border: 0px;" for="modal_8t">8 Time</label>
									</div>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="modal_8t">
									</div>
								</div>
								<div class="form-group row pb-0">
									<div class="col-sm-2">
										<label class="control-label mt-2" style="border: 0px;" for="modal_9t">9 Time</label>
									</div>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="modal_9t">
									</div>
									<div class="col-sm-2">
										<label class="control-label mt-2" style="border: 0px;" for="modal_10t">10 Time</label>
									</div>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="modal_10t">
									</div>
								</div>
							</div>
							</form>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" id="btn_saveBranchReservationInfo">저장</button>
							<button type="button" class="btn btn-info" id="btn_cancle">취소</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

