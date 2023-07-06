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
												<span class="row-title">마스터 관리</span>
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
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>