<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
$(document).ready(function() {
	ajaxCom = {
		getBranchPrintInfo: function(){
			let superBranchCode;
			if($('#role').val() == 'SUPERADMIN'){
				superBranchCode = $('#select-branch');
				$('#btn_saveBranchInfo').css('display', 'none');
			}
			
			if($('#select-branch').val() != ''){
				superBranchCode = $('#select-branch').val();
			} else {
				superBranchCode = '';
			}
			
			$.doPost({
				url	 	: "/admin/getBranchInfo",
				data 	: {
					super_branch_code : superBranchCode
				},
				success	: function(result) {
					if(result.branchInfo != null){
						let data = result.branchInfo;
						$('#input_brName').val(data.branch_name);
						$('#input_brTel').val(data.branch_tel);
						$('#input_brAddr').val(data.branch_addr);
						$('#input_brHours').val(data.business_hours);
						$('#input_brJoincode').val(data.join_code);
						$('#input_brCode').val(data.join_code);
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		saveBranchPrintInfo: function(param){
			$.doPost({
				url	 	: "/admin/saveBranchInfo",
				data 	: param,
				success	: function(result) {
					if(result.msg == 'success'){
						alert('저장되었습니다.');
						location.reload(true);
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		}
	};
	
	btnCom = {
		btn_saveBranchInfo: function(){
			if($('#input_brName').val() != '' && $('#input_brTell').val() != '' && $('#input_brAddr').val() != '' 
					&& $('#input_brHours').val() != '' && $('#input_brCode').val() != '' && $('#input_brRemark').val() != '') {
				let param = {
						branch_name : $('#input_brName').val(),
						branch_tel : $('#input_brTel').val(),
						branch_addr : $('#input_brAddr').val(),
						business_hours : $('#input_brHours').val(),
						remark : $('#input_brCode').val()
				}
				
				ajaxCom.saveBranchPrintInfo(param);
			} else {
				alert('칸을 모두 입력해주세요.');
				return false;
			}
			
		}
	};
	
	ajaxCom.getBranchPrintInfo();
});


$('#select-branch').on('change', function(){
	ajaxCom.getBranchPrintInfo();
})
</script>
<div class="main-panel">
	<div class="content">
		<div class="page-inner">
			<div class="row">
				<div class="col-md-12">
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-sm-6">
									<span class="row-title">지점 정보 관리</span>
								</div>
								<div class="col-sm-6">
									<div class="button-list float-right">
										<button type="button" class="btn btn-secondary float-right" id="btn_saveBranchInfo">저장</button>
									</div>
								</div>
							</div>
							<hr>
							<div class="row">
								<div class="col-12">
									<div class="row">
										<div class="col-md-12">
											<label for="input_brName">지점 이름</label>
											<input type="text" class="form-control" id="input_brName">
										</div>
									</div>
									<div class="row mt-3">
										<div class="col-md-12">
											<label for="input_brTel">전화번호</label>
											<input type="text" class="form-control" id="input_brTel">
										</div>
									</div>
									<div class="row mt-3">
										<div class="col-md-12">
											<label for="input_brAddr">주소</label>
											<input type="text" class="form-control" id="input_brAddr">
										</div>
									</div>
									<div class="row mt-3">
										<div class="col-md-12">
											<label for="input_brHours">운영시간</label>
											<input type="text" class="form-control" id="input_brHours">
										</div>
									</div>
									<div class="row mt-3">
										<div class="col-md-12">
											<label for="input_brCode">가입코드</label>
											<input type="text" class="form-control" id="input_brCode" disabled>
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