<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
$(document).ready(function() { 
	let id_check = false;
	let pwd_check = false;
	let name_check;
	
	const today = new Date();
	const lastMonth = new Date(today.getFullYear(), today.getMonth() - 1, 1);
	
	const searchPicker = tui.DatePicker.createRangePicker({
		startpicker: {
			date: lastMonth,
			input: '#input_startDate',
			container: '#startDate-container'
		},
		endpicker: {
			date: today,
			input: '#input_endDate',
			container: '#endDate-container'
		},
		language: 'ko',
		format: 'YYYY-MM-dd'
	});

	let startDate = cfn_tuiDateFormat(searchPicker.getStartDate());
	let endDate = cfn_tuiDateFormat(searchPicker.getEndDate());
	
	let updatemodalDatepicker;
	let addmodalDatepicker;
	
	ajaxCom = {
		getUserList : function() {
			let userIdOrName = $('#input_id_name').val();
			let phoneNumber = $('#input_phone').val();
			let startDate = $('#input_startDate').val();
			let endDate = $('#input_endDate').val();
			if($('#role').val() == 'SUPERADMIN'){
				let superBranchCode = $('#select-branch');
			}
			
			
			if($('#select-branch').val() != ''){
				superBranchCode = $('#select-branch').val();
			} else {
				superBranchCode = '';
			}
			
			$.doPost({
				url	 	: "/admin/getUserList",
				data 	: {
					userIdOrName	: userIdOrName,
					phoneNumber		: phoneNumber,
					startDate		: startDate,
					endDate			: endDate,
					super_branch_code : superBranchCode
					
				},
				success	: function(result) {
					console.log(result.userList.length)
					$('#userCnt').text(result.userList.length);
					userGrid.resetData(result.userList);
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		resetPwd : function(param) {
			$.doPost({
				url	 	: "/admin/resetPassword",
				data 	: param,
				success	: function(result) {
					alert('초기화된 비밀번호는 ' + result.raw_pw + ' 입니다.');
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		updateAccount : function(param){
			$.doPost({
				url	 	: "/admin/updateAccount",
				data 	: param,
				success	: function(result) {
					if(result.msg == 'success') {
						alert('등록되었습니다.');
						$('#user_edit_modal').modal('hide');
						ajaxCom.getUserList();
						$('#btn_get').click();
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
	}; //ajaxCom END
	
	btnCom = {
		btn_get : function() {
			ajaxCom.getUserList();
		},
		btn_download : function(){
			tuiGrid.dataExport(userGrid,'해피맘월드_회원정보.xlsx');
		},
		btn_updateAccount : function(){
			let param = {
				id			: $('#input_userId_edit').val(),
				name 		: $('#input_userName_edit').val(),
				phone_number: $('#input_phoneNumber_edit').val(),
				due_date	: updatemodalDatepicker.getDate() != null ? cfn_tuiDateFormat(updatemodalDatepicker.getDate()) : '',
				user_status	: $('#input_enabled_edit').val(),
				remark		: $('#input_rmk_edit').val()
			}

			ajaxCom.updateAccount(param);
		},
		btn_resetPwd : function() {
			let param = {
				user_id : $('#input_userId_edit').val()
			}
			ajaxCom.resetPwd(param);
			
		},
		btn_updateAccountClose : function() {
			let modalId = $(this).closest(".modal").attr("id");
			
			if (confirm("창을 닫으면 수정한 내용이 모두 지워집니다. 닫으시겠습니까?")) {
				$('#' + modalId).modal('hide');
			} else {
				$('#btn_updateAccountClose').blur();
			}
		}
	};
	
	const userGrid = tuiGrid.createGrid(
		{
			gridId : 'user_grid',
			height: 500,
			scrollX : true,
			scrollY : true,
			readOnlyColorFlag : false,
			columns: [
				{header : 'ID',				name : 'id',			width : 100,  align:'left',	
					style:'cursor:pointer;text-decoration:underline;', sortable: true},
				{header : '이름',				name : 'name',				width : 150, align:'left', sortable: true},
				{header : '전화번호',			name : 'phone_number',		width : 150, align:'left', sortable: true},
				{header : '출산 예정일',		name : 'due_date',			width : 150, align:'left', sortable: true},
				{header : '마사지 예약 여부',	name : 'massage_reserve_cnt',	width : 150, align:'center', formatter: 'listItemText', disabled:true,
					editor: { type: 'select', options: { listItems: [{text:'YES', value:'Y'},{text:'NO',value:'N'}]}, sortable: true }
				},
				{header : '등록일',		name : 'created_dt',	width : 150,  align:'center', sortable: true},
				{header : '비고',			name : 'remark',	align:'left'}
			]
		},
		[],
		{
			cellclick : function(rowKey,colName,grid){
				if(colName=="id"){
					$('#user_edit_modal').modal('show');
					
					let rowData = userGrid.getRow(rowKey);
					
					$('#input_userId_edit').val(rowData.id);
					$('#input_userName_edit').val(rowData.name);
					$('#input_phoneNumber_edit').val(rowData.phone_number);
					$('#input_role_edit').val(rowData.user_role),
					$('#input_rmk_edit').val(rowData.remark);
					
					updatemodalDatepicker = new tui.DatePicker('#wrapper_edit', {
						language: 'ko',
						date: rowData.due_date != '' ? new Date(rowData.due_date) : null,
						input: {
							element: '#input_dueDate_edit',
							format: 'yyyy-MM-dd'
						},
					});
				}
			}
		}
	);

	ajaxCom.getUserList();
	//
// 	cfn_gridResize('card-body', 100)
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
											<span class="row-title">회원관리</span>
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
							
							<div class="row search flex-grow-1">
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_id" class="search-label float-left mt-2">ID / 이름</label>
									<input type="text" id="input_id_name" class="form-control form-control-sm mt-2"/>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_phone" class="search-label float-left mt-2">전화번호</label>
									<input type="text" id="input_phone" class="form-control form-control-sm mt-2"/>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_startDate" class="search-label float-left mt-2">기간</label>
									<div class="tui-datepicker-input tui-datetime-input">
										<input id="input_startDate" type="text" aria-label="Date">
										<span class="tui-ico-date"></span>
										<div id="startDate-container" style="margin-left: -1px;"></div>
									</div>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_endDate" class="search-label float-left mt-2">~</label>
									<div class="tui-datepicker-input tui-datetime-input">
										<input id="input_endDate" type="text" aria-label="Date">
										<span class="tui-ico-date"></span>
										<div id="endDate-container" style="margin-left: -1px;"></div>
									</div>
								</div>
							</div>
							
							<div class="sub-titlebar">
								<div class="float-right mt-1 mb-1 mr-2">
									조회 건수: <span id="userCnt"></span>건
								</div>
							</div>
							
							<div class="col-md-12">
								<div id="user_grid"></div>
							</div>
							
							<div class="modal fade" id="user_edit_modal" tabindex="-1" role="dialog" aria-hidden="true">
								<div class="modal-dialog modal-dialog-centered" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h4 class="modal-title" id="user_edit_modalTitle">회원 정보 수정</h4>
										</div>
										<div class="modal-body">
											<div class="col-12">
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2">ID</label>
													</div>
													<div class="col-sm-10">
														<input type="text" class="form-control" id="input_userId_edit" style="border: 0px;" readonly>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2" style="border: 0px;">이름</label>
													</div>
													<div class="col-sm-10">
														<input type="text" class="form-control" id="input_userName_edit" maxlength='12'>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2" style="border: 0px;">전화번호</label>
													</div>
													<div class="col-sm-10">
														<input type="tel" class="form-control" id="input_phoneNumber_edit">
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2">출산 예정일</label>
													</div>
													<div class="col-sm-10">
														<div class="tui-datepicker-input tui-datetime-input">
															<input type="text" id="input_dueDate_edit" aria-label="Date-Time">
															<span class="tui-ico-date"></span>
														</div>
														<div id="wrapper_edit" style="margin-top: -1px;"></div>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2" style="border: 0px;">사용 여부</label>
													</div>
													<div class="col-sm-10">
														<select name="enabled" class="form-control" id="input_enabled_edit">
															<option value="Y">사용</option>
															<option value="N">미사용</option>
														</select>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2 ">
														<label class="control-label mt-2">비고</label>
													</div>
													<div class="col-sm-10">
														<textarea class="form-control" id="input_rmk_edit" style="height: 70px;resize: none;"></textarea>
													</div>
												</div>
											</div>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-danger" id="btn_resetPwd">초기화</button>
											<button type="button" class="btn btn-secondary" id="btn_updateAccount">저장</button>
											<button type="button" class="btn btn-info" id="btn_updateAccountClose">취소</button>
										</div>
									</div>
								</div>
							</div>
							
							<div class="modal fade" id="user_add_modal" tabindex="-1" role="dialog" aria-hidden="true">
								<div class="modal-dialog modal-dialog-centered" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h4 class="modal-title" id="user_edit_modalTitle">회원 정보 추가</h4>
										</div>
										<div class="modal-body">
											<form>
											<div class="col-12">
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label for="input_checkId_add" class="control-label mt-2">ID</label>
													</div>
													<div class="col-sm-7">
														<input type="text" class="form-control" id="input_checkId_add">
													</div>
													<div class="col-sm-2 d-flex align-items-center">
														<button type="button" class="btn btn-secondary btn-sm" id="btn_checkId">중복 확인</button>
													</div>
												</div>
												<div class="col-sm-12 pb-0 mt-2" id="checkId_msg_add_div">
													<span id="checkId_msg_add" style="color:red;display:flex;justify-content:center;"></span>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2" style="border: 0px;">비밀번호</label>
													</div>
													<div class="col-sm-9">
														<input type="password" class="form-control" id="input_userPwd_add" autoComplete="off" maxlength='12'>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2">비밀번호 확인</label>
													</div>
													<div class="col-sm-9">
														<input type="password" class="form-control" autoComplete="off" id="input_checkPwd_add">
													</div>
												</div>
												<div class="col-sm-12 pb-0 mt-2" id="checkPwd_msg_add_div">
													<span id="checkPwd_msg_add" style="color: red;display: flex;justify-content: center;"></span>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2" style="border: 0px;">이름</label>
													</div>
													<div class="col-sm-9">
														<input type="text" class="form-control" id="input_userName_add" maxlength='12'>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2" style="border: 0px;">전화번호</label>
													</div>
													<div class="col-sm-9">
														<input type="tel" class="form-control" id="input_phoneNumber_add" maxlength='13'>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2">출산 예정일</label>
													</div>
													<div class="col-sm-9">
														<div class="tui-datepicker-input tui-datetime-input">
															<input type="text" id="input_dueDate_add" aria-label="Date-Time">
															<span class="tui-ico-date"></span>
														</div>
														<div id="wrapper_add" style="margin-top: -1px;"></div>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2">비고</label>
													</div>
													<div class="col-sm-9">
														<textarea class="form-control" id="input_rmk_add" style="height: 70px;resize: none;"></textarea>
													</div>
												</div>
											</div>
											</form>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-secondary" id="btn_addAccount">추가</button>
											<button type="button" class="btn btn-info" id="btn_addAccountClose">취소</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>