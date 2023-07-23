<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<script>
$(document).ready(function() {
	// DatePicker 객체 생성
	const today = new Date();
	const nextMonth = new Date(today.getFullYear(), today.getMonth() + 1, today.getMonth());
	
	const searchPicker = tui.DatePicker.createRangePicker({
		startpicker: {
			date: today,
			input: '#input_startDate',
			container: '#startDate-container'
		},
		endpicker: {
			date: nextMonth,
			input: '#input_endDate',
			container: '#endDate-container'
		},
		language: 'ko',
		format: 'YYYY-MM-dd'
	});

	let startDate = cfn_tuiDateFormat(searchPicker.getStartDate());
	let endDate = cfn_tuiDateFormat(searchPicker.getEndDate());
	
	//통신 객체
	ajaxCom = {
			getUserList : function() {
				let userIdOrName = $('#input_id_name').val();
				let phoneNumber = $('#input_phone').val();
				let startDate = $('#input_startDate').val();
				let endDate = $('#input_endDate').val();
				if($('#role').val() == 'SUPERADMIN'){
					let superBranchCode = $('#select-branch');
				}
				
				
				if($('#select-branch').val() != ''){
					superBranchCode = $('#select-branch').val();
				} else {
					superBranchCode = '';
				}
				
				$.doPost({
					url	 	: "/admin/getUserList",
					data 	: {
						userIdOrName	: userIdOrName,
						phoneNumber		: phoneNumber,
						startDate		: '2023-06-01',
						endDate			: '2023-08-01',
						super_branch_code : 'b0001'
						
					},
					success	: function(result) {
						statusGrid.resetData(result.userList);
					},
					error	: function(xhr,status){
						alert('오류가 발생했습니다.');
					}
				});
			},
	}; //ajaxCom END
	
	//이벤트 객체 : id값을 주면 클릭 이벤트 발생
	btnCom = {
		btn_download: function(){
			console.log('다운로드 클릭')
		}
	}; //btnCom END

	//기타 함수 객체
	fnCom = {
		reservationChange: function(props, rowKey){
			console.log('reservationChange 클릭', props.grid.getRow(rowKey))
		},
		reservationCancle: function(props, rowKey){
			console.log('reservationCancle 클릭', props.grid.getRow(rowKey))
		},
		sendMsg: function(props, rowKey){
			console.log('sendMsg 클릭', props.grid.getRow(rowKey))
		}
	}; //fnCom END
	
	const statusGrid = tuiGrid.createGrid(
		//그리드 옵션
		{
			gridId : 'reservation_status_grid',
			height : 540,
			scrollX : true,
			scrollY : true,
			readOnlyColorFlag : false,
			rowHeaders: ['rowNum'],
			rowHeight : 32,
			minRowHeight : 25,
			columns: [
				{header : '예약날짜',				name : 'id',			width : 100,  align:'left',	sortable: true},
				{header : '예약시간',				name : 'name',				width : 150, align:'left', sortable: true},
				{header : '이름',					name : 'phone_number',		width : 150, align:'left', sortable: true},
				{header : '예약변경',		name : 'change',	width : 150, align:'center', 
					renderer: {
						type : ButtonRenderer,
						options : {
							value : '변경',
							click: fnCom.reservationChange
						}
					}
				},
				{header : '예약취소',		name : 'cancle',	width : 150, align:'center',
					renderer: {
						type : ButtonRenderer,
						options : {
							value : '취소',
							click: fnCom.reservationCancle
						}
					}
				},
				{header : '문자 발송',			name : 'sendMsg',	width : 150, align:'center',
					renderer: {
						type : ButtonRenderer,
						options : {
							value : '발송',
							click: fnCom.sendMsg
						}
					}
				},
				{header : '발송 성공 여부',			name : 'sendMsgStatus',	align:'left', sortable: true, 
					editor: { type: 'select', options: { listItems: [{text:'YES', value:'Y'},{text:'NO',value:'N'}]}}
				
				}
			]
		},
		[],//초기 데이터
		//이벤트
		{
			cellclick : function(rowKey,colName,grid){
				
			}
		}
	);
	

	
	ajaxCom.getUserList();
}); //END $(document).ready
	
</script>

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
											<span class="row-title">예약 현황 조회</span>
										</div>
										<div class="col-sm-6">
											<div class="button-list float-right">
												<button type="button" id="btn_get" class="header-btn btn btn-secondary float-left ml-2 mb-2">조회</button>
												<button type="button" id="btn_download" class="header-btn btn btn-secondary float-left ml-2 mb-2">다운로드</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<table class="table-sm mt-1 mb-2" style="border-top: 1px lightgray solid; border-bottom: 1px lightgray solid;">
								<tbody>
									<tr>
										<th>조회기간</th>
										<td colspan="6">
											<div class="row ml-1">
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_day" name="searchRange" class="custom-control-input">
													<label class="custom-control-label" for="radio_day">일</label>
												</div>
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_week" name="searchRange" class="custom-control-input">
													<label class="custom-control-label" for="radio_week">주</label>
												</div>
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_month" name="searchRange" class="custom-control-input">
													<label class="custom-control-label" for="radio_month">월</label>
												</div>
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_year" name="searchRange" class="custom-control-input">
													<label class="custom-control-label" for="radio_year">년</label>
												</div>
												
												<div class="custom-control custom-radio custom-control-inline">
													<input type="radio" id="radio_picker" name="searchRange" class="custom-control-input">
													<label class="custom-control-label" for="radio_picker">기간선택</label>
													<div class="tui-datepicker-input tui-datetime-input ml-1">
														<input id="input_startDate" type="text" aria-label="Date">
														<span class="tui-ico-date"></span>
														<div id="startDate-container" style="margin-left: -1px;"></div>
													</div>
													<span class="m-t-1"> ~ </span>
													<div class="tui-datepicker-input tui-datetime-input">
														<input id="input_endDate" type="text" aria-label="Date">
														<span class="tui-ico-date"></span>
														<div id="endDate-container" style="margin-left: -1px;"></div>
													</div>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>이름 / 아이디</th>
										<td><input type="text" id="input_id_name" class="form-control form-control-sm" style="width:75%;height:15%"/></td>
										<th>전화번호</th>
										<td><input type="text" id="input_phone" class="form-control form-control-sm" style="width:75%;height:15%"/></td>
										<th>비고</th>
										<td><input type="text" id="input_comment" class="form-control form-control-sm" style="width:75%;height:15%"/></td>
									</tr>
								</tbody>
							</table>
							
							<!-- Grid -->
							<div class="col-md-12">
								<div id="reservation_status_grid"></div>
							</div>
								
						</div>
					</div>
				</div>	
			</div>
		</div>
	</div>
</div>