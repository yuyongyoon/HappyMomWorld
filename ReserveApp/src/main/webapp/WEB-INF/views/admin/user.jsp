<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
				url	 : "/admin/getUserList",
				data : {
					userIdOrName	: userIdOrName,
					phoneNumber		: phoneNumber,
					startDate		: startDate,
					endDate			: endDate
				},
				success		: function(result) {
					console.log(result)
					userGrid.resetData(result.userList);
				},
				error		: function(xhr,status){
					alert("오류가 발생했습니다.");
				}
			});
		}
	}; //ajaxCom END
	
	//이벤트 객체 : id값을 주면 클릭 이벤트 발생
	btnCom = {
		btn_get : function() {
			//조회버튼
			ajaxCom.getUserList();
		},
		btn_save : function(){
			//저장버튼
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
				{header : 'ID',			name : 'id',				width : 200,  align:'left', style:'cursor:pointer;text-decoration:underline;',},
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
				if(colName=="id"){
					console.log('클릭클릭')
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

							<div class="row search">
								<div class="col-sm-3">
									<label for="input_id" class="search-label float-left mt-2">ID 또는 이름</label>
									<input type="text" id="input_id_name" class="form-control form-control-sm mt-2"/>
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
							
							<div id="user_grid"></div>
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>
</div>
