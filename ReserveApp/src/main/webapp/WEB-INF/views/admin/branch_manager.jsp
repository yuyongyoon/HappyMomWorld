<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
let checkUnload = true;

$(document).ready(function() {
	//통신 객체
	ajaxCom = {
		getBranchList: function(){
			$.doPost({
				url		: "/admin/getBranchList",
				data	: {
					branchCode	: $('#input_branchCode').val(),
					branchName	: $('#input_branchName').val(),
					joinCode	: $('#input_joinCode').val(),
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
		}
	}; //ajaxCom END
	
	btnCom = {
		btn_get: function(){
			ajaxCom.getBranchList();
		},
		btn_add: function(){
			tuiGrid.appendRow(branchGrid,{branch_code_col:'',branch_name:''},{editable:['branch_code_col', 'branch_name']});
		},
		btn_download: function() {
			tuiGrid.dataExport(branchGrid,'지점관리.xlsx');
		},
		btn_save: function() {
			let data = tuiGrid.getModifiedData(branchGrid);
			let checkFlag = false;
			
			if(data.length == 0) {
				alert('수정된 내용이 없습니다.');
				return false;
			}
			
			data.forEach(function(data) {
				if(data.branch_code_col == null || data.branch_code_col == '') {
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
			readOnlyColorFlag : true,
			rowHeaders: [{type: 'checkbox', header:'삭제'}],
			columns: [
				{header: '지점코드',		name : 'branch_code_col', 	editor: 'text', align:'left', disabled:true, style:'cursor:pointer;text-decoration:underline;'},
				{header : '지점이름',		name : 'branch_name',		align:'left', editor: 'text', },
				{header : '가입코드',		name : 'join_code',			align:'left' },
				{header : '등록일',		name : 'created_dt',		align:'left' },
				{header : 'no',			name : 'seq_no',			hidden:true},
			]
		},
		[],//초기 데이터
		//이벤트
		{
			cellclick : function(rowKey,colName,grid){
			}
		}
	);
	
	ajaxCom.getBranchList()
}); //END $(document).ready


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
												<button type="button" id="btn_add" class="header-btn btn btn-secondary float-left ml-2 mb-2">지점 추가</button>
												<button type="button" id="btn_save" class="header-btn btn btn-secondary float-left ml-2 mb-2">저장</button>
												<button type="button" id="btn_download" class="header-btn btn btn-secondary float-left ml-2 mb-2">다운로드</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<!-- search -->
							<div class="row search flex-grow-1">
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_branchCode" class="search-label float-left mt-2">지점 코드</label>
									<input type="text" id="input_branchCode" class="form-control form-control-sm mt-2"/>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_branchName" class="search-label float-left mt-2">지점 이름</label>
									<input type="text" id="input_branchName" class="form-control form-control-sm mt-2"/>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_joinCode" class="search-label float-left mt-2">가입 코드</label>
									<input type="text" id="input_joinCode" class="form-control form-control-sm mt-2"/>
								</div>
							</div>
							
							<div class="sub-titlebar">
								<div class="float-right mt-1 mb-1 mr-2">
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