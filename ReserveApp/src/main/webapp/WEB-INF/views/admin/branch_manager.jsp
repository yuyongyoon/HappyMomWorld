<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
let checkUnload = true;

$(document).ready(function() {
	let id_check = false;
	let pwd_check = false;
	//통신 객체
	ajaxCom = {
		getBranchList: function(){
			$.doPost({
				url		: "/admin/getBranchList",
				data	: {
					branchName	: $('#input_branchName').val(),
					adminId		: $('#input_mngId').val(),
					joinCode	: $('#input_joinCode').val(),
					userStatus	: $('#select_userStatus').val()
				},
				success	: function(result){
					let branchNum = result.branchList.length;
					$('#branchCnt').text(branchNum);
					
					if(result.branchList.legnth != 0) {
						branchGrid.resetData(result.branchList);
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		/* //
		saveBranchData: function(param){
			$.doPost({
				url		: "/admin/saveBranchInfo",
				data	: {data : param},
				success	: function(result){
					if(result.msg == 'success') {
						alert('저장 되었습니다.');
						ajaxCom.getBranchList();
					} else {
						alert(result.msg);
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		}, */
		// 중복 확인
		checkId: function(param) {
			$.doPost({
				url	 	: "/admin/checkId",
				data 	: param,
				success	: function(result) {
					if(result.msg == "fail") {
						$('#span_checkId_msg').text('입력하신 아이디는 이미 사용중입니다.');
						$('#div_checkId_msg').show();
					} else if(result.msg == "success"){
						$('#span_checkId_msg').text('사용 가능한 아이디 입니다.');
						$('#span_checkId_msg').css('color',"blue");
						$('#div_checkId_msg').show();
						$('#input_branchId_add').attr('disabled', true);
						id_check = true;
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		// 지점 추가
		addBranchInfo : function(param){
			$.doPost({
				url	 	: "/admin/addBranchInfo",
				data 	: param,
				success	: function(result) {
					if(result.msg == "fail") {
						alert('지점 추가를 실패했습니다.');
					} else if(result.msg == "success"){
						alert('지점이 추가되었습니다.');
						
						$('#input_branchName_add').val('');
						$('#input_branchId_add').val('');
						$('#input_branchTel_add').val('');
						$('#input_curPwd_add').val('');
						$('#input_newPwd_add').val('');
						$('#input_stdDueDate_add').val('');
						$('#addBranch_modal').modal('hide');
						ajaxCom.getBranchList();
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		// 지점 정보 수정
		updateBranchInfo : function(param){
			$.doPost({
				url	 	: "/admin/updateBranchInfo",
				data 	: param,
				success	: function(result) {
					if(result.msg == "fail") {
						alert('지점 수정을 실패했습니다.');
					} else if(result.msg == "success"){
						alert('정보를 수정했습니다.');
						
						$('#editBranch_modal').modal('hide');
						ajaxCom.getBranchList();
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		resetMngPwd : function(param) {
			$.doPost({
				url	 	: "/admin/resetMngPwd",
				data 	: param,
				success	: function(result) {
					alert('초기화된 비밀번호는 ' + result.raw_pw + ' 입니다.');
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		// 관지라 정보 수정
		updateManager : function(param){
			$.doPost({
				url	 	: "/admin/updateManager",
				data 	: param,
				success	: function(result) {
					if(result.msg == "fail") {
						alert('수정 실패했습니다.');
					} else if(result.msg == "success"){
						alert('수정 성공했습니다.');
						$('#editManager_modal').modal('hide');
						ajaxCom.getBranchList();
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		}
	}; //ajaxCom END
	
	btnCom = {
		// 지점 조회 버튼
		btn_get: function(){
			ajaxCom.getBranchList();
		},
		// 지점 추가 버튼
		btn_add: function(){
			$('#input_branchId_add').attr('disabled', false);
			$('#input_curPwd_add').attr('disabled', false);
			$('#input_newPwd_add').attr('disabled', false);
			
			$('#input_branchName_add').val('');
			$('#input_branchId_add').val('');
			$('#input_branchTel_add').val('');
			$('#input_curPwd_add').val('');
			$('#input_newPwd_add').val('');
			$('#input_stdDueDate_add').val('');
			
			$('#div_checkId_msg').hide();
			$('#div_curPwd_msg').hide();
			$('#div_newPwd_msg').hide();
			$('#addBranch_modal').modal('show');
		},
		btn_download: function() {
			tuiGrid.dataExport(branchGrid,'지점관리.xlsx');
		},
		// 관리자 아이디 중복 학인 - 추가 modal
		btn_checkId_add : function(){
			let id = $('#input_branchId_add').val();
			
			
			if(id == '' || id == null) {
				$('#span_checkId_msg').text('');
				alert('ID를 입력해주세요');
				return false;
			}
			
			let idPattern = /^[A-Za-z0-9]{4,}$/;
			if(!idPattern.test(id)){
				$('#span_checkId_msg').text('영어 또는 숫자로 구성된 4자리 이상의 단어여야 합니다.');
				$('#div_checkId_msg').show();
				return false;
			} else {
				let param = {	id : $('#input_branchId_add').val()	};
				ajaxCom.checkId(param);
			}
		},
		//저장 버튼 - 추가 modal
		btn_addBranch : function(){
			let checkFlag = false;
			
			let telPattern = /([0-9]{1}[0-9]{1})-(\d{3,4})-(\d{4})/;
			
			if($('#input_branchName_add').val() == ''){
				alert('이름을 입력해주세요.');
				$('#name_signup').focus();
				return false;
			} else if(!id_check) {
				alert('아이디 중복 확인을 해주세요.');
				return false;
			} else if($('#input_branchTel_add').val() == ''){
				alert('전화번호를 입력해주세요.');
				$('#input_branchTel_add').focus();
				return false;
			} else if(!telPattern.test($('#input_branchTel_add').val().trim())){
				alert('전화번호를 올바르게 입력해주세요.\n(예시:010-1234-5678 또는 02-1234-5678)');
				$('#input_branchTel_add').val('');
				$('#input_branchTel_add').focus();
				return false;
			} else if(!pwd_check) {
				alert('비밀번호를 확인해주세요.');
				return false;
			} else {
				checkFlag = true;
			}
			
			if(checkFlag){
				console.log($('#input_stdDueDate_add').val() == '')
				let param = {
						branch_name	: $('#input_branchName_add').val(),
						id			: $('#input_branchId_add').val(),
						branch_tel	: $('#input_branchTel_add').val(),
						password	: $('#input_newPwd_add').val(),
						std_due_date: $('#input_stdDueDate_add').val() == '' ? Number(30) : Number($('#input_stdDueDate_add').val())
						
				}
				console.log(param)
				//console.log('지점 추가 >>',param);
				ajaxCom.addBranchInfo(param);
			}
			
		},
		// modal 닫기 버튼 - 추가 modal
		btn_addBranch_close : function(){
			let modalId = $(this).closest(".modal").attr("id");
			
			if (confirm("창을 닫으면 수정한 내용이 모두 지워집니다. 닫으시겠습니까?")) {
				
				$('#' + modalId).modal('hide');
			} else {
				$('#btn_addBranch_close').blur();
			}
		},
		//저장 버튼 - 수정 modal
		btn_editBranch: function() {
			let checkFlag = false;
			let telPattern = /([0-9]{1}[0-9]{1})-(\d{3,4})-(\d{4})/;
			
			if(!telPattern.test($('#input_branchTel_edit').val().trim())){
				alert('전화번호를 올바르게 입력해주세요.\n(예시:010-1234-5678 또는 02-1234-5678)');
				$('#input_branchTel_edit').val('');
				$('#input_branchTel_edit').focus();
				return false;
			}
			
			let param = {
					branch_name		: $('#input_branchName_edit').val(),
					branch_tel		: $('#input_branchTel_edit').val(),
					branch_addr		: $('#input_branchAddr_edit').val(),
					business_hours	: $('#input_branchTime_edit').val(),
					join_code		: $('#input_joinCode_edit').val(),
					std_due_date	: Number($('#input_stdDueDate_edit').val())
			}
			ajaxCom.updateBranchInfo(param);
			console.log('지점 수정 >>',param);
		},
		// modal 닫기 버튼 - 수정 modal
		btn_editBranch_close : function(){
			let modalId = $(this).closest(".modal").attr("id");
			
			if (confirm("창을 닫으면 수정한 내용이 모두 지워집니다. 닫으시겠습니까?")) {
				$('#' + modalId).modal('hide');
			} else {
				$('#btn_editBranch_close').blur();
			}
		},
		btn_resetPwd : function() {
			let param = {
				manager_id : $('#input_mngId_edit').val()
			}
			ajaxCom.resetMngPwd(param);
			console.log('비밀번호 초기화 >>',param);
			
		},
		btn_updateMng: function(){
			let param = {
					id			: $('#input_mngId_edit').val(),
					branch_name	: $('#input_mngName_edit').val(),
					user_status	: $('#input_mngEnabled_edit').val(),
					join_code	: $('#input_joinCode_edit').val()
			}
			ajaxCom.updateManager(param);
			console.log('관리자 수정 >>',param);
		},
		btn_updateMng_close: function(){
			let modalId = $(this).closest(".modal").attr("id");
			
			if (confirm("창을 닫으면 수정한 내용이 모두 지워집니다. 닫으시겠습니까?")) {
				$('#' + modalId).modal('hide');
			} else {
				$('#btn_editBranch_close').blur();
			}
		}
	}; //btnCom END

	//기타 함수 객체
	fnCom = {
		selectFun: function(id){
			console.log("id :", id[id.selectedIndex])
		}
	
	}; //fnCom END
	
	const branchGrid = tuiGrid.createGrid(
		//그리드 옵션
		{
			gridId : 'branch_grid',
			height : 580,
			scrollX : true,
			scrollY : true,
			readOnlyColorFlag : false,
			columns: [
				{header : '지점이름',		name : 'branch_name',		align:'left', style:'cursor:pointer;text-decoration:underline;', sortable: true},
				{header : '관리자 아이디',	name : 'id', 				align:'left', style:'cursor:pointer;text-decoration:underline;', sortable: true},
				{header : '전화번호',		name : 'branch_tel', 		align:'left'},
				{header : '가입코드',		name : 'join_code',			align:'left' },
				{header : '등록일',		name : 'created_dt',			align:'left' }
			]
		},
		[],//초기 데이터
		//이벤트
		{
			cellclick : function(rowKey,colName,grid){
				if(colName=="branch_name"){
					let rowData = branchGrid.getRow(rowKey);
					
					$('#input_branchName_edit').val(rowData.branch_name);
					$('#input_branchTel_edit').val(rowData.branch_tel);
					$('#input_branchAddr_edit').val(rowData.branch_addr);
					$('#input_branchTime_edit').val(rowData.business_hours);
					$('#input_joinCode_edit').val(rowData.join_code);
					$('#input_stdDueDate_edit').val(rowData.std_due_date);
					
					$('#editBranch_modal').modal('show');
				}
				if(colName=="id"){
					let rowData = branchGrid.getRow(rowKey);
					$('#input_joinCode_edit').val(rowData.join_code);
					$('#input_mngId_edit').val(rowData.id);
					$('#input_mngName_edit').val(rowData.branch_name);
					$('#input_mngEnabled_edit').val();
					
					$('#editManager_modal').modal('show');
				}
			}
		}
	);
	// 지점 조회(메인)
	ajaxCom.getBranchList();
	
	// 사용 여부 변경 시
	$('#select_userStatus').change(function(event) {
		if(this.value == "Y"){	
			ajaxCom.getBranchList();
		} else{
			ajaxCom.getBranchList();
		}
	});
	
	
	// 비밀 번호 학인
	let pwdPattern = /^.{8,}$/;

	$('#input_curPwd_add').blur(function(){
		let pwd = $('#input_curPwd_add').val().trim();
		if(!pwdPattern.test(pwd)){
			$('#span_curPwd_msg').text('비밀번호는 공백을 제외하고 8자 이상입니다.');
			$('#div_curPwd_msg').show();
		} else {
			$('#div_curPwd_msg').css('display','none');
		}
	})
	
	$('#input_newPwd_add').blur(function(){
		let pwd = $('#input_curPwd_add').val().trim();
		let checkPwd = $('#input_newPwd_add').val().trim();
		if(checkPwd == '') {
			$('#span_newPwd_msg').text('비밀번호를 입력해주세요.');
			$('#div_newPwd_msg').show();
			return false;
		}
		
		if(pwd != checkPwd){
			$('#span_newPwd_msg').text('동일한 비밀번호를 입력해주세요.');
			$('#div_newPwd_msg').show();
			return false;
		} else if(pwd == checkPwd && pwdPattern.test(checkPwd) && pwdPattern.test(pwd)) {
			$('#input_curPwd_add').attr('disabled', true);
			$('#input_newPwd_add').attr('disabled', true);
			$('#div_newPwd_msg').css('display', 'none');
			pwd_check = true;
		}
	})
}); //END $(document).ready

</script>
<div class="main-panel">
	<div class="content">
		<div class="page-inner">
			<div class="row">
				<div class="col-md-12">
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-md-12">
									<div class="row">
										<div class="col-sm-6">
											<span class="row-title">지점 관리</span>
										</div>
										<div class="col-sm-6">
											<div class="button-list float-right">
												<button type="button" id="btn_get" class="header-btn btn btn-secondary float-left ml-2 mb-2">조회</button>
												<button type="button" id="btn_add" class="header-btn btn btn-secondary float-left ml-2 mb-2">지점 추가</button>
												<button type="button" id="btn_download" class="header-btn btn btn-secondary float-left ml-2 mb-2">다운로드</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<!-- 상단바 -->
							<div class="row search flex-grow-1">
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_branchName" class="search-label float-left mt-2">지점 이름</label>
									<input type="text" id="input_branchName" class="form-control form-control-sm mt-2"/>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_mngId" class="search-label float-left mt-2">관리자 Id</label>
									<input type="text" id="input_mngId" class="form-control form-control-sm mt-2"/>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_joinCode" class="search-label float-left mt-2">가입 코드</label>
									<input type="text" id="input_joinCode" class="form-control form-control-sm mt-2"/>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="select_userStatus" class="search-label float-left mt-2">사용 여부</label>
									<select id="select_userStatus" class="form-control mt-2" style="padding: 3px;">
										<option value="Y">사용</option>
										<option value="N">미사용</option>
									</select>
								</div>
							</div>
							
							<div class="sub-titlebar">
								<div class="float-right mt-1 mb-1 mr-2">
									조회 건수: <span id="branchCnt"></span>건
								</div>
							</div>
							
							<!-- 지점 그리드 -->
							<div id="branch_grid"></div>
							
							<!-- 지점 추가 modal -->
							<div class="modal fade" id="addBranch_modal" tabindex="-1" role="dialog" aria-hidden="true">
								<div class="modal-dialog modal-dialog-centered" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h4 class="modal-title" id="branch_add_modalTitle">지점 추가</h4>
										</div>
										<div class="modal-body">
											<div class="col-12">
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2" style="border: 0px;">지점 이름</label>
													</div>
													<div class="col-sm-9">
														<input type="text" class="form-control" id="input_branchName_add" maxlength='12'>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2">관리자 ID</label>
													</div>
													<div class="col-sm-6" style="margin-top: 6px;padding-right: 0px;">
														<input type="text" class="form-control" id="input_branchId_add">
													</div>
													<div class="col-sm-3 form-group form-floating-label d-flex align-items-center justify-content-center">
														<button id="btn_checkId_add" type="button" class="btn btn-secondary btn-sm">중복 확인</button>
													</div>
												</div>
												<div class="row form-sub m-0" id="div_checkId_msg" style="padding:0px;">
													<span class="float-left" id="span_checkId_msg" style="color:red;margin-left:120px;">아이디 경고 메세지</span>
												</div>
												<div class="form-group row pb-0" style="padding-top: 5px;">
													<div class="col-sm-3">
														<label class="control-label mt-2" style="border: 0px;">전화번호</label>
													</div>
													<div class="col-sm-9">
														<input type="tel" class="form-control" id="input_branchTel_add">
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2">비밀번호</label>
													</div>
													<div class="col-sm-9">
														<input type="password" class="form-control" id="input_curPwd_add"  maxlength='12'>
													</div>
												</div>
												<div class="row form-sub m-0" id="div_curPwd_msg" style="padding:0px;">
													<span class="float-left" id="span_curPwd_msg" style="color:red; margin-left:10px; margin-bottom: 5px;"></span>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2">비밀번호 재입력</label>
													</div>
													<div class="col-sm-9">
														<input type="password" class="form-control" id="input_newPwd_add"  maxlength='12'>
													</div>
												</div>
												<div class="row form-sub m-0" id="div_newPwd_msg" style="padding:0px;">
													<span class="float-left" id="span_newPwd_msg" style="color:red; margin-left:10px; margin-bottom: 5px;"></span>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2" style="border: 0px;">기준 임신 주수
														<i class="fas fa-question-circle" data-toggle="popover" data-placement="bottom" data-content="마사지 예약 안내를 위한 기준이 되는 임신 주수를 입력해주세요." style="cursor:pointer;"></i>
														</label>
													</div>
													<div class="col-sm-9">
														<input type="number" class="form-control" id="input_stdDueDate_add" min=28>
													</div>
												</div>
											</div>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-secondary" id="btn_addBranch">저장</button>
											<button type="button" class="btn btn-info" id="btn_addBranch_close">취소</button>
										</div>
									</div>
								</div>
							</div>
							<!-- 지점 정보 수정 modal -->
							<div class="modal fade" id="editBranch_modal" tabindex="-1" role="dialog" aria-hidden="true">
								<div class="modal-dialog modal-dialog-centered" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h4 class="modal-title">지점 정보 수정</h4>
										</div>
										<div class="modal-body">
											<div class="col-12">
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2">지점 이름</label>
													</div>
													<div class="col-sm-9">
														<input type="text" class="form-control" id="input_branchName_edit">
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2" style="border: 0px;">전화번호</label>
													</div>
													<div class="col-sm-9">
														<input type="text" class="form-control" id="input_branchTel_edit">
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2" style="border: 0px;">주소</label>
													</div>
													<div class="col-sm-9">
														<input type="text" class="form-control" id="input_branchAddr_edit">
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2">운영 시간</label>
													</div>
													<div class="col-sm-9">
														<input type="text" class="form-control" id="input_branchTime_edit">
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2">기준 임신 주수
														<i class="fas fa-question-circle" data-toggle="popover" data-placement="bottom" data-content="마사지 예약 안내를 위한 기준이 되는 임신 주수를 입력해주세요." style="cursor:pointer;"></i>
														</label>
													</div>
													<div class="col-sm-9">
														<input type="number" class="form-control" id="input_stdDueDate_edit" min=28>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-3">
														<label class="control-label mt-2">가입코드</label>
													</div>
													<div class="col-sm-9">
														<input type="text" class="form-control" id="input_joinCode_edit" disabled>
													</div>
												</div>
											</div>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-secondary" id="btn_editBranch">저장</button>
											<button type="button" class="btn btn-info" id="btn_editBranch_close">취소</button>
										</div>
									</div>
								</div>
							</div>
							<!-- 관리자 정보 수정 modal -->
							<div class="modal fade" id="editManager_modal" tabindex="-1" role="dialog" aria-hidden="true">
								<div class="modal-dialog modal-dialog-centered" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h4 class="modal-title" id="mng_edit_modalTitle">관리자 정보 수정</h4>
										</div>
										<div class="modal-body">
											<div class="col-12">
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2">ID</label>
													</div>
													<div class="col-sm-10">
														<input type="text" class="form-control" id="input_mngId_edit" disabled>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2" style="border: 0px;">이름</label>
													</div>
													<div class="col-sm-10">
														<input type="text" class="form-control" id="input_mngName_edit">
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2" style="border: 0px;">사용 여부</label>
													</div>
													<div class="col-sm-10">
														<select name="enabled" class="form-control" id="input_mngEnabled_edit">
															<option value="Y">사용</option>
															<option value="N">미사용</option>
														</select>
													</div>
												</div>
											</div>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-danger" id="btn_resetPwd">비밀번호 초기화</button>
											<button type="button" class="btn btn-secondary" id="btn_updateMng">저장</button>
											<button type="button" class="btn btn-info" id="btn_updateMng_close">취소</button>
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