<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
	<script>
	// <<추가할 기능>>
	// 회원 정보 수정에 값 뿌리는기
	// 비밀번호 input type password로 변경
	// 전화번호 입력칸 010-1111-1111 입력값 안들어감
	// 중복확인 기능 추가, 중복된 아이디가 없다면 아이디입력칸 disable로 변경
	// 비밀번호 동일 확인 기능 추가
	// db에 사용자 정보 추가가 끝나면 input값 disable 값 모두 입력 가능한 창으로 reset하기
	// date picker 적용 후 초기 값 적용
	let idCheck = false;
	
		$(document).ready(function() {
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
							console.log(result)
							userGrid.resetData(result.userList);
						},
						error	: function(xhr,status){
							alert("오류가 발생했습니다.");
						}
					});
				},
				// reset버튼(회원 정보 수정 modal)
				resetPwd : function(param) {
					$.doPost({
						url	 	: "/admin/resetPassword",
						data 	: param,
						success	: function(result) {
							console.log(result)
							alert('초기화된 비밀번호는 ' + result.raw_pw + ' 입니다.');
						},
						error	: function(xhr,status){
							alert("오류가 발생했습니다.");
						}
					});
				},
				// 추가 버튼(회원 정보 추가 modal)
				addAccount : function(param) {
					$.doPost({
						url	 	: "/admin/addAccount",
						data 	: param,
						success	: function(result) {
							console.log(result.msg)
							if(result.msg == 'success') {
								alert('등록되었습니다.');
								//input 박스 비우는 작업 추가
								//조회창에서 조회버튼 클릭 이벤트 추가하여 그리드가 업데이트되도록 변경
							}

						},
						error	: function(xhr,status){
							alert("오류가 발생했습니다.");
						}
					});
				},
				// 저장 버튼(회원 정보 수정 modal)
				//// ~작업중~
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
							alert("오류가 발생했습니다.");
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
								$('#user_edit_modal').modal('hide');//창 닫기
								ajaxCom.getUserList();	// 조회
								$('#btn_get').click();
							}
							
						},
						error	: function(xhr,status){
							alert("오류가 발생했습니다.");
						}
					});
				},
			}; //ajaxCom END
			
			//이벤트 객체 : id값을 주면 클릭 이벤트 발생
			btnCom = {
				//조회 버튼 > 해당 데이터 출력
				btn_get : function() {
					ajaxCom.getUserList();
				},
				//추가 버튼 > 회원 정보 추가 modal 팝업
				btn_add : function(){
					$('#user_add_modal').modal('show');						
				},
				//회원 정보 추가 버튼: 추가된 정보 DB에 저장
				btn_addAccount : function(){
					let param = {
						addcheckId		: $('#input_checkId_add').val(),		// id 중복확인
						addPwd			: $('#input_userPwd_add').val(),		// pw
						addCheckPwd		: $('#input_checkPwd_add').val(),		// id 중복확인
						addUserName 	: $('#input_userName_add').val(),		// 이름
						addPhoneNumber	: $('#input_phoneNumber_add').val(),		// 전화번호
						addRole			: $('#input_role_add').val(),			// 사용자 구분
						addEnabled		: $('#input_enabled_add').val(),		// 사용 여부
						addRemark		: $('#input_rmk_add').val()			// 비고
					}
					//test
					console.log('추가된 회원 정보 확인 >', param)
				},
				//회원 정보 수정 버튼 > 수정된 정보 DB에 저장
				//// ~작업중~
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
					//test
					console.log('수정된 회원 정보 확인 >', param)
					ajaxCom.updateAccount(param);
					
				},
				// reset버튼(회원 정보 수정 modal)
				btn_resetPwd : function() {
					let param = {
						user_id : $('#input_checkId_add').val()
					}
					ajaxCom.resetPwd(param);
					
				},
				// 추가버튼(회원 정보 추가 modal)
				btn_addAccount : function() {
					//키값은 db 컬럼 이름으로 
					let param = {
						id : $('#input_checkId_add').val(), 
						password : $('#input_userPwd_add').val(),
						name : $('#input_userName_add').val(),
						phone_number : $('#input_phoneNumber_add').val(),
						user_role : $('#input_role_add').val(), //html value 회원 USER, 관리자 ADMIN
						user_status : 'Y',
						remark : $('#input_rmk_add').val()
					}
					console.log(param);
					
					ajaxCom.addAccount(param);
				},
				btn_checkId : function() {
					let param = {
							//id 
					}
				}
			}; //btnCom END
			
			// 중복 확인 함수 객체
			/* checkCom = {
				btn_checkId : function(){
					$('.input_checkId_add').changed(function(){
						$('#sucess').hide();
						$('btn_checId').show();
						$('.input_checkId_add').attr("result", "fail");
					})
					
					if($('.input_checkId_add').val() == '') {
						alter('이메일을 입력해주세요');
						return;
					}
				}
			} */
			
			//기타 함수 객체
			fnCom = {
				btn_checkId : function(){
					$('.input_checkId_add').changed(function(){
						$('#sucess').hide();
						$('btn_checId').show();
						$('.input_checkId_add').attr("result", "fail");
					})
					
					if($('.input_checkId_add').val() == '') {
						alter('이메일을 입력해주세요');
						return;
					}
				}
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
			
			//여기에 비밀번호 확인 입력

			
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
								
								<!-- table -->
								<div class="row search">
									<div class="col-sm-3">
										<label for="input_id" class="search-label float-left mt-2">ID / 이름</label>
										<input type="text" id="input_id_name" class="form-control form-control-sm mt-2" size="5"/>
									</div>
									<div class="col-sm-3">
										<label for="input_phone" class="search-label float-left mt-2">전화번호</label>
										<input type="text" id="input_phone" class="form-control form-control-sm mt-2"/>
									</div>
									<div class="col-sm-3">
										<label for="input_startDate" class="search-label float-left mt-2">기간</label>
										<input type="date" id="input_startDate"  class="form-control form-control-sm mt-2" />
									</div>
									<div class="col-sm-3">
										<label for="input_endDate" class="search-label float-left mt-2">~</label>
										<input type="date" id="input_endDate" class="form-control form-control-sm mt-2" />
									</div>
								</div>
								
								<!-- Grid -->
								<div id="user_grid"></div>
								
								
								<!-- 회원 정보 수정 modal -->
								<div class="modal fade" id="user_edit_modal" tabindex="-1" role="dialog" aria-hidden="true">
								   <div class="modal-dialog modal-dialog-centered" role="document">
								      <div class="modal-content">
								         <div class="modal-header">
								            <h4 class="modal-title" id="user_edit_modalTitle">회원 정보 수정</h4>
								            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
								               <span aria-hidden="true">&times;</span>
								            </button>
								         </div>
								         <div class="modal-body">
								            <div class="col-12 pt-4">
								               <form class="form-horizontal mx-auto user-login-form-div">
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1">ID</label>
								                     <div class="col-sm-10">
								                        <input type="text" class="form-control" id="input_userId_edit" style="border: 0px;" readonly>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">이름</label>
								                     <div class="col-sm-10">
								                        <input type="text" class="form-control" id="input_userName_edit" maxlength='12'>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">전화번호</label>
								                     <div class="col-sm-10">
								                        <input type="tel" class="form-control" id="input_phoneNumber_edit">
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1">등록일</label>
								                     <div class="col-sm-10">
								                        <input type="date" class="form-control" id="input_createdDate_edit" style="border: 0px;" readonly>
								                     </div>
								                  </div>
								                  
								                  
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">구분</label>
								                     <div class="col-sm-10">
								                        <select name="user_role" class="form-control" id="input_role_edit">
								                           <option value="USER">회원</option>
								                           <option value="ADMIN">관리자</option>
								                        </select>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">사용 여부</label>
								                     <div class="col-sm-10">
								                        <select name="enabled" class="form-control" id="input_enabled_edit">
								                           <option value="Y">사용</option>
								                           <option value="N">미사용</option>
								                        </select>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1">비고</label>
								                     <div class="col-sm-10">
								                        <textarea class="form-control" id="input_rmk_edit" style="height: 120px;resize: none;"></textarea>
								                     </div>
								                  </div>
								               </form>
								            </div>
								         </div>
								         <div class="modal-footer">
								            <button type="button" class="btn btn-secondary" id="btn_resetPwd">초기화</button>
								            <button type="button" class="btn btn-secondary" id="btn_updateAccount">저장</button>
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
								            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
								               <span aria-hidden="true">&times;</span>
								            </button>
								         </div>
								         <div class="modal-body">
								            <div class="col-12 pt-4">
								               <form class="form-horizontal mx-auto user-login-form-div">
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1">아이디<br>중복확인</label>
								                     <div class="col-sm-7">
								                        <input type="text" class="form-control" id="input_checkId_add">
								                     </div>
								                     <div>
								                     	<button type="button" class="btn btn-secondary" id="btn_checkId">확인</button>
								                     </div>
								                  </div>
								                     	<span  class="col-sm-7" style="color: red;">입력하신 아이디가 일치하지 않습니다. 다시 입력해주십시오.</span>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">비밀번호</label>
								                     <div class="col-sm-7">
								                        <input type="text" class="form-control" id="input_userPwd_add" maxlength='12'>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1">비밀번호<br>중복확인</label>
								                     <div class="col-sm-7">
								                        <input type="text" class="form-control" id="input_checkPwd_add">
								                     </div>
								                     <div>
								                     	<button type="button" class="btn btn-secondary" id="btn_checkPwd">확인</button>
								                     </div>
								                   </div>
								                     <span style="color: red;">입력하신 비밀번호가 일치하지 않습니다. 다시 입력해주십시오.</span>

								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">이름</label>
								                     <div class="col-sm-10">
								                        <input type="text" class="form-control" id="input_userName_add" maxlength='12'>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">전화번호</label>
								                     <div class="col-sm-10">
								                        <input type="text" class="form-control" id="input_phoneNumber_add" maxlength='13'>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">구분</label>
								                     <div class="col-sm-10">
								                        <select name="enabled" class="form-control" id="input_role_add">
								                           <option value="USER">회원</option>
								                           <option value="ADMIN">관리자</option>
								                        </select>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">사용 여부</label>
								                     <div class="col-sm-10">
								                        <select name="enabled" class="form-control" id="input_enabled_add">
								                           <option value="Y">사용</option>
								                           <option value="N">미사용</option>
								                        </select>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1">비고</label>
								                     <div class="col-sm-10">
								                        <textarea class="form-control" id="input_rmk_add" style="height: 120px;resize: none;"></textarea>
								                     </div>
								                  </div>
								               </form>
								            </div>
								         </div>
								         <div class="modal-footer">
								            <button type="button" class="btn btn-secondary" id="btn_addAccount">추가</button>
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