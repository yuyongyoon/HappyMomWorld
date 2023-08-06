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
	let changeRsvGrid;

	ajaxCom = {
			getReservationStatusList : function() {
				let startDate;
				let endDate;
				
				if($('input[name="searchRange"]:checked').val() == 'today'){
					startDate = cfn_tuiDateFormat(today);
					endDate = cfn_tuiDateFormat(today);
				} else if($('input[name="searchRange"]:checked').val() == 'tomorrow'){
					const tomorrow = new Date(today);
					tomorrow.setDate(today.getDate() + 1);
					
					startDate = cfn_tuiDateFormat(tomorrow);
					endDate = cfn_tuiDateFormat(tomorrow);
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
						userIdOrName		: $('#input_id_name').val(),
						phoneNumber			: $('#input_phone').val(),
						startDate			: startDate,
						endDate				: endDate,
						super_branch_code 	: superBranchCode,
						rsv_status			: $('#select_rsv_status').val()
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

				$.doPost({
					url	 	: "/admin/getReservationModal",
					data 	: {
						rsv_date	: date,
						rsv_month	: month,
						super_branch_code	: superBranchCode
					},
					success	: function(result) {
						//예약 가능한 날만 생성
						let newData = [];
						result.rsvListModal.forEach( d => {
							if(d.cnt != 0) {
								newData.push(d)
							}
						})
						changeRsvGrid.resetData(newData);
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
							ajaxCom.getReservationStatusList();
						} else {
							alert('오류가 발생했습니다.');
						}
					},
					error	: function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			},
			updateRsvStatus: function(param){
				$.doPost({
					url	 	: "/admin/updateRsvStatus",
					data 	: param,
					success	: function(result) {
						if(result.msg == 'success') {
							alert('변경되었습니다.');
							ajaxCom.getReservationStatusList();
						} else {
							alert('오류가 발생했습니다.');
						}
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
		/* btn_changeRsv: function(){
			
		}, */
		btn_changeRsv_close: function(){
			let modalId = $(this).closest(".modal").attr("id");
			$('#changeRsv_modal').modal('hide');
		},
		btn_updateRsvInfo: function(){
			
		},
		btn_updateRsvInfo_close: function(){
			let modalId = $(this).closest(".modal").attr("id");
			
			if (confirm("창을 닫으면 수정한 내용이 모두 지워집니다. 닫으시겠습니까?")) {
				$('#' + modalId).modal('hide');
			} 
		}
	}; //btnCom END

	//기타 함수 객체
	fnCom = {
		// 예약 변경
		reservationChange: function(props, rowKey){
// 			console.log('reservationChange clicked', props.grid.getRow(rowKey))
			let rowData = statusGrid.getRow(rowKey);
			//console.log('변경 버튼 클릭>>',rowData);
			$('#input_datepicker_modal').val(rowData.rsv_date);
			modalPicker = new tui.DatePicker('#div_datepicker_modal', {
				date: new Date(input_datepicker_modal),
				language: 'ko',
				input: {
					element: '#input_datepicker_modal',
					format: 'yyyy-MM-dd'
				}
			});
			tuiGrid.destroyGrid(changeRsvGrid);
			$('#changeRsv_modal').modal('show');
			
			//체인지 이벤트
			modalPicker.on('change', function(){
				ajaxCom.getReservationModal()
			});
			
		},
		getCurrentTime: function() {
			const now = new Date();
			return now.getHours() + ":" + (now.getMinutes() < 10 ? "0" : "") + now.getMinutes();
		},
		getToday: function() {
			const now = new Date();
			const year = now.getFullYear();
			const month = String(now.getMonth() + 1).padStart(2, "0");
			const day = String(now.getDate()).padStart(2, "0");
			return year + "-" + month + "-" + day;
		},
		// 예약 취소
		reservationCancle: function(props, rowKey){
			let data = props.grid.getRow(rowKey)
			let rsvDate = data.rsv_date;
			let rsvTime = data.reservation_time.substring(0, 5);
			let currentDate = fnCom.getToday();
			let currentTime = fnCom.getCurrentTime();
			
			if (rsvDate < currentDate) {
				alert("예약일이 지나 취소할 수 없습니다.");
				return false;
			} else if (rsvDate == currentDate && rsvTime <= currentTime) { //당일 취소 가능하게 할지 말지 고민중...
				alert("취소할 수 없습니다.");
				return false;
			}

			if (confirm("예약을 취소하시겠습니까?")) {
				let param = {
					user_id		: data.user_id,
					select_time : data.select_time,
					rsv_date	: data.rsv_date,
					flag		: 'd'
				}
				ajaxCom.removeReservation(param);
			} 
		},
		checkMassage: function(props, rowKey){
			let data = props.grid.getRow(rowKey);
			let rsvDate = data.rsv_date;
			let currentDate = fnCom.getToday();
			
			let param = {
				user_id : data.user_id,
				select_time : data.select_time,
				rsv_date : data.rsv_date
			}
			
			if(data.rsv_status == 'Y'){
				if (confirm("미확인으로 변경하시겠습니까?")) {
					param.rsv_status = 'N'
					ajaxCom.updateRsvStatus(param);
				}
			} else {
				if (rsvDate > currentDate) {
					alert("예약 당일이 아닙니다.");
					return false;
				} 
				
				if (confirm("확인으로 변경하시겠습니까?")) {
					param.rsv_status = 'Y'
					ajaxCom.updateRsvStatus(param);
				}
			}
		},
		// 예약 변경 모달 - 변경 버튼
		changeRsvModal: function(props, rowKey){
// 			if (confirm("기존 예약이 취소됩니다. 변경하시겠습니까?")) {
				ajaxCom.getReservationModal();
				
				
// 			} 
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
				{header : '예약ID',				name : 'user_id',			align:'left', sortable: true,  style:'cursor:pointer;text-decoration:underline;', sortable: true},
				{header : '예약자',				name : 'name',				align:'left', sortable: true},
				{header : '전화번호',			name : 'phone_number',		align:'left', sortable: true},
				{header : '예약일',				name : 'rsv_date',			align:'left', sortable: true},
				{header : '예약시간',			name : 'reservation_time',	align:'left', sortable: true},
				{header : '등록일',				name : 'created_dt',		align:'left', sortable: true},
				{header : '당일 확인',			name : 'rsv_status',		align:'center', sortable: true, formatter: 'listItemText', disabled:true, editor: { type: 'select', options: { listItems: [{text:'확인', value:'Y'},{text:'미확인',value:'N'}]}}},
				{header : '등록시',				name : 'select_time',				hidden:true},
				{header : '출산 예정일',		name : 'due_date',					hidden:true},
				{header : '예약 마사지횟수',	name : 'massage_reservation_cnt',	hidden:true},
				{header : '잔여 마사지횟수',	name : 'massage_cnt',				hidden:true},
				{header : '전체 마사지횟수',	name : 'massage_total',				hidden:true},
				{header : '사용여부',			name : 'user_status',				hidden:true},
				{header : '비고',				name : 'remark',					hidden:true},
				{header : '예약 변경',			name : 'change',	width : 100, align:'center', 
					renderer: {
						type : ButtonRenderer,
						options : {
							value : '예약 변경',
							click: fnCom.reservationChange
						}
					}
				},
				{header : '예약취소',			name : 'cancle',	width : 100, align:'center',
					renderer: {
						type : ButtonRenderer,
						options : {
							value : '취소',
							click: fnCom.reservationCancle
						}
					}
				},
				{header : '당일 확인',		name : 'check',		width : 100,	align:'center',
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
			cellclick : function(rowKey,colName,grid,ev){
				if(colName=="user_id"){
					let rowData = statusGrid.getRow(rowKey);
					ajaxCom.getReservationStatusList()
					$('#input_userId_edit').val(rowData.user_id);
					$('#input_userName_edit').val(rowData.name);
					$('#input_phoneNumber_edit').val(rowData.phone_number);
					$('#input_dueDate_edit').val(rowData.due_date);
					$('#input_totalMssgCnt_edit').val(rowData.massage_total);
					$('#input_rsvMssgCnt_edit').val(rowData.massage_reservation_cnt);
					$('#input_restMssgCnt_edit').val(rowData.massage_cnt);
					$('#input_enabled_edit').val(rowData.user_status);
					$('#input_rmk_edit').val(rowData.remark);
 					
					$('#editRsvInfo_modal').modal('show');
				}
			},
		}
	);
	
	ajaxCom.getReservationStatusList();
	
	$('table input').on('keydown', function(event) {
		if(event.keyCode == 13) {
			ajaxCom.getReservationStatusList();
		}
	});
	// id 클릭 시 modal 팝업과 동시에 grid 생성
	$('#editRsvInfo_modal').on('shown.bs.modal', function(e){
		
		changeRsvGrid = tuiGrid.createGrid (
				{
					gridId : 'grid_userRsvList_modal',
					height : 300,
					scrollX : true,
					scrollY : true,
					readOnlyColorFlag : false,
					columns: [
						{header : '예약 날짜',		name : 'rsv_time',	width: 250,	align:'center', sortable: true},
						{header : '예약 시간',		name : 'rsv_time',	width: 250,	align:'center', sortable: true},
						{header : '예약 지점',		name : 'rsv_time',	width: 250,	align:'center', sortable: true},
					]
				},
				[],
				{}
			);
	});
	$('#changeRsv_modal').on('shown.bs.modal', function(e){
		changeRsvGrid = tuiGrid.createGrid (
				{
					gridId : 'grid_changeRsv_modal',
					height : 300,
// 					scrollX : true,
					scrollY : true,
					readOnlyColorFlag : false,
					columns: [
						{header : '시간',		name : 'rsv_time',	align:'center', sortable: true},
						{header : '예약변경',	name : 'change',	align:'center', 
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
	
	//라디오버튼 change 이벤트
	$('input[name="searchRange"]').change(function() {
		ajaxCom.getReservationStatusList();
	})
	
	searchPicker.on('change:start', function(){
		$("#radio_range").prop("checked", true);
		ajaxCom.getReservationStatusList();
	})
	
	searchPicker.on('change:end', function(){
		$("#radio_range").prop("checked", true);
		ajaxCom.getReservationStatusList();
	})
	
	monthPicker.on('change', function(){
		$("#radio_month").prop("checked", true);
		ajaxCom.getReservationStatusList();
	})
	
	$('#select_rsv_status').on('change', function() {
		ajaxCom.getReservationStatusList();
	})
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
											<span class="row-title">예약 현황</span>
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
													<input type="radio" id="radio_today" name="searchRange" class="custom-control-input" value="today" checked="checked">
													<label class="custom-control-label" for="radio_today">오늘</label>
												</div>
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_tomorrow" name="searchRange" class="custom-control-input" value="tomorrow">
													<label class="custom-control-label" for="radio_tomorrow">내일</label>
												</div>
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_week" name="searchRange" class="custom-control-input" value="week">
													<label class="custom-control-label" for="radio_week">주</label>
												</div>
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_month" name="searchRange" class="custom-control-input" value="month">
													<label class="custom-control-label" for="radio_month">월</label>
													<div class="tui-datepicker-input tui-datetime-input tui-has-focus" style="margin-bottom: 6px;">
														<input type="text" id="datepicker_input_create" aria-label="Year-Month">
														<span class="tui-ico-date"></span>
													</div>
													<div class="datepicker-cell" id="datepicker_create" style="margin-top: -1px;"></div>
												</div>
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_range" name="searchRange" class="custom-control-input" value="range">
													<label class="custom-control-label" for="radio_range">기간선택</label>
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
											<th>당일 확인</th>
											<td>
												<select id="select_rsv_status" class="form-control" style="padding: 3px;width:100%;height:15%">
													<option value="Y">확인</option>
													<option value="N" selected>미확인</option>
												</select>
											</td>
<!-- 										</div> -->
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
<!-- 예약자 정보 수정 modal -->
<div class="modal fade" id="editRsvInfo_modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="user_edit_modalTitle">회원 예약 리스트</h4>
			</div>
			<div class="modal-body">
				<div class="col-12">
					<div class="form-group row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2">ID</label>
						</div>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="input_userId_edit" style="border: 0px;" readonly>
						</div>
					</div>
					<div class="form-group row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2" style="border: 0px;">이름</label>
						</div>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="input_userName_edit" maxlength='12'>
						</div>
					</div>
					<div class="form-group row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2" style="border: 0px;">전화번호</label>
						</div>
						<div class="col-sm-9">
							<input type="tel" class="form-control" id="input_phoneNumber_edit">
						</div>
					</div>
					<div class="modal-body">
						<div>
							<div id="grid_userRsvList_modal"></div>
						</div>
					</div>
					<!-- <div class="form-group row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2">출산 예정일</label>
						</div>
						<div class="col-sm-9">
							<div class="tui-datepicker-input tui-datetime-input">
								<input type="text" id="input_dueDate_edit" aria-label="Date-Time">
								<span class="tui-ico-date"></span>
							</div>
							<div id="wrapper_edit" style="margin-top: -1px;"></div>
						</div>
					</div>
					<div class="form-group row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2" style="border: 0px;">전체 마사지 횟수</label>
						</div>
						<div class="col-sm-9">
							<input type="number" class="form-control" id="input_totalMssgCnt_edit" min=1>
						</div>
					</div>
					<div class="form-group row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2" style="border: 0px;">예약 마사지 횟수</label>
						</div>
						<div class="col-sm-3">
							<input type="number" class="form-control" id="input_rsvMssgCnt_edit" disabled>
						</div>
						<div class="col-sm-3">
						<label class="control-label mt-2" style="border: 0px;">잔여 마사지 횟수</label>
						</div>
						<div class="col-sm-3">
							<input type="number" class="form-control" id="input_restMssgCnt_edit" disabled>
						</div>
					</div>
					<div class="form-group row pb-0">
						<div class="col-sm-3">
							<label class="control-label mt-2" style="border: 0px;">사용 여부</label>
						</div>
						<div class="col-sm-9">
							<select name="enabled" class="form-control" id="input_enabled_edit">
								<option value="Y">사용</option>
								<option value="N">미사용</option>
							</select>
						</div>
					</div>
					<div class="form-group row pb-0">
						<div class="col-sm-3 ">
							<label class="control-label mt-2">비고</label>
						</div>
						<div class="col-sm-9">
							<textarea class="form-control" id="input_rmk_edit" style="height: 70px;resize: none;"></textarea>
						</div>
					</div> -->
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" id="btn_updateRsvInfo">저장</button>
				<button type="button" class="btn btn-info" id="btn_updateRsvInfo_close">취소</button>
			</div>
		</div>
	</div>
</div>
<!-- 예약 변경 modal -->
<div class="modal fade" id="changeRsv_modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">예약 변경</h4>
			</div>
			<div class="form-group pb-0"  style="margin: 6px;">
				<label class="control-label mt-2 mr-3">예약할 날짜 선택</label>
				<div class="tui-datepicker-input tui-datetime-input tui-has-focus" style="margin-bottom: 6px;">
					<input type="text" id="input_datepicker_modal" aria-label="date">
					<span class="tui-ico-date"></span>
				</div>
				<div class="datepicker-cell" id="div_datepicker_modal" style="margin-top: -1px;"></div>
			</div>
			<div class="modal-body">
				<div>
					<div id="grid_changeRsv_modal"></div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" id="btn_changeRsv">저장</button>
				<button type="button" class="btn btn-info" id="btn_changeRsv_close">취소</button>
			</div>
		</div>
	</div>
</div>