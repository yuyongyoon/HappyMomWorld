<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<script>
	$(document).ready(function() {
		let row;
		const today = new Date();
		const sixMonth = new Date(today.getFullYear(), today.getMonth() + 6, today.getDate());
		
		const searchPicker = tui.DatePicker.createRangePicker({
			startpicker: {
				date: today,
				input: '#input_startDate',
				container: '#startDate-container'
			},
			endpicker: {
				date: sixMonth,
				input: '#input_endDate',
				container: '#endDate-container'
			},
			language: 'ko',
			format: 'YYYY-MM-dd'
		});
		
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
						if(result.rsvList.length > 0){
							$('#table-body').find('tr').remove();
							let add_table  = '';
							result.rsvList.forEach( (rsv, i) => {
								row = i+1;
								add_table += '\n<tr>\n';
								add_table += '	<th scope="row" style="text-align:center;">' + row + '</th>\n';
								add_table += '	<td>' + rsv.rsv_date + '</th>\n';
								add_table += '	<td>' + rsv.rsv_time + '</th>\n';
								add_table += '	<td>' + rsv.branch_name + '</th>\n';
								add_table += '	<td>' + rsv.branch_tel + '</th>\n';
								add_table += '	<td select_time="'+rsv.select_time+'" rsv_date="'+rsv.rsv_date+'" style="text-align:center;"><button type="button"   id="btn_cancel' + (i+1) + '" class="header-btn btn btn-secondary">취소</button></td>\n';
								add_table += '</tr>';
								});
							$('#table-body').append(add_table);
							$('#rsvCnt').text(result.rsvList.length);
						} else {
							$('#table-body').find('tr').remove();
							let add_table = '';
							add_table += '<tr><td colspan="6" style="text-align: center;">해당 기간에 등록된 예약이 없습니다.</td></tr>';
							$('#table-body').append(add_table);
							$('#rsvCnt').text(result.rsvList.length);
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
		
		btnCom = {
			btn_get : function(){
				let param = {
					startDate	:	$('#input_startDate').val(),
					endDate		:	$('#input_endDate').val()
				}
				ajaxCom.getReservation(param);
			}
		};

		ajaxCom.getReservation();
		
		$('#table-body').on('click', '[id^="btn_cancel"]', function() {
			let select_time = $(this).parent().attr('select_time');
			let rsv_date = $(this).parent().attr('rsv_date');
			
			let param = {
				rsv_date	:	rsv_date,
				select_time :	select_time
			}
			
			if (confirm("예약을 취소하시겠습니까?")) {
				ajaxCom.removeReservation(param);
			}
		});
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
										</div>
										<div class="col-sm-6">
											<div class="button-list float-right">
												<button type="button" id="btn_get" class="header-btn btn btn-secondary float-left ml-2 mb-2">조회</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<div class="row search flex-grow-1">
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_startDate" class="search-label float-left mt-2">기간</label>
									<div class="tui-datepicker-input tui-datetime-input">
										<input id="input_startDate" type="text" aria-label="Date">
										<span class="tui-ico-date"></span>
										<div id="startDate-container" style="margin-left: -1px;"></div>
									</div>
								</div>
								<div class="col-md-3 col-sm-6 searchDiv">
									<label for="input_endDate" class="search-label float-left mt-2">~</label>
									<div class="tui-datepicker-input tui-datetime-input">
										<input id="input_endDate" type="text" aria-label="Date">
										<span class="tui-ico-date"></span>
										<div id="endDate-container" style="margin-left: -1px;"></div>
									</div>
								</div>
							</div>
							
							<div class="sub-titlebar">
								<div class="float-right mt-1 mb-1 mr-3">
									조회 건수: <span id="rsvCnt"></span>건
								</div>
							</div>

							<div class="col-md-12 mt-3">
								<div class="table-responsive" style="overflow-x: auto;">
									<table class="table table-bordered">
										<thead>
											<tr class="table-secondary" align="center">
												<th scope="col">No</th>
												<th scope="col">예약 날짜</th>
												<th scope="col">예약 시간</th>
												<th scope="col">예약 지점</th>
												<th scope="col">전화번호</th>
												<th scope="col">예약 취소</th>
											</tr>
										</thead>
										<tbody id="table-body"></tbody>
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