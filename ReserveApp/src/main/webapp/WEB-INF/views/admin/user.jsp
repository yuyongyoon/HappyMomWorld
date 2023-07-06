<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
$(document).ready(function() {
	let id_check = false;
	let pwd_check = false;
	let name_check;
	
	// DatePicker 객체 생성
	const today = new Date();
	const lastMonth = new Date(today.getFullYear(), today.getMonth() - 1, 1);
	
	const picker = tui.DatePicker.createRangePicker({
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

	let startDate = cfn_tuiDateFormat(picker.getStartDate());
	let endDate = cfn_tuiDateFormat(picker.getEndDate());
	
	//통신 객체
	ajaxCom = {
		// 회원 목록 가져오기
		getUserList : function() {
			let userIdOrName = $('#input_id_name').val();
			let phoneNumber = $('#input_phone').val();
			let startDate = $('#input_startDate').val();
			let endDate = $('#input_endDate').val();
			
			$.doPost({
				url	 	: "/admin/getUserList",
				data 	: {
					userIdOrName	: userIdOrName,
					phoneNumber		: phoneNumber,
					startDate		: startDate,
					endDate			: endDate
				},
				success	: function(result) {
					userGrid.resetData(result.userList);
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		// reset(회원 정보 수정 modal)
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
		// 회원 정보 추가
		addAccount : function(param){
			$.doPost({
				url	 	: "/admin/addAccount",
				data 	: param,
				success	: function(result) {
					if(result.msg == 'success') {
						alert('등록되었습니다.');
						$('#user_add_modal').modal('hide');//창 닫기
						ajaxCom.getUserList();	// 조회
						$('#btn_get').click();
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		// 회원 정보 수정
		updateAccount : function(param){
			$.doPost({
				url	 	: "/admin/updateAccount",
				data 	: param,
				success	: function(result) {
					if(result.msg == 'success') {
						alert('등록되었습니다.');
						$('#user_edit_modal').modal('hide');//창 닫기
						ajaxCom.getUserList();	// 조회
						$('#btn_get').click();
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		// 아이디 중복 확인
		checkId : function(param) {
			$('#checkId_msg_add_div').hide();
			$.doPost({
				url	 	: "/admin/checkId",
				data 	: param,
				success	: function(result) {
					if(result.idCnt >= 1) {
						$('#checkId_msg_add').text('중복된 ID가 있습니다. 다른 ID를 입력해주세요.');
						$('#checkId_msg_add_div').show();
					} else{
						$('#input_checkId_add').attr('disabled', true);
						document.getElementById("input_userPwd_add").focus();
						id_check = true;	// 아이디 중복확인(완)
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		}
	}; //ajaxCom END
	
	//이벤트 객체 : id값을 주면 클릭 이벤트 발생
	btnCom = {
		//조회 버튼(회원 관리 페이지)
		btn_get : function() {
			ajaxCom.getUserList();
		},
		//추가 버튼(회원 관리 페이지)
		btn_add : function(){
			$('#user_add_modal').modal('show');	//사용자 정보 추가 modal open
			
			// 비번 중복 확인 이벤트
			$('#input_checkPwd_add').blur(function() {
				let pwd = $('#input_userPwd_add').val();
				let checkPwd = $('#input_checkPwd_add').val();
				
				if(pwd != checkPwd) {
					$('#input_checkPwd_add').val(''); // 비번 초기화
					$('#checkPwd_msg_add').text('동일한 비밀번호를 입력해주세요.');
					$('#checkPwd_msg_add_div').show();
				} else if(pwd == '' || checkPwd == '' ){
					$('#checkPwd_msg_add').text('비밀번호를 입력해주세요.');
					$('#checkPwd_msg_add_div').show();
				} else {
					$('#input_userPwd_add').attr('disabled', true);
					$('#input_checkPwd_add').attr('disabled', true);
					$('#checkPwd_msg_add_div').css('display','none');// 에러 메세지 지우기
					$('#input_userName_add').focus();// 다음 input로 커서 옮김
					pwd_check = true;	// 비번 중복확인(완)
				}
			})
		},
		//추가 버튼(사용자 정보 추가 modal)
		btn_addAccount : function(){
			//id 중복 확인 버튼 클릭 여부
			if($('#input_checkId_add').val() == ''){
				alert('아이디를 입력해주세요.');
				return false;
			} else if(id_check == false){
				alert('아이디 중복 확인해주세요.');
				return false;
			} else if($('#input_userPwd_add').val() == '' || $('#input_checkPwd_add').val() == ''){
				alert('비밀번호를 입력해주세요.');
				return false;
			} else if(pwd_check == false){
				alert('비밀번호를 확인해주세요.');
				return false;
			} else if($('#input_userName_add').val() == ''){
				alert('이름을 확인해주세요.');
				return false;
			}
			
			let param = {
				id			: $('#input_checkId_add').val(),		// id
				password	: $('#input_checkPwd_add').val(),		// 비밀번호
				name 		: $('#input_userName_add').val(),		// 이름
				phone_number: $('#input_phoneNumber_add').val(),	// 전화번호
				created_dt	: $('#input_startDate').val(),			// 등록일
				user_role	: $('#input_role_add').val(),			// 사용자 구분
				user_status	: $('#input_enabled_add').val(),		// 사용 여부
				remark		: $('#input_rmk_add').val()				// 비고
			}

			ajaxCom.addAccount(param);
		},
		//저장 버튼 (사용자 정보 수정 modal)
		btn_updateAccount : function(){
			let param = {
				id			: $('#input_userId_edit').val(),		// id
				name 		: $('#input_userName_edit').val(),		// 이름
				phone_number: $('#input_phoneNumber_edit').val(),	// 전화번호
				created_dt	: $('#input_startDate').val(),			// 등록일
				user_role	: $('#input_role_edit').val(),			// 사용자 구분
				user_status	: $('#input_enabled_edit').val(),		// 사용 여부
				remark		: $('#input_rmk_edit').val()			// 비고
			}

			ajaxCom.updateAccount(param);
			
		},
		// 초기화 버튼(회원 정보 수정 modal)
		btn_resetPwd : function() {
			let param = {
				user_id : $('#input_checkId_add').val()
			}
			ajaxCom.resetPwd(param);
			
		},
		// 아이디 중복 확인 버튼(회원 정보 추가 modal)
		btn_checkId : function(){
			if($('#input_checkId_add').val() == '') {
				alert('ID를 입력해주세요');
				return false;
			}
			
			let param = {
				user_id : $('#input_checkId_add').val()
			};
			
			ajaxCom.checkId(param);
		},
		//사용자 정보 추가 버튼 닫기
		btn_addAccountClose : function() {
			let modalId = $(this).closest(".modal").attr("id");
			
			if (confirm("창을 닫으면 내용이 모두 지워집니다. 닫으시겠습니까?")) {
				$('#input_checkId_add').attr('disabled', false);
				$('#input_checkId_add').val('');
				$('#input_userPwd_add').val('');
				$('#input_checkPwd_add').val('');
				$('#input_userName_add').val('');
				$('#input_phoneNumber_add').val('');
				$('#input_rmk_add').val('');
				$('#input_role_add').val('USER');
				$('#checkId_msg_add_div').css('display', 'none');
				$('#checkPwd_msg_add_div').css('display', 'none');
				$('#input_userPwd_add').attr('disabled', false);
				$('#input_checkPwd_add').attr('disabled', false);
				$('#' + modalId).modal('hide');
			}
		},
		//
		btn_updateAccountClose : function() {
			let modalId = $(this).closest(".modal").attr("id");
			
			if (confirm("창을 닫으면 수정한 내용이 모두 지워집니다. 닫으시겠습니까?")) {
				$('#' + modalId).modal('hide');
			}
		}
	}; //btnCom END
	
	//기타 함수 객체
	fnCom = {
	}; //fnCom END
	
	const userGrid = tuiGrid.createGrid(
		//그리드 옵션
		{
			gridId : 'user_grid',
			height : 580,
			scrollX : true,
			scrollY : true,
			readOnlyColorFlag : false,
			columns: [
				{header : 'ID',			name : 'id',				width : 200,  align:'left',	
					style:'cursor:pointer;text-decoration:underline;',},
				{header : '이름',			name : 'name',				width : 200,  align:'left'},
				{header : '전화번호',		name : 'phone_number',		width : 200,  align:'left'},
				{header : '등록일',		name : 'created_dt',		width : 200,  align:'center'},
				{header : '구분',			name : 'user_role',			width : 100,  align:'center', formatter: 'listItemText', disabled:true,
					editor: { type: 'select', options: { listItems: [{text:'관리자', value:'ADMIN'},{text:'회원',value:'USER'}]} }
				},
				{header : '사용여부',		name : 'user_status', width : 100,  align:'center', formatter: 'listItemText', disabled:true,
					editor: { type: 'select', options: { listItems: [{text:'사용', value:'Y'},{text:'미사용',value:'N'}]} }
				},
				{header : '비고',			name : 'remark',	align:'left'}
			]
		},
		[],//초기 데이터
		//이벤트
		{
			cellclick : function(rowKey,colName,grid){
				if(colName=="id"){	// 회원id 클릭 시 회원 수정 modal 팝업
					// 회원 수정 modal 초기 input의 data
					$('#user_edit_modal').modal('show');
					let rowData = userGrid.getRow(rowKey);
					
					$('#input_userId_edit').val(rowData.id);				//id
					$('#input_userName_edit').val(rowData.name);			//이름
					$('#input_phoneNumber_edit').val(rowData.phone_number);			//전화번호
					$('#input_createdDate_edit').val(rowData.created_dt);	//등록일
					$('#input_role_edit').val(rowData.user_role);			//구분
					$('#input_enabled_edit').val(rowData.user_status);		//사용여부
					$('#input_rmk_edit').val(rowData.remark);				//비고
				}
			}
		}
	);
	
	ajaxCom.getUserList();
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
											<span class="row-title">회원관리</span>
										</div>
										<div class="col-sm-6">
											<div class="button-list float-right">
												<button type="button" id="btn_get" class="header-btn btn btn-secondary float-left ml-2 mb-2">조회</button>
												<button type="button" id="btn_add" class="header-btn btn btn-secondary float-left ml-2 mb-2">추가</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<!-- search -->
							<div class="row search flex-grow-1">
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_id" class="search-label float-left mt-2">ID / 이름</label>
									<input type="text" id="input_id_name" class="form-control form-control-sm mt-2" size="5"/>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_phone" class="search-label float-left mt-2">전화번호</label>
									<input type="text" id="input_phone" class="form-control form-control-sm mt-2"/>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_startDate" class="search-label float-left mt-2">기간</label>
									<div class="tui-datepicker-input tui-datetime-input tui-has-focus">
										<input id="input_startDate" type="text" aria-label="Date">
										<span class="tui-ico-date"></span>
										<div id="startDate-container" style="margin-left: -1px;"></div>
									</div>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_endDate" class="search-label float-left mt-2">~</label>
									<div class="tui-datepicker-input tui-datetime-input tui-has-focus">
										<input id="input_endDate" type="text" aria-label="Date">
										<span class="tui-ico-date"></span>
										<div id="endDate-container" style="margin-left: -1px;"></div>
									</div>
								</div>
							</div>
							
							<!-- Grid -->
							<div class="col-md-12">
								<div id="user_grid"></div>
							</div>
							
							<!-- 회원 정보 수정 modal -->
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
														<label class="control-label mt-2">등록일</label>
													</div>
													<div class="col-sm-10">
														<input type="date" class="form-control" id="input_createdDate_edit" style="border: 0px;" readonly>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2" style="border: 0px;">구분</label>
													</div>
													<div class="col-sm-10">
														<select name="user_role" class="form-control" id="input_role_edit">
															<option value="USER">회원</option>
															<option value="ADMIN">관리자</option>
														</select>
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
							
							<!-- 회원 정보 추가 modal -->
							<div class="modal fade" id="user_add_modal" tabindex="-1" role="dialog" aria-hidden="true">
								<div class="modal-dialog modal-dialog-centered" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h4 class="modal-title" id="user_edit_modalTitle">사용자 정보 추가</h4>
										</div>
										<div class="modal-body">
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
														<input type="password" class="form-control" id="input_userPwd_add" maxlength='12'>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2">비밀번호 확인</label>
													</div>
													<div class="col-sm-9">
														<input type="password" class="form-control" id="input_checkPwd_add">
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
														<label class="control-label mt-2" style="border: 0px;">구분</label>
													</div>
													<div class="col-sm-9">
														<select name="enabled" class="form-control" id="input_role_add">
															<option value="USER">회원</option>
															<option value="ADMIN">관리자</option>
														</select>
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