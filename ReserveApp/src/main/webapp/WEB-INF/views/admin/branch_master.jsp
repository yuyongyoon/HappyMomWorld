<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
$(document).ready(function() {
	let superBranchCode
	let branchName;
	let branchTel;
	let branchAddr;
	let branchHours;
	let branchJoinCode;
	let branchRemark;

	ajaxCom = {
		getBranchInfo: function(){
			if($('#role').val() == 'SUPERADMIN'){
				superBranchCode = $('#select-branch');
				$('#btn_branchInfo').css('display', 'none');
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
						branchName = data.branch_name;
						branchTel = data.branch_tel;
						branchAddr = data.branch_addr;
						branchHours = data.business_hours;
						branchJoinCode = data.join_code;
						branchRemark = data.remark;
						
						$('#input_brName').val(data.branch_name);
						$('#input_brTel').val(data.branch_tel);
						$('#input_brAddr').val(data.branch_addr);
						$('#input_brHours').val(data.business_hours);
						$('#input_brJoincode').val(data.join_code);
						$('#input_brCode').val(data.join_code);
						$('#input_remark').val(data.remark);
					}
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		}
	}; //ajaxCom END
	
	btnCom = {
		btn_branchInfo: function(){
			$('#modal_brName').val(branchName);
			$('#modal_brTell').val(branchTel);
			$('#modal_brAddr').val(branchAddr);
			$('#modal_brHours').val(branchHours);
			$('#modal_brCode').val(branchJoinCode);
			$('#modal_brRemark').val(branchRemark);
			$('#branchInfo_modal').modal('show');
		},
		btn_saveBranchInfo: function(){
			if($('#modal_brName').val() != '' && $('#modal_brTell').val() != '' && $('#modal_brAddr').val() != '' 
					&& $('#modal_brHours').val() != '' && $('#modal_brCode').val() != '' && $('#modal_brRemark').val() != '') {
				let param = {
						branch_name : $('#modal_brName').val(),
						branch_tel : $('#modal_brTell').val(),
						branch_addr : $('#modal_brAddr').val(),
						business_hours : $('#modal_brHours').val(),
						remark : $('#modal_brRemark').val()
				}
				
				console.log(param)
			} else {
				alert('칸을 모두 입력해주세요.');
				return false;
			}
			
		},
		btn_cancle: function(){
			$('#branchInfo_modal').modal('hide');
		}
	};
	ajaxCom.getBranchInfo();
}); //END $(document).ready


$('#select-branch').on('change', function(){
	ajaxCom.getBranchInfo();
})
</script>
<div class="main-panel">
	<div class="content">
		<div class="page-inner">
			<div class="row">
				<div class="col-md-12">
					<div class="card">
						<div class="card-body d-flex flex-column">
							<div class="row" style="border-bottom:1px solid gray">
								<div class="col-md-12">
									<div class="row">
										<div class="col-sm-6">
											<span class="row-title">지점 마스터 관리</span>
										</div>
										<div class="col-sm-6">
											<div class="button-list float-right">
<!-- 												<button type="button" id="btn_get" class="header-btn btn btn-secondary float-left ml-2 mb-2">조회</button> -->
												<button type="button" id="btn_branchInfo" class="header-btn btn btn-secondary float-left ml-2 mb-2">지점 정보</button>
												<button type="button" id="" class="header-btn btn btn-secondary float-left ml-2 mb-2">다운로드</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<div class="col-md-12">
								<div class="card-body">
									<h1 style="text-align: center">산전 마사지 예약 안내</h1>
									<div class="row mt-3">
										<div class="col-md-3">
											<label>지점 이름</label>
										</div>
										<div class="col-md-9">
											<input type="text" class="form-control" id="input_brName" disabled>
										</div>
									</div>
									<div class="row mt-3">
										<div class="col-md-3">
											<label>전화번호</label>
										</div>
										<div class="col-md-9">
											<input type="text" class="form-control" id="input_brTel" disabled>
										</div>
									</div>
									<div class="row mt-3">
										<div class="col-md-3">
											<label>주소</label>
										</div>
										<div class="col-md-9">
											<input type="text" class="form-control" id="input_brAddr" disabled>
										</div>
									</div>
									<div class="row mt-3">
										<div class="col-md-3">
											<label>운영시간</label>
										</div>
										<div class="col-md-9">
											<input type="text" class="form-control" id="input_brHours" disabled>
										</div>
									</div>
									<div class="row mt-3">
										<div class="col-md-3">
											<label>가입코드</label>
										</div>
										<div class="col-md-9">
											<input type="text" class="form-control" id="input_brCode" disabled>
										</div>
									</div>
									<div class="row mt-3">
										<div class="col-md-3">
											<label>안내문구</label>
										</div>
										<div class="col-md-9">
											<textarea class="form-control" id="input_brRemark" rows="3"  style="resize: none;" disabled></textarea>
										</div>
									</div>
									<div class="row mt-3">
										<div></div>
									</div>
								</div>
							</div>
							
							<div class="modal fade" id="branchInfo_modal" tabindex="-1" role="dialog" aria-hidden="true">
								<div class="modal-dialog modal-dialog-centered" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h4 class="modal-title">지점 정보</h4>
										</div>
										<div class="modal-body">
											<div class="col-12">
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2">지점 이름</label>
													</div>
													<div class="col-sm-10">
														<input type="text" class="form-control" id="modal_brName">
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2" style="border: 0px;">전화번호</label>
													</div>
													<div class="col-sm-10">
														<input type="text" class="form-control" id="modal_brTell">
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2" style="border: 0px;">주소</label>
													</div>
													<div class="col-sm-10">
														<input type="text" class="form-control" id="modal_brAddr">
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2">운영 시간</label>
													</div>
													<div class="col-sm-10">
														<input type="text" class="form-control" id="modal_brHours">
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2">
														<label class="control-label mt-2">가입코드</label>
													</div>
													<div class="col-sm-10">
														<input type="text" class="form-control" id="modal_brCode" disabled>
													</div>
												</div>
												<div class="form-group row pb-0">
													<div class="col-sm-2 ">
														<label class="control-label mt-2">안내 문구</label>
													</div>
													<div class="col-sm-10">
														<textarea class="form-control" id="modal_brRemark" style="height: 70px;resize: none;"></textarea>
													</div>
												</div>
											</div>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-secondary" id="btn_saveBranchInfo">저장</button>
											<button type="button" class="btn btn-info" id="btn_cancle">취소</button>
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