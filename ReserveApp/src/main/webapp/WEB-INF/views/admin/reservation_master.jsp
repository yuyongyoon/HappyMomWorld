<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
table > tr :{
	text-align: center;
}
</style>
<script>
$(document).ready(function() {

	
	let stdMonthPicker = new tui.DatePicker('#datepicker-month-ko', {
		date: new Date(),
		language: 'ko',
		type: 'month',
		input: {
			element: '#datepicker-input-ko',
			format: 'yyyy-MM'
		}
	});
	
	//통신 객체
	ajaxCom = {

	}; //ajaxCom END
	
	//이벤트 객체 : id값을 주면 클릭 이벤트 발생
	btnCom = {
		btn_initCreate: function() {
			let stdMonth = stdMonthPicker.getDate();
			
			let startOfMonth = new Date(stdMonth.getFullYear(), stdMonth.getMonth(), 1); // 기준 월의 시작일
			let endOfMonth = new Date(stdMonth.getFullYear(), stdMonth.getMonth() + 1, 0); // 기준 월의 마지막일
			
			let datesArray = [];
			let currentDate = new Date(startOfMonth);

			while (currentDate <= endOfMonth) {
// 				if (!removeDay.includes(currentDate.getDay())) {
					datesArray.push(new Date(currentDate));
// 				}
				currentDate.setDate(currentDate.getDate() + 1);
			}

			let trData;
			
			datesArray.forEach(day => {
				trData += '<tr value="'+cfn_tuiDateFormat(day)+'">'
				trData += '<td style="width:100px;text-align:center;">' + cfn_tuiDateFormat(day) +'</td>'
				trData += '<td style="text-align:center;">'+$('#input_worker').val()+'</td>'
				trData += '<td style="text-align:center;background:#6aca71"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_worker').val()+'"></td>'
				trData += '<td style="text-align:center;background:#6aca71"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_worker').val()+'"></td>'
				trData += '<td style="text-align:center;background:#6aca71"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_worker').val()+'"></td>'
				trData += '<td style="text-align:center;background:#6aca71"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_worker').val()+'"></td>'
				trData += '<td style="text-align:center;background:#6aca71"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_worker').val()+'"></td>'
				trData += '<td style="text-align:center;background:#6aca71"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_worker').val()+'"></td>'
				trData += '<td style="text-align:center;background:#6aca71"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_worker').val()+'"></td>'
				trData += '<td style="text-align:center;background:#6aca71"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_worker').val()+'"></td>'
				trData += '<td style="text-align:center;background:#6aca71"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_worker').val()+'"></td>'
				trData += '<td style="text-align:center;background:#6aca71"><input type="number" style="width:100%;text-align:center;border:0px solid;background:transparent;color:white;" value="'+$('#input_worker').val()+'"></td>'	
				trData += '</tr>'
			})
			$('#reservation_tbody').append(trData);
			$('#btn_initCreate').attr('disabled', 'true');
		},
		btn_reset: function(){
			$('#reservation_tbody').find('tr').remove();
			$('#btn_initCreate').removeAttr('disabled');
		},
		btn_tableUpdateBtn: function() {
			console.log('클릭')
			let editDay = [];
			$("input[name='selectDay']:checked").each(function() {
				editDay.push(Number($(this).val()));
			});
			
			console.log('수정할 요일: ', editDay)
			
			$('#reservation_tbody tr').each(function() {
				let dateValue = $(this).attr('value');
				let dayOfWeek = new Date(dateValue).getDay();
				
				if (editDay.includes(dayOfWeek)) {
					$(this).find('td input').val($('#input_worker').val());
				}
			});
		}
	}; //btnCom END

	//기타 함수 객체
	fnCom = {
	
	}; //fnCom END
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
												<button type="button" id="btn_initCreate" class="header-btn btn btn-secondary float-left ml-2 mb-2">생성</button>
												<button type="button" id="btn_get" class="header-btn btn btn-secondary float-left ml-2 mb-2">조회</button>
												<button type="button" id="btn_save" class="header-btn btn btn-secondary float-left ml-2 mb-2">저장</button>
												<button type="button" id="btn_reset" class="header-btn btn btn-secondary float-left ml-2 mb-2">초기화</button>
												<button type="button" id="btn_download" class="header-btn btn btn-secondary float-left ml-2 mb-2">다운로드</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<table class="table-sm mt-1 mb-2" style="border-top: 1px lightgray solid; border-bottom: 1px lightgray solid;">
								<tbody>
									<tr>
										<th>기준 월</th>
										<td>
											<div class="tui-datepicker-input tui-datetime-input tui-has-focus">
												<input type="text" id="datepicker-input-ko" aria-label="Year-Month">
												<span class="tui-ico-date"></span>
											</div>
											<div class="datepicker-cell" id="datepicker-month-ko" style="margin-top: -1px;"></div>
										</td>
										
										<th>기본 근무자 수</th>
										<td>
											<input type="number" id="input_worker" class="form-control form-control-sm" style="width:50%;height:15%"/>
										</td>
									</tr>
									<tr>
										<th>요일 선택 </th>
										<td>
<!-- 											<div class="row"> -->
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
<!-- 											</div> -->
										</td>
										<th>근무자 수 조정</th>
										<td>
											<input type="number" id="input_worker" class="form-control form-control-sm" style="width:50%;height:15%"/>
										</td>
										<td>
											<button type="button" id="btn_tableUpdateBtn" class="header-btn btn btn-secondary float-left btn-xs">적용</button>
										</td>
									</tr>
								</tbody>
							</table>
							
							<!-- Grid -->
							<div class="col-md-12 mt-3" style="max-height: 600px; min-height: 600px; overflow-y: scroll;">
								<div class="table-responsive" >
									<table class="table table-bordered ">
										<thead>
											<tr>
												<th scope="col" style="width: 100px;">날짜</th>
												<th scope="col" style="width: 100px;">근무자 수</th>
												<th scope="col" style="width: 80px;">1 Time</th>
												<th scope="col" style="width: 80px;">2 Time</th>
												<th scope="col" style="width: 80px;">3 Time</th>
												<th scope="col" style="width: 80px;">4 Time</th >
												<th scope="col" style="width: 80px;">5 Time</th>
												<th scope="col" style="width: 80px;">6 Time</th>
												<th scope="col" style="width: 80px;">7 Time</th>
												<th scope="col" style="width: 80px;">8 Time</th>
												<th scope="col" style="width: 80px;">9 Time</th>
												<th scope="col" style="width: 80px;">10 Time</th>
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