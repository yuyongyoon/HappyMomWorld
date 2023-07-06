<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
	<script>
		$(document).ready(function() {
			//통신 객체
			ajaxCom = {

			}; //ajaxCom END
			
			//이벤트 객체 : id값을 주면 클릭 이벤트 발생
			btnCom = {

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