<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script src="/static/common/js/qrcode/jquery.qrcode.min.js"></script>
<script>
$(document).ready(function() {
	$('#qrcode').qrcode({width: 300,height: 300,text: "http://121.140.47.102:28900/login"});

	btnCom = {
		btn_makeQrImg: function(){
			$("#qrcode").empty();
			$('#qrcode').qrcode({width: 300,height: 300,text:$('#input_url').val()});
		}
	};
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
								<input type="text" placeholder="URL 입력" class="form-control" value="http://121.140.47.102:28900" id="input_url">
								<div class="input-group-prepend">
									<button type="button" id="btn_makeQrImg" class="btn btn-search btn-secondary">
										<i class="fas fa-share"></i>
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