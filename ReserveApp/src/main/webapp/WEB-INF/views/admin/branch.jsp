<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
$(document).ready(function() {
	//통신 객체
	ajaxCom = {
		getBranchList: function(param){
			$.doPost({
				url		: "/admin/getBranchList",
				success	: function(result){
					let branchNum = result.branchList.length;
					$('#branchCnt').text(branchNum);
					branchGrid.resetData(result.branchList)
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		saveBranchData: function(param){
			console.log('ajax', param)
// 			$.doPost({
// 				url		: "",
// 				success	: function(result){
					
// 				},
// 				error	: function(xhr,status){
// 					alert('오류가 발생했습니다.');
// 				}
// 			});
		}
	}; //ajaxCom END
	
	btnCom = {
		btn_add : function(){
			tuiGrid.appendRow(branchGrid,{editable:['branch_code','branch_name','brabch_tel','brabch_address','']});
		},
		btn_download: function() {
			tuiGrid.dataExport(branchGrid,'지점관리.xlsx');
		},
		btn_save: function() {
			let data = tuiGrid.getModifiedData(branchGrid);
			let checkFlag = false;
			
			console.log(data)
			if(data.length == 0) {
				alert('수정된 내용이 없습니다.');
				return false;
			}
			
			data.forEach(function(data) {
				if(data.branch_code == null || data.branch_code == '') {
					alert('지점코드를 반드시 입력해주세요.');
					return false;
				}
				
				if(data.branch_name == null || data.branch_name == '') {
					alert('지점이름을 반드시 입력해주세요.')
					return false;
				}
				
				checkFlag = true;
			});
			
			if(checkFlag){
				ajaxCom.saveBranchData(data);
			}
		}
	}; //btnCom END

	//기타 함수 객체
	fnCom = {

	}; //fnCom END
	
	const branchGrid = tuiGrid.createGrid(
		//그리드 옵션
		{
			gridId : 'branch_grid',
			height : 580,
			scrollX : true,
			scrollY : true,
			readOnlyColorFlag : false,
			rowHeaders: [{type: 'checkbox', header:'삭제'}],
			columns: [
				{header : '지점코드',		name : 'branch_code',	align:'left',	editor:{ type:'text' }},
				{header : '지점이름',		name : 'branch_name',	align:'left',	editor:{ type:'text' } },
				{header : '전화번호',		name : 'brabch_tel',	align:'left',	editor:{ type:'text' } },
				{header : '주소',		name : 'brabch_address',align:'left',	editor:{ type:'text' } },
				{header : '가입코드',		name : 'join_code',		align:'left',	editor:{ type:'text' } }
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
	
	ajaxCom.getBranchList()
}); //END $(document).ready

let checkUnload = true;
$(window).on("beforeunload", function(){
	if(checkUnload) {
		return '변경사항이 저장되지 않을 수 있습니다.';
	}
});

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
												<button type="button" id="btn_download" class="header-btn btn btn-secondary float-left ml-2 mb-2">다운로드</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<!-- search -->
							<div class="row search flex-grow-1">
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_id" class="search-label float-left mt-2">지점 코드</label>
									<input type="text" id="input_code" class="form-control form-control-sm mt-2"/>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_phone" class="search-label float-left mt-2">지점 이름</label>
									<input type="text" id="input_name" class="form-control form-control-sm mt-2"/>
								</div>
							</div>
							
							<div class="sub-titlebar">
								<div class="button-list  float-right mb-1">
									<button type="button" class="btn btn-icon btn-round btn-secondary btn-xs" id="btn_add"><i class="fas fa-plus"></i></button>
									<button type="button" class="btn btn-icon btn-round btn-secondary btn-xs" id="btn_save"><i class="fas fa-save"></i></button>
								</div>
								<div class="float-right mt-1 mr-2">
									조회 건수: <span id="branchCnt"></span>건
								</div>
							</div>
							<div id="branch_grid"></div>
						</div>
					</div>
				</div>	
			</div>
		</div>
	</div>
</div>