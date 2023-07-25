<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<script>
	$(document).ready(function() {
		let row;
		//통신 객체
		ajaxCom = {
			// 회원 예약 리스트 가져오기
			getReservation : function(){
				$.doPost({
					url		:	"/user/getReservation",
					//data	:
					success	:	function(result){
						//<table> No | 예약시간 | 예약취소 | 마사지샵 이름 | 마사지샵 전화번호
						let add_table  = '';
						result.rsvList.forEach( (rsv, i) => {
							row = i+1;
							add_table += '\n<tr>\n';
							add_table += '	<th scope="row">' + row + '</th>\n';
							add_table += '	<td>' + rsv.rsv_date + '</th>\n';
							add_table += '	<td>' + rsv.rsv_time + '</th>\n';
							add_table += '	<td><button type="button"   id="btn_cancel' + (i+1)  //onclick="btn_cancel();"
											+ '" class="header-btn btn btn-secondary float-left ml-2 mb-2">취소</button></td>\n';
							add_table += '	<td>' + rsv.branch_name + '</th>\n';
							add_table += '	<td>' + rsv.branch_tel + '</th>\n';
							add_table += '</tr>';
							});
						$('#table-body').append(add_table);
						//btn_cancel = 'btn_cancel'+row;
						console.log('예약 리스트: ',result.rsvList);
						//console.log(add_table);		//table structure test
						//console.log(btn_cancel);
						
						//추가한 부분
						$('#table-body').on('click', '[id^="btn_cancel"]', function() {
							let row = $(this).attr('id').replace('btn_cancel', '');
							console.log(row)
							btn_cancel(row);
						});
					},
					error	:	function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			},
			// 기간별 예약 조회
			searchRsv : function(param){
				$.doPost({
					url		:	"/user/searchRsv",
					data	:	param,
					success	:	function(result){
						//<table> No | 예약시간 | 예약취소 | 마사지샵 이름 | 마사지샵 전화번호
						let add_table  = '';
						result.rsvList.forEach( (rsv, i) => {
							row = i+1;
							add_table += '\n<tr>\n';
							add_table += '	<th scope="row">' + row + '</th>\n';
							add_table += '	<td>' + rsv.rsv_date + '</th>\n';
							add_table += '	<td>' + rsv.rsv_time + '</th>\n';
							add_table += '	<td><button type="button" id="btn_cancel' + (i+1) + '" class="header-btn btn btn-secondary float-left ml-2 mb-2">취소</button></td>\n';
							add_table += '	<td>' + rsv.branch_name + '</th>\n';
							add_table += '	<td>' + rsv.branch_tel + '</th>\n';
							add_table += '</tr>';
							});
						$('#table-body').append(add_table);
						
						//btn_cancel = 'btn_cancel'+row;
						console.log('예약 리스트: ',result.rsvList);
						//console.log(add_table);	//table structure test
						//console.log(btn_cancel);
					},
					error	:	function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			}
		}; //ajaxCom END
		
		btnCom = {
			//조회 버튼
			btn_get : function(){
				let param = {
					startDate	:	$('#input_startDate').val(),
					endDate		:	$('#input_endDate').val()
				}
				
				$('#table-body').empty();
				
				ajaxCom.searchRsv(param);	// 조회
			},
			
			// 예약 취소 버튼 클릭 시
			//누른 row의 취소 버튼 가져오는 부분 id값 때문에 구현 못 해서 주석 처리	
			/*btn_cancel : function() {
				console.log('예약 취소 버튼')
				let modalId = $(this).closest(".modal").attr("id");
				
				if (confirm("예약을 취소하시겠습니까?")) {
					alert("취소되었습니다.");
				}
				$('#' + modalId).modal('hide');
				ajaxCom.getReservation();	// 조회
			} //*/
		}; //btnCom END

		//기타 함수 객체
		fnCom = {

		}; //fnCom END
		
	ajaxCom.getReservation();

	}); //END $(document).ready
	
	function btn_cancel(){
		console.log('클릭함')
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
												<button type="button" id="btn_add" class="header-btn btn btn-secondary float-left ml-2 mb-2">추가</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<!-- table -->
							<div class="row search">
								<div class="col-sm-3">
									<label for="input_startDate" class="search-label float-left mt-2">기간</label>
									<input type="date" id="input_startDate"  class="form-control form-control-sm mt-2" />
								</div>
								<div class="col-sm-3">
									<label for="input_endDate" class="search-label float-left mt-2">~</label>
									<input type="date" id="input_endDate" class="form-control form-control-sm mt-2" />
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