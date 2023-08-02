<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<script>
$(document).ready(function() {
	const today = new Date();
	const nextMonth = new Date(today).setMonth(today.getMonth() + 1);;
	const searchPicker = tui.DatePicker.createRangePicker({
		startpicker: {
			date: today,
			input: '#input_startDate',
			container: '#startDate-container'
		},
		endpicker: {
			date: nextMonth,
			input: '#input_endDate',
			container: '#endDate-container'
		},
		language: 'ko',
		format: 'YYYY-MM-dd'
	});
	const monthPicker = new tui.DatePicker('#datepicker_create', {
		date: today,
		language: 'ko',
		type: 'month',
		input: {
			element: '#datepicker_input_create',
			format: 'yyyy-MM'
		}
	});
	let modalPicker;
	let modalGrid;

	ajaxCom = {
			getReservationStatusList : function() {
				let startDate;
				let endDate;
				
				if($('input[name="searchRange"]:checked').val() == 'day'){
					startDate = cfn_tuiDateFormat(today);
					endDate = cfn_tuiDateFormat(today);
				} else if($('input[name="searchRange"]:checked').val() == 'week') {
					startDate = cfn_tuiDateFormat(today);
					endDate = cfn_tuiDateFormat(new Date(today.getFullYear(), today.getMonth(), today.getDate()+6));
				} else if($('input[name="searchRange"]:checked').val() == 'month'){
					let month = monthPicker.getDate();
					startDate = cfn_tuiDateFormat(new Date(month.getFullYear(), month.getMonth(), 1));
					endDate = cfn_tuiDateFormat(new Date(month.getFullYear(), month.getMonth()+1, 0));
				} else {
					startDate = $('#input_startDate').val();
					endDate = $('#input_endDate').val();
				}
				
				//console.log(startDate, endDate)
				
				let userIdOrName = $('#input_id_name').val();
				let phoneNumber = $('#input_phone').val();
				let remark = $('#input_comment').val();
				
				if($('#role').val() == 'SUPERADMIN'){
					let superBranchCode = $('#select-branch');
				}
				
				if($('#select-branch').val() != ''){
					superBranchCode = $('#select-branch').val();
				} else {
					superBranchCode = '';
				}
				
				$.doPost({
					url	 	: "/admin/getReservationStatusList",
					data 	: {
						userIdOrName		: userIdOrName,
						phoneNumber			: phoneNumber,
						startDate			: startDate,
						endDate				: endDate,
						remark				: remark,
						super_branch_code 	: superBranchCode
					},
					success	: function(result) {
						$('#reservationCnt').text(result.reservationStatusList.length);
						statusGrid.resetData(result.reservationStatusList);
					},
					error	: function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			},
			getReservationModal: function() {
				let month = $('#datepicker_input_create').val();
				let date = $('#input_datepicker_modal').val();
				if($('#role').val() == 'SUPERADMIN'){
					let superBranchCode = $('#select-branch');
				}
// 				console.log("month: ", month,"\ndate: ", date, "\ncode: ", superBranchCode)
				$.doPost({
					url	 	: "/admin/getReservationModal",
					data 	: {
						rsv_date	: date,
						rsv_month	: month,
						super_branch_code	: superBranchCode
					},
					success	: function(result) {
// 						console.log('modal list >>',result.rsvListModal)
						//그리드 삭제
						modalGrid.resetData(result.rsvListModal);
					},
					error	: function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			}
			
	};
	
	//이벤트 객체
	btnCom = {
		btn_download: function(){
			tuiGrid.dataExport(statusGrid,'해피맘월드_예약현황.xlsx');
		},
		btn_get: function(){
			ajaxCom.getReservationStatusList();
		},
		btn_close_modal: function(){
			let modalId = $(this).closest(".modal").attr("id");
			$('#editUserInfo_modal').modal('hide');
		}
	}; //btnCom END

	//기타 함수 객체
	fnCom = {
		reservationChange: function(props, rowKey){
			console.log('reservationChange clicked', props.grid.getRow(rowKey))
		},
		reservationCancle: function(props, rowKey){
			if (confirm("예약을 취소하시겠습니까?")) {
				alert('취소되었습니다.');
				ajaxCom.getReservationStatusList();
			} 
		},
		checkMassage: function(props, rowKdy){
			console.log('checkMassage clicked', props.grid.getRow(rowKey))
		},
		changeRsvModal: function(props, rowKey){
			if (confirm("기존 예약이 취소됩니다. 변경하시겠습니까?")) {
				alert('예약이 변경되었습니다.');
				$('#editUserInfo_modal').modal('hide');
				ajaxCom.getReservationModal();
			} 
		},
// 		changedDatepicker: function(obj){
// 			//let rsvDate = modalPicker.getDate();
// 			console.log('예약 변경 기간: ', $(obj).val());
// 		}
	}; //fnCom END
	
	const statusGrid = tuiGrid.createGrid(
		//그리드 옵션
		{
			gridId : 'reservation_status_grid',
			height : 500,
			scrollX : true,
			scrollY : true,
			readOnlyColorFlag : false,
			rowHeaders: ['rowNum'],
			rowHeight : 32,
			minRowHeight : 25,
			columns: [
				{header : '날짜',			name : 'rsv_date',			align:'left',	sortable: true},
				{header : '시간',			name : 'reservation_time',	align:'left', sortable: true},
				{header : '아이디',		name : 'user_id',		align:'left', sortable: true,  style:'cursor:pointer;text-decoration:underline;', sortable: true},
				{header : '이름',			name : 'name',				align:'left', sortable: true},
				{header : '전화번호',		name : 'phone_number',		align:'left', sortable: true},
				{header : '예약한 날짜',	name : 'created_dt',		align:'left', sortable: true},
				{header : '예약한 시간대',	name : 'select_time',		hidden:true},
				{header : '예약변경',		name : 'change',			width : 150, align:'center', 
					renderer: {
						type : ButtonRenderer,
						options : {
							value : '변경',
							click: fnCom.reservationChange
						}
					}
				},
				{header : '예약취소',		name : 'cancle',	width : 150, align:'center',
					renderer: {
						type : ButtonRenderer,
						options : {
							value : '취소',
							click: fnCom.reservationCancle
						}
					}
				},
				{header : '마사지 확인',	name : 'check',		width : 150,	align:'center',
					renderer: {
						type : ButtonRenderer,
						options : {
							value : '확인',
							click: fnCom.checkMassage
						}
					}
				}
			]
		},
		[],//초기 데이터
		//이벤트
		// 회원 정보 수정 modal(수정중)
		{
			cellclick : function(rowKey,colName,grid){
				if(colName=="user_id"){
					let rowData = statusGrid.getRow(rowKey);
					$('#input_datepicker_modal').val(rowData.rsv_date);
					modalPicker = new tui.DatePicker('#div_datepicker_modal', {
						date: new Date(input_datepicker_modal),
						language: 'ko',
						input: {
							element: '#input_datepicker_modal',
							format: 'yyyy-MM-dd'
						}
					});
					
					$('#editUserInfo_modal').modal('show');
					
					//체인지 이벤트
					modalPicker.on('change', function(){
						console.log('변경')
					})
				}
			}
		}
	);
	
	ajaxCom.getReservationStatusList();
	
	$('table input').on('keydown', function(event) {
		if(event.keyCode == 13) {
			ajaxCom.getReservationStatusList();
		}
	});
	// id 클릭 시 modal 팝업과 동시에 grid 생성
	$('#editUserInfo_modal').on('shown.bs.modal', function(e){
		modalGrid = tuiGrid.createGrid (
			{
				gridId : 'grid_userInfo_modal',
				height : 300,
				scrollX : true,
				scrollY : true,
				readOnlyColorFlag : false,
				columns: [
					{header : '시간',		name : 'rsv_time',	width: 250,	align:'center', sortable: true},
					{header : '예약변경',	name : 'change',	width: 200,	align:'center', 
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
		ajaxCom.getReservationModal();
	});
	$('#input_datepicker_modal').change(function(){
		console.log("rsv date: ", $('#input_datepicker_modal').val())
	});
}); //END $(document).ready
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
											<span class="row-title">예약 현황 조회</span>
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
										<th>조회기간</th>
										<td colspan="6">
											<div class="row ml-1">
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_day" name="searchRange" class="custom-control-input" value="day">
													<label class="custom-control-label" for="radio_day">오늘</label>
												</div>
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_week" name="searchRange" class="custom-control-input" value="week">
													<label class="custom-control-label" for="radio_week">주</label>
												</div>
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_month" name="searchRange" class="custom-control-input" value="month" checked="checked">
													<label class="custom-control-label" for="radio_month">월</label>
													<div class="tui-datepicker-input tui-datetime-input tui-has-focus" style="margin-bottom: 6px;">
														<input type="text" id="datepicker_input_create" aria-label="Year-Month">
														<span class="tui-ico-date"></span>
													</div>
													<div class="datepicker-cell" id="datepicker_create" style="margin-top: -1px;"></div>
												</div>
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_picker" name="searchRange" class="custom-control-input" value="range">
													<label class="custom-control-label" for="radio_picker">기간선택</label>
													<div class="tui-datepicker-input tui-datetime-input ml-1">
														<input id="input_startDate" type="text" aria-label="Date">
														<span class="tui-ico-date"></span>
														<div id="startDate-container" style="margin-left: -1px;"></div>
													</div>
													<span class="m-t-1"> ~ </span>
													<div class="tui-datepicker-input tui-datetime-input">
														<input id="input_endDate" type="text" aria-label="Date">
														<span class="tui-ico-date"></span>
														<div id="endDate-container" style="margin-left: -1px;"></div>
													</div>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>이름 / 아이디</th>
										<td><input type="text" id="input_id_name" class="form-control form-control-sm" style="width:75%;height:15%"/></td>
										<th>전화번호</th>
										<td><input type="text" id="input_phone" class="form-control form-control-sm" style="width:75%;height:15%"/></td>
										<th>비고</th>
										<td><input type="text" id="input_comment" class="form-control form-control-sm" style="width:75%;height:15%"/></td>
									</tr>
								</tbody>
							</table>
							
							<div class="sub-titlebar">
								<div class="float-right mt-1 mb-1 mr-2">
									조회 건수: <span id="reservationCnt"></span>건
								</div>
							</div>
							
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
<div class="modal fade" id="editUserInfo_modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">사용자 정보 수정</h4>
			</div>
			
			<div class="form-group row pb-0"  style="margin: 6px;">
				<label class="control-label mt-2 mr-3">날짜</label>
				<div class="tui-datepicker-input tui-datetime-input tui-has-focus" style="margin-bottom: 6px;">
					<input type="text" id="input_datepicker_modal" aria-label="date">
					<span class="tui-ico-date"></span>
				</div>
				<div class="datepicker-cell" id="div_datepicker_modal" style="margin-top: -1px;"></div>
			</div>
			
			<div class="modal-body">
				<div>
					<div id="grid_userInfo_modal"></div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" id="btn_save_modal">저장</button>
				<button type="button" class="btn btn-info" id="btn_close_modal">취소</button>
			</div>
		</div>
	</div>
</div>