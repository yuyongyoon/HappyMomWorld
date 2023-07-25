<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<script>
	$(document).ready(function() {
		let row;		
		let now = new Date();
		let start = now.toISOString().substring(0, 10);
		let end = new Date(now.setMonth(now.getMonth()+6)).toISOString().substring(0, 10);
		$('#input_startDate').val(start);
		$('#input_endDate').val(end);
		
		ajaxCom = {
			getReservation : function(){
				$('#table-body').find('tr').remove();
				let param = {
						startDate	:	$('#input_startDate').val(),
						endDate		:	$('#input_endDate').val()
				}
				$.doPost({
					url		:	"/user/getReservation",
					data	:	param,
					success	:	function(result){
						let add_table  = '';
						result.rsvList.forEach( (rsv, i) => {
							row = i+1;
							add_table += '\n<tr>\n';
							add_table += '	<th scope="row">' + row + '</th>\n';
							add_table += '	<td>' + rsv.rsv_date + '</th>\n';
							add_table += '	<td>' + rsv.rsv_time + '</th>\n';
							add_table += '	<td><button type="button"   id="btn_cancel' + (i+1) + '" class="header-btn btn btn-secondary float-left ml-2 mb-2">취소</button></td>\n';
							add_table += '	<td>' + rsv.branch_name + '</th>\n';
							add_table += '	<td>' + rsv.branch_tel + '</th>\n';
							add_table += '</tr>';
							});
						$('#table-body').append(add_table);
						$('#userCnt').text(result.rsvList.length);
						$('#table-body').on('click', '[id^="btn_cancel"]', function() {
							let row = $(this).attr('id').replace('btn_cancel', '');
							let date = result.rsvList[row-1].rsv_date;
							btn_cancel('date: ',date);
						});
					},
					error	:	function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			},
			removeReservation : function(param){
				$('#table-body').find('tr').remove();
				
				$.doPost({
					url		:	"/user/removeReservation",
					data	:	param,
					success	:	function(result){
						if(result.msg == "success"){
							ajaxCom.getReservation();
							alert("예약이 취소되었습니다.");
						}else {
							alert("취소가 실패했습니다.");
						}
					},
					error	:	function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			}
		}; //ajaxCom END
		
		btnCom = {
			btn_get : function(){
				let param = {
					startDate	:	$('#input_startDate').val(),
					endDate		:	$('#input_endDate').val()
				}
				ajaxCom.getReservation(param);
			}
		}; //btnCom END

		fnCom = {

		}; //fnCom END
		
		ajaxCom.getReservation();
	}); //END $(document).ready
	
	function btn_cancel(rd, rsv_date){
		let modalId = $(this).closest(".modal").attr("id");
		let param = {
				rsv_date	:	rsv_date
		}
		
		if (confirm("예약을 취소하시겠습니까?")) {
			ajaxCom.removeReservation(param);
		}
		$('#' + modalId).modal('hide');
	}
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
										</div>
										<div class="col-sm-6">
											<div class="button-list float-right">
												<button type="button" id="btn_get" class="header-btn btn btn-secondary float-left ml-2 mb-2">조회</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<!-- table -->
							<div class="row search">
								<div class="col-sm-3">
									<label for="input_startDate" class="search-label float-left mt-2">기간</label>
									<input type="date" id="input_startDate" class="form-control form-control-sm mt-2" />
								</div>
								<div class="col-sm-3">
									<label for="input_endDate" class="search-label float-left mt-2">~</label>
									<input type="date" id="input_endDate" class="form-control form-control-sm mt-2" />
								</div>
							</div>
							<div class="sub-titlebar">
								<div class="float-right mt-1 mb-1 mr-2">
									조회 건수: <span id="userCnt"></span>건
								</div>
							</div>
							<!-- Table -->
							<div class="container-fluid">
								<table class="table table-bordered">
								<thead>
									<tr class="table-secondary" align="center">
										<th scope="col">No</th>
										<th scope="col">예약 날짜</th>
										<th scope="col">예약 시간</th>
										<th scope="col">예약 취소</th>
										<th scope="col">마사샵 이름</th>
										<th scope="col">마사샵 전화번호</th>
									</tr>
								</thead>
								<tbody id="table-body">
									<!-- <tr>
										<th scope="row" class="col-sm-0.5">0</th>
										<td class="col-sm-2">2023-07-05</td>
										<td class="col-sm-2">15:00~16:00</td>
										<td class="col-sm-1.5"><button type="button" id="btn_cancel" class="header-btn btn btn-secondary float-left ml-2 mb-2">취소</button></td>
										<td class="col-sm-3">test</td>
										<td class="col-sm-3">02-0000-0000</td>
									</tr> -->
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