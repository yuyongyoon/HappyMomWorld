<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script src="/static/common/js/qrcode/jquery.qrcode.min.js"></script>
<script>
$(document).ready(function() {
	ajaxCom = {
		getMainUrl: function(){
			$.doPost({
				url		: "/admin/getMainUrl",
				data	: {},
				success	: function(result){
					let url = result.mainUrl.main_url;
					$('#input_url').val(url);
					$('#qrcode').qrcode({width: 300,height: 300,text: url});
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		},
		updateUrl: function(url){
			$.doPost({
				url		: "/admin/updateUrl",
				data	: {
					main_url : url
				},
				success	: function(result){
					$("#qrcode").empty();
					ajaxCom.getMainUrl();
				},
				error	: function(xhr,status){
					alert('오류가 발생했습니다.');
				}
			});
		}
	}

	btnCom = {
		btn_makeQrImg: function(){
			if(confirm("모든 지점의 QR코드가 변경됩니다. 변경하시겠습니까?")) {
				ajaxCom.updateUrl($('#input_url').val());
			}
		}
	};
	
	ajaxCom.getMainUrl()
});


$('#select-branch').css('display', 'none');
</script>

<style>
#qrcode {
	text-align: center;
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
											<span class="row-title">QR 코드 관리</span>
										</div>
									</div>
								</div>
							</div>
							
							<div class="input-group mt-3">
								<input type="text" placeholder="URL 입력" class="form-control" id="input_url">
								<div class="input-group-prepend">
									<button type="button" id="btn_makeQrImg" class="btn btn-search btn-secondary">
										<i class="fas fa-save" style="font-size: 25px;"></i>
									</button>
								</div>
							</div>
							
							<div class="col-md-12 mt-3">
								<div id="qrcode"></div>
							</div>
						</div>
					</div>
				</div>	
			</div>
		</div>
	</div>
</div>