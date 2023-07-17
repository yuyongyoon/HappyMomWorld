<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<script>
$(document).ready(function() {
	let calMonthKo = new tui.DatePicker('#datepicker-month-ko', {
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

	}; //btnCom END

	//기타 함수 객체
	fnCom = {

	}; //fnCom END
}); //END $(document).ready

let checkUnload = true;
$(window).on("beforeunload", function(){
	if(checkUnload) {
		return '변경사항이 저장되지 않을 수 있습니다.';
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
											<span class="row-title">마스터 관리</span>
										</div>
										<div class="col-sm-6">
											<div class="button-list float-right">
												<button type="button" id="btn_get" class="header-btn btn btn-secondary float-left ml-2 mb-2">조회</button>
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
										<th>제외할 요일</th>
										<td colspan="2">
											<div class="row ml-1">
												<div class="custom-control custom-checkbox custom-control-inline">
													<input type="checkbox" id="checkbox_1" name="selectDay" class="custom-control-input">
													<label class="custom-control-label" for="checkbox_1">월</label>
												</div>
												<div class="custom-control custom-checkbox custom-control-inline">
													<input type="checkbox" id="checkbox_2" name="selectDay" class="custom-control-input">
													<label class="custom-control-label" for="checkbox_2">화</label>
												</div>
												<div class="custom-control custom-checkbox custom-control-inline">
													<input type="checkbox" id="checkbox_3" name="selectDay" class="custom-control-input">
													<label class="custom-control-label" for="checkbox_3">수</label>
												</div>
												<div class="custom-control custom-checkbox custom-control-inline">
													<input type="checkbox" id="checkbox_4" name="selectDay" class="custom-control-input">
													<label class="custom-control-label" for="checkbox_4">목</label>
												</div>
												<div class="custom-control custom-checkbox custom-control-inline">
													<input type="checkbox" id="checkbox_5" name="selectDay" class="custom-control-input">
													<label class="custom-control-label" for="checkbox_5">금</label>
												</div>
												<div class="custom-control custom-checkbox custom-control-inline">
													<input type="checkbox" id="checkbox_6" name="selectDay" class="custom-control-input">
													<label class="custom-control-label" for="checkbox_6">토</label>
												</div>
												<div class="custom-control custom-checkbox custom-control-inline">
													<input type="checkbox" id="checkbox_0" name="selectDay" class="custom-control-input">
													<label class="custom-control-label" for="checkbox_0">일</label>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>예약 시간</th>
										<td>
											<div style="display: flex;">
											<input type="time" id="input_id_name" class="form-control form-control-sm" style="width:50%;height:15%"/>
											<span class="mr-2 ml-2 mt-2">  ~  </span>
											<input type="time" id="input_id_name" class="form-control form-control-sm" style="width:50%;height:15%"/>
											</div>
										</td>
										
										<th>동시 예약 건수</th>
										<td>
											<input type="number" id="input_comment" class="form-control form-control-sm" style="width:30%;height:15%"/>
										</td>
									</tr>
								</tbody>
							</table>
							
							<!-- Grid -->
							<div class="col-md-12">
								<div id="reservation_status_grid"></div>
							</div>
								
						</div>
					</div>
				</div>	
			</div>
		</div>
	</div>
</div>