<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!doctype html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>회원 정보 관리 페이지</title>   
  </head>
  <body>
  	<script>
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
				}
			
			getUserInfo : function() {
				let changed = $('#input_id_name').val();
				let phoneNumber = $('#input_phone').val();
				let startDate = $('#input_startDate').val();
				let endDate = $('#input_endDate').val();
			}
			// 수정된 입력 데이터 불러오기
			/*changedUserInfo : function() {
				let changedId = $('#input_userId_edit').val();
				let changedName = $('#input_userId_edit').val();
				let changedNumber = $('#input_userId_edit').val();
				let changedRole = $('#input_userId_edit').val();
				let changedStatus = $('#input_userId_edit').val();
				let changedRemark = $('#input_userId_edit').val();
			}//*/
			
			}; //ajaxCom END
			
			//이벤트 객체 : id값을 주면 클릭 이벤트 발생
			btnCom = {
				btn_get : function() {	//조회버튼
					ajaxCom.getUserList();
				},
				btn_add : function(){	//추가버튼
					$('#user_add_modal').modal('show');						
				},
				btn_save : function(){	//저장버튼
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
						if(colName=="id"){	// 회원id 클릭 시 modal 팝업
							$('#user_modify_modal').modal('show');
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
								<div class="modal fade" id="user_modify_modal" tabindex="-1" role="dialog" aria-hidden="true">
								   <div class="modal-dialog modal-dialog-centered" role="document">
								      <div class="modal-content">
								         <div class="modal-header">
								            <h4 class="modal-title" id="user_modify_modalTitle">사용자 정보 수정</h4>
								            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
								               <span aria-hidden="true">&times;</span>
								            </button>
								         </div>
								         <div class="modal-body">
								            <div class="col-12 pt-4">
								               <form class="form-horizontal mx-auto user-login-form-div">
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1">아이디</label>
								                     <div class="col-sm-10">
								                        <input type="text" class="form-control" id="input_userId_edit" style="border: 0px;" readonly>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">유저명</label>
								                     <div class="col-sm-10">
								                        <input type="text" class="form-control" id="input_userName_edit" maxlength='12' oninput="cfn_numberMaxLength(this)">
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">전화번호</label>
								                     <div class="col-sm-10">
								                        <input type="text" class="form-control" id="input_userPhone_edit" maxlength='12' oninput="cfn_numberMaxLength(this)">
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1">등록일</label>
								                     <div class="col-sm-10">
								                        <input type="text" class="form-control" id="input_userDate_edit" style="border: 0px;" readonly>
								                     </div>
								                  </div>
								                  
								                  
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">구분</label>
								                     <div class="col-sm-10">
								                        <select name="enabled" class="form-control" id="enabledEdit">
								                           <option value="user">회원</option>
								                           <option value="admin">관리자</option>
								                        </select>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">사용 여부</label>
								                     <div class="col-sm-10">
								                        <select name="enabled" class="form-control" id="enabledEdit">
								                           <option value="1">사용</option>
								                           <option value="0">미사용</option>
								                        </select>
								                     </div>
								                  </div>
								                  <!-- <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">잠금 여부</label>
								                     <div class="col-sm-10">
								                        <select name="locktf" class="form-control" id="locktf">
								                           <option value="1">잠금</option>
								                           <option value="0">해제</option>
								                        </select>
								                     </div>
								                  </div> -->
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
								            <!-- 
								            <button type="button" class="btn btn-danger" id="btn_resetPw">비밀번호 초기화</button>
								            <button type="button" class="btn btn-danger" id="btn_delete">삭제 <i class="fas fa-trash-alt"></i></button>
								             -->
								            <button type="button" class="btn btn-primary" id="btn_updatePwd">비밀번호 변경</button>
								            <button type="button" class="btn btn-primary" id="btn_updateAccount">저장</button>
								         </div>
								      </div>
								   </div>
								</div>
																
								<!-- 회원 정보 추가 modal -->
								<div class="modal fade" id="user_add_modal" tabindex="-1" role="dialog" aria-hidden="true">
								   <div class="modal-dialog modal-dialog-centered" role="document">
								      <div class="modal-content">
								         <div class="modal-header">
								            <h4 class="modal-title" id="user_modify_modalTitle">사용자 정보 추가</h4>
								            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
								               <span aria-hidden="true">&times;</span>
								            </button>
								         </div>
								         <div class="modal-body">
								            <div class="col-12 pt-4">
								               <form class="form-horizontal mx-auto user-login-form-div">
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1">ID</label>
								                     <div class="col-sm-7">
								                        <input type="text" class="form-control" id="input_userId_edit">
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1">ID 중복확인</label>
								                     <div class="col-sm-7">
								                        <input type="text" class="form-control" id="input_userId_edit">
								                     </div>
								                     <div>
								                     	<button type="button" class="btn btn-primary" id="btn_checkId">확인</button>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">이름</label>
								                     <div class="col-sm-10">
								                        <input type="text" class="form-control" id="input_usernm_edit" maxlength='12' oninput="cfn_numberMaxLength(this)">
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">전화번호</label>
								                     <div class="col-sm-10">
								                        <input type="text" class="form-control" id="input_usernm_edit" maxlength='12' oninput="cfn_numberMaxLength(this)">
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1">등록일</label>
								                     <div class="col-sm-10">
								                        <input type="text" class="form-control" id="input_userId_edit" style="border: 0px;" readonly>
								                     </div>
								                  </div>
								                  
								                  
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">구분</label>
								                     <div class="col-sm-10">
								                        <select name="enabled" class="form-control" id="enabledEdit">
								                           <option value="user">회원</option>
								                           <option value="admin">관리자</option>
								                        </select>
								                     </div>
								                  </div>
								                  <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">사용 여부</label>
								                     <div class="col-sm-10">
								                        <select name="enabled" class="form-control" id="enabledEdit">
								                           <option value="1">사용</option>
								                           <option value="0">미사용</option>
								                        </select>
								                     </div>
								                  </div>
								                  <!-- <div class="form-group row">
								                     <label class="col-sm-2 control-label text-right p-1" style="border: 0px;">잠금 여부</label>
								                     <div class="col-sm-10">
								                        <select name="locktf" class="form-control" id="locktf">
								                           <option value="1">잠금</option>
								                           <option value="0">해제</option>
								                        </select>
								                     </div>
								                  </div> -->
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
								            <button type="button" class="btn btn-primary" id="btn_cancelPwd">취소</button>
								            <button type="button" class="btn btn-primary" id="btn_addAccount">추가</button>
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
    
  </body>
</html>