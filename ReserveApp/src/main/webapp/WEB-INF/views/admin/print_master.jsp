<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script src="/static/common/js/qrcode/jquery.qrcode.min.js"></script>
<script src="/static/common/js/pdf/html2canvas.js"></script>
<script src="/static/common/js/pdf/jspdf.min.js"></script>
<script>
$(document).ready(function() {
	$('#qrcode').qrcode({width: 400,height: 400,text: "http://121.140.47.102:28900/login"});
	let superBranchCode
	let branchName;
	let branchTel;
	let branchAddr;
	let branchHours;
	let branchJoinCode;
	let branchRemark;

	ajaxCom = {
		getBranchPrintInfo: function(){
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
				url	 	: "/admin/getBranchPrintInfo",
				data 	: {
					super_branch_code : superBranchCode
				},
				success	: function(result) {
					if(result.branchPrintInfo != null){
						let data = result.branchPrintInfo;
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
						$('#input_brRemark').val(data.remark);
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
		}
	};
	
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
		btn_saveBranchPrintInfo: function(){
			if($('#modal_brName').val() != '' && $('#modal_brTell').val() != '' && $('#modal_brAddr').val() != '' 
					&& $('#modal_brHours').val() != '' && $('#modal_brCode').val() != '' && $('#modal_brRemark').val() != '') {
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
		btn_cancle: function(){
			$('#branchInfo_modal').modal('hide');
		},
		btn_pdfDownload: function(){
			html2canvas($('#pdfDiv')[0]).then(function(canvas) {
				let imgData = canvas.toDataURL('image/png');
	
				let margin = 10;
				let imgWidth = 210 - (10 * 2);
				let pageHeight = imgWidth * 1.414;
				let imgHeight = canvas.height * imgWidth / canvas.width;
				let heightLeft = imgHeight;
				
				let doc = new jsPDF('p', 'mm');
				let position = margin;
				
				doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
				heightLeft -= pageHeight;
				
				while (heightLeft >= 20) {
					position = heightLeft - imgHeight;
					doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
					doc.addPage();
					heightLeft -= pageHeight;
				}
	
				doc.save('notice.pdf');
			});
		}
	};
	
	ajaxCom.getBranchPrintInfo();
}); //END $(document).ready


$('#select-branch').on('change', function(){
	ajaxCom.getBranchPrintInfo();
})
</script>
<style>
#pdfDiv input, #pdfDiv label, #pdfDiv textarea {
	font-size: 20px!important;
	font-weight: bolder;
}
.form-control:disabled {
	background-color: white!important;
	color: black!important;
}
</style>
<div class="main-panel">
	<div class="content">
		<div class="page-inner">
			<div class="row">
				<div class="col-md-12">
					<div class="card">
						<div class="card-body d-flex flex-column">
							<div class="row">
								<div class="col-md-12">
									<div class="row">
										<div class="col-sm-6">
											<span class="row-title">예약 안내문 관리</span>
										</div>
										<div class="col-sm-6">
											<div class="button-list float-right">
<!-- 												<button type="button" id="btn_branchInfo" class="header-btn btn btn-secondary float-left ml-2 mb-2">지점 정보 수정</button> -->
												<button type="button" id="btn_pdfDownload" class="header-btn btn btn-secondary float-left ml-2 mb-2">다운로드</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							<hr style="border: 1px solid lightgray;width: 100%;">
							<div id="pdfDiv">
								<div class="col-md-12">
									<div class="card-body">
<!-- 										<h1 style="text-align: center;font-size:3.5rem;font-weight:border;" class="mb-2">산전 마사지 예약 안내</h1> -->
										<div class="row">
											<div class="col-12" style="display: flex; justify-content: center;">
												<img src="/static/common/img/1690506713.3915.png" style="width: 200%;">
											</div>
<!-- 											<div class="col-6" style="display: flex; justify-content: center;"> -->
<!-- 												<div id="qrcode" class="" style="margin-top: 100px;"></div> -->
<!-- 											</div> -->
										</div>
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
											<button type="button" class="btn btn-secondary" id="btn_saveBranchPrintInfo">저장</button>
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