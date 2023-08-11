<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	$(document).ready(function() {
		let row;
		let exp = [];
		ajaxCom = {
			getReservation : function(){
				$("#tables-container").empty();
				
				$.doPost({
					url		:	"/user/getReservation",
					success	:	function(result){
						$('#massageCnt').text(result.massageCnt.reservation_count)
						$('#massageTotal').text(result.massageCnt.massage_total)
						if(result.rsvList.length != 0){
							result.rsvList.forEach(data => {
								fnCom.createTable(data);
							})
							
							for(let i=0; i<exp.length; i++){
								$(exp[i]).css('display','none');
							}
						} else{
							$('#rsvTable').css('display', '');
						}
					},
					error	:	function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			},
			removeReservation : function(param){
				$.doPost({
					url		:	"/user/removeReservation",
					data	:	param,
					success	:	function(result){
						if(result.msg == "success"){
							alert("예약이 취소되었습니다.");
							ajaxCom.getReservation();
						}else {
							alert("오류가 발생했습니다.");
						}
					},
					error	:	function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			}
		};
		
		fnCom = {
			createTable : function(data){
				let tableTemplate = $('#table-template').clone();
				
				const uniqueId = data.rsv_date+'-'+data.select_time;
				tableTemplate.attr('data-id', uniqueId);
				
				tableTemplate.find('.rsv_date').text(data.rsv_date);
				tableTemplate.find('.rsv_time').text(data.rsv_time.substring(0,5));
				tableTemplate.find('.branch_name').text(data.branch_name);
				tableTemplate.find('.branch_tel').text(data.branch_tel);
				tableTemplate.find('.select_time').text(data.select_time);
				
				tableTemplate.css('display', '');
				
				$('#tables-container').append(tableTemplate);
				
				let cancelBtn = tableTemplate.find('.btn_cancel');
				let cancelTr = tableTemplate.find('.trCancel')
				cancelBtn.attr('id', 'btn_'+uniqueId);
				cancelTr.attr('id', 'tr_'+uniqueId);
				
				const today = new Date();
				const rsvDate = new Date(data.rsv_date);
				
				if (rsvDate < today) {
					exp.push('#btn_'+uniqueId);
					exp.push('#tr_'+uniqueId);
				}

				
				tableTemplate.find('.btn_cancel').on('click', function() {
					const table = $(this).closest(".table-responsive");
					const selectTime = table.find(".select_time").text();
					const rsvDate = table.find(".rsv_date").text();

					let param = {
						select_time : selectTime,
						rsv_date	: rsvDate,
						flag		: 'd'
					}
					
					if (confirm('예약을 취소하시겠습니까?')) {
					ajaxCom.removeReservation(param);
				}
				});
			}
		}
		
		ajaxCom.getReservation();
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
											<span class="row-title">예약 확인</span>
											<br>
											<span class="row-title" style="font-size: 25px;">(</span>
											<span class="row-title" id="massageCnt" style="font-size: 25px;"></span>
											<span class="row-title" style="font-size: 25px;">회 예약 / 총 </span>
											<span class="row-title" id="massageTotal" style="font-size: 25px;"></span>
											<span class="row-title" style="font-size: 25px;">회 )</span>
										</div>
									</div>
								</div>
							</div>
							
							<div id="rsvTable" class="col-md-12 mt-3" style="display: none;">
								<div class="col-md-12 mt-3">
									<div class="table-responsive">
										<table class="table table-head-bg-secondary">
											<tbody>
												<tr style="border-top:1px solid #dee2e6;">
												<td style="text-align: center;">예약 내역이 없습니다.</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							
							<div id="tables-container" class="col-md-12 mt-3">
							</div>
							
							<div id="table-template" class="table-responsive" style="display: none;">
								<div class="col-md-12 mt-3">
									<div class="table-responsive">
										<table class="table table-head-bg-secondary">
											<tbody>
												<tr style="border-top:1px solid #dee2e6;">
													<td>예약 날짜</td>
													<td class="rsv_date"></td>
												</tr>
												<tr>
													<td>예약 시간</td>
													<td class="rsv_time"></td>
												</tr>
												<tr>
													<td>예약 지점</td>
													<td class="branch_name"></td>
												</tr>
												<tr>
													<td>전화번호</td>
													<td class="branch_tel"></td>
												</tr>
												<tr style="display:none;">
													<td class="select_time"></td>
												</tr>
												<tr class="trCancel">
													<td colspan="2">
														<button type="button" class="btn_cancel header-btn btn btn-secondary btn-rounded btn-lg btn-block">취소</button> 
													</td>
												</tr>
											</tbody>
										</table>
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