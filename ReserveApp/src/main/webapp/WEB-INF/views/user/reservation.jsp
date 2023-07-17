<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<script>
	$(document).ready(function() {
		//통신 객체
		ajaxCom = {
			// 회원 예약 리스트 가져오기
			getReservation : function(){
				$.doPost({
					url		:	"/user/getReservation",
					//data	:
					success	:	function(result){
						
						let add_table  = '';
						result.rsvList.forEach( (rsv, i) => {
								//console.log("index : ", i, "rsv : ", rsv);	//test
								add_table += '\n<tr>\n';
								add_table += '	<th scope="row">' + (i+1) + '</th>\n';
								add_table += '	<td>' + rsv.date + '</th>\n';
								add_table += '	<td>' + rsv.time + '</th>\n';
								add_table += '	<td>' + rsv.staff_num + '</th>\n';
								add_table += '	<td><button type="button" id="btn_cancel' + (i+1) + '" class="header-btn btn btn-secondary float-left ml-2 mb-2">취소</button></td>\n';
								add_table += '	<td><button type="button" id="btn_change' + (i+1) + '" class="header-btn btn btn-secondary float-left ml-2 mb-2">변경</button></td>\n';
								add_table += '</tr>';
							});
						$('#table-body').append(add_table);
						//console.log(add_table);		//table structure test
					},
					error	:	function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			}
		}; //ajaxCom END
		
		
		btnCom = {
			// 예약 취소 버튼 클릭 시
			//누른 row의 취소 버튼 가져오는 부분 id값 때문에 구현 못 해서 주석 처리
			/* btn_cancel(???) : function() {
				let modalId = $(this).closest(".modal").attr("id");
				
				if (confirm("예약을 취소하시겠습니까?")) {
					alert("취소되었습니다.");
				}
				$('#' + modalId).modal('hide');
				ajaxCom.getReservation();	// 조회
			} */
		}; //btnCom END

		//기타 함수 객체
		fnCom = {

		}; //fnCom END
		
	ajaxCom.getReservation();

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
									<tr class="table-secondary"  align="center">
										<th scope="col">No</th>
										<th scope="col">날짜</th>
										<th scope="col">예약 시간</th>
										<th scope="col">마사지 종류</th>
										<th scope="col">예약 취소</th>
										<th scope="col">예약 변경</th>
									</tr>
								</thead>
								<tbody id="table-body">
									<!-- <tr>
										<th scope="row" class="col-sm-0.1">0</th>
										<td class="col-sm-3">2023-07-05</td>
										<td class="col-sm-3">15:00~16:00</td>
										<td class="col-sm-2">test</td>
										<td class="col-sm-2"><button type="button" id="btn_cancel" class="header-btn btn btn-secondary float-left ml-2 mb-2">취소</button></td>
										<td class="col-sm-2"><button type="button" id="btn_change" class="header-btn btn btn-secondary float-left ml-2 mb-2">변경</button></td>
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