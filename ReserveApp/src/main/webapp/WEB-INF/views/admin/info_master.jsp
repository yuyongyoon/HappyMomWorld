<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
$(document).ready(function() {
	ajaxCom = {
		getBranchPrintInfo: function(){
			let superBranchCode;
			if($('#role').val() == 'SUPERADMIN'){
				superBranchCode = $('#select-branch');
				$('#btn_saveBranchInfo').css('display', 'none');
				$('#btn_saveBranchReservationInfo').css('display', 'none');
			}
			
			if($('#select-branch').val() != ''){
				superBranchCode = $('#select-branch').val();
			} else {
				superBranchCode = '';
			}
			
			$.doPost({
				url	 	: "/admin/getBranchPrintInfo",
				data 	: {
					super_branch_code : superBranchCode
				},
				success	: function(result) {
					if(result.branchPrintInfo != null){
						let data = result.branchPrintInfo;
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
				url	 	: "/admin/saveBranchPrintInfo",
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
		},
		getRecentlyBranchReservationInfo: function(){
			let param;
			console.log($('#select-branch').val() != '')
			console.log($('#select-branch'))
// 			console.log(($('#select-branch').val() != ''&& $('#role').val() == 'SUPERADMIN'))
			if($('#select-branch').val() != '' && $('#role').val() == 'SUPERADMIN'){
				console.log('참')
				param = {
					super_branch_code : $('#select-branch').val()
				}
			} else {
				param = {
					super_branch_code : ''
				}
			}
			
			console.log(param)
			
			$.doPost({
				url	 	: "/admin/getRecentlyBranchReservationInfo",
				data 	: param,
				success	: function(result) {
					if(result.recentlyBranchReservationInfo != null){
						if(result.recentlyBranchReservationInfo.rsv_month == '2023-00'){
							$('#rsv_month').text('기본값');
						} else {
							$('#rsv_month').text(result.recentlyBranchReservationInfo.rsv_month + ' 기준');
						}
						$('#input_1t').val(result.recentlyBranchReservationInfo.t1_name);
						$('#input_2t').val(result.recentlyBranchReservationInfo.t2_name);
						$('#input_3t').val(result.recentlyBranchReservationInfo.t3_name);
						$('#input_4t').val(result.recentlyBranchReservationInfo.t4_name);
						$('#input_5t').val(result.recentlyBranchReservationInfo.t5_name);
						$('#input_6t').val(result.recentlyBranchReservationInfo.t6_name);
						$('#input_7t').val(result.recentlyBranchReservationInfo.t7_name);
						$('#input_8t').val(result.recentlyBranchReservationInfo.t8_name);
						$('#input_9t').val(result.recentlyBranchReservationInfo.t9_name);
						$('#input_10t').val(result.recentlyBranchReservationInfo.t10_name);
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
						branch_name : $('#modal_brName').val(),
						branch_tel : $('#modal_brTell').val(),
						branch_addr : $('#modal_brAddr').val(),
						business_hours : $('#modal_brHours').val(),
						remark : $('#modal_brRemark').val()
				}
				
				ajaxCom.saveBranchPrintInfo(param);
			} else {
				alert('칸을 모두 입력해주세요.');
				return false;
			}
			
		},
		btn_saveBranchReservationInfo: function(){
			console.log('클릭');
		}
	};
	
	ajaxCom.getBranchPrintInfo();
	ajaxCom.getRecentlyBranchReservationInfo();
}); //END $(document).ready


$('#select-branch').on('change', function(){
	ajaxCom.getBranchPrintInfo();
	ajaxCom.getRecentlyBranchReservationInfo();
})
</script>
<div class="main-panel">
	<div class="content">
		<div class="page-inner">
			<div class="row">
				<div class="col-md-12">
					<div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header">
									<div class="card-title" style="font-size:20px;">지점 정보</div>
								</div>
								<div class="card-body">
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
											<div class="row mt-3">
												<div class="col-md-12">
													<button type="button" class="btn btn-secondary float-right" id="btn_saveBranchInfo">저장</button>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						
						<div class="col-md-6">
							<div class="card">
								<div class="card-header">
									<div class="card-title" style="font-size:20px;">예약 시간 정보</div>
								</div>
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<div class="col-md-12" style="text-align: right;">
												<span id="rsv_month"></span>
											</div>
											<div class="row mt-2">
												<div class="col-md-12">
													<div class="row form-group">
														<div class="col-sm-2">
															<label class="control-label mt-2" style="border: 0px;" for="input_1t">1 Time</label>
														</div>
														<div class="col-sm-4">
															<input type="text" class="form-control" id="input_1t">
														</div>
														<div class="col-sm-2">
															<label class="control-label mt-2" style="border: 0px;" for="input_2t">2 Time</label>
														</div>
														<div class="col-sm-4">
															<input type="text" class="form-control" id="input_2t">
														</div>
													</div>
												</div>
											</div>
											<div class="row mt-2">
												<div class="col-md-12">
													<div class="row form-group">
														<div class="col-sm-2">
															<label class="control-label mt-2" style="border: 0px;" for="input_3t">3 Time</label>
														</div>
														<div class="col-sm-4">
															<input type="text" class="form-control" id="input_3t">
														</div>
														<div class="col-sm-2">
															<label class="control-label mt-2" style="border: 0px;" for="input_4t">4 Time</label>
														</div>
														<div class="col-sm-4">
															<input type="text" class="form-control" id="input_4t">
														</div>
													</div>
												</div>
											</div>
											
											<div class="row mt-2">
												<div class="col-md-12">
													<div class="row form-group">
														<div class="col-sm-2">
															<label class="control-label mt-2" style="border: 0px;" for="input_5t">5 Time</label>
														</div>
														<div class="col-sm-4">
															<input type="text" class="form-control" id="input_5t">
														</div>
														<div class="col-sm-2">
															<label class="control-label mt-2" style="border: 0px;" for="input_6t">6 Time</label>
														</div>
														<div class="col-sm-4">
															<input type="text" class="form-control" id="input_6t">
														</div>
													</div>
												</div>
											</div>
											
											<div class="row mt-2">
												<div class="col-md-12">
													<div class="row form-group">
														<div class="col-sm-2">
															<label class="control-label mt-2" style="border: 0px;" for="input_7t">7 Time</label>
														</div>
														<div class="col-sm-4">
															<input type="text" class="form-control" id="input_7t">
														</div>
														<div class="col-sm-2">
															<label class="control-label mt-2" style="border: 0px;" for="input_8t">8 Time</label>
														</div>
														<div class="col-sm-4">
															<input type="text" class="form-control" id="input_8t">
														</div>
													</div>
												</div>
											</div>
											
											<div class="row mt-2">
												<div class="col-md-12">
													<div class="row form-group">
														<div class="col-sm-2">
															<label class="control-label mt-2" style="border: 0px;" for="input_9t">9 Time</label>
														</div>
														<div class="col-sm-4">
															<input type="text" class="form-control" id="input_9t">
														</div>
														<div class="col-sm-2">
															<label class="control-label mt-2" style="border: 0px;" for="input_10t">10 Time</label>
														</div>
														<div class="col-sm-4">
															<input type="text" class="form-control" id="input_10t">
														</div>
													</div>
												</div>
											</div>
											
											<div class="row mt-2 mb-2">
												<div class="col-md-12">
													<button type="button" class="btn btn-secondary float-right" id="btn_saveBranchReservationInfo">저장</button>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
							
							<div class="modal fade" id="branchInfo_modal" tabindex="-1" role="dialog" aria-hidden="true">
								<div class="modal-dialog modal-dialog-centered" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h4 class="modal-title">예약 정보</h4>
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
											
											<button type="button" class="btn btn-info" id="btn_cancle">취소</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>	
			</div>
<!-- 		</div> -->
<!-- 	</div> -->
</div>