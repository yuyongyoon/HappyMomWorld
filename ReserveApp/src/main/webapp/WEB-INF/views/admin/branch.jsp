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
												<span class="row-title">지점 관리</span>
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
							</div>
						</div>
					</div>	
				</div>
			</div>
		</div>
	</div>