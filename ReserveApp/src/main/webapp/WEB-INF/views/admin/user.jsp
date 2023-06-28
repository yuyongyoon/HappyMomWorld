<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
let _comCode = {};

//그리드 내 셀렉트박스 옵션 가져오는 fn
// cfn_getComCodeList([
// 	{code:"user_role"},
// 	{code:"use_yn"},
// 	{code:"calendar"},
// ]);

$(document).ready(function() {
	//콤보박스 가져오기
// 	cfn_setCombo([
// 		{id:'select_userRole', data:_comCode.user_role},
// 		{id:'select_calendar', data:_comCode.calendar}
// 	]);
	
	cfn_gridResize('user_grid',250); //그리드 위치 조절
	
	//서버 통신 객체
	ajaxCom = {
		getUserList : function() {
			let userId = $("#input_id").val();
			let userNm = $("#input_name").val();
			$.doPost({
				url	 : "/admin/getUserList",
				data : {
					id   : userId,
					name : userNm
				},
				success		: function(result) {
					console.log(result.userList)
					console.log(userGrid)
					userGrid.resetData(result.userList);
				},
				error		: function(xhr,status){
					alert("오류가 발생했습니다.");
				}
			});
		},
		//정보 변경
		updateUserList : function(updateData) {
			$.doPost({
				url	 : "/admin/updateUserList",
				data : {
					updated_list : updateData
				},
				success		: function(result){
					if (result.msg === "success") {
						alert("저장되었습니다.");
						ajaxCom.getUserList();
					} else {
						alert("오류가 발생했습니다.");
					}
				},
				error		: function(xhr,status) {
					alert("error!");
				}
			});
		},
		//Id 중복검사
		validateId : function(idVal) {
			$.doPost({
				url	 : "/admin/validateId",
				data : { id : idVal },
				success		: function(result) {
					if (result.msg == "retry") {
						alert(idVal + "는 사용할 수 없습니다. 다시 입력해주세요.");
						$(idVal).val("");
						return;
					} else {
						$("#id").attr("disabled", true);
						$("#checkId").html("사용 가능한 ID 입니다.");
						$("#checkId").css("color", "blue");
					}
				},
				error		: function(xhr,status){
					alert("error!");
				}
			});
		},
		//사용자 추가
		addUser : function() {
			$.doPost({
				url	 : "/admin/addUser",
				data : {
					id			: $("#id").val(),
					name 		: $("#name").val(),
					user_role 	: $("#select_userRole option:selected").val(),
					password 	: $("#password1").val(),
					remark 		: $("#remark").val(),
					calendar 	: $("#select_calendar option:selected").val()
				},
				success		: function(result) {
					if (result.msg === "success") {
						alert('저장되었습니다.');
						fnCom.signupInputClean();
						flag = false;
						ajaxCom.getUserList();
					} else {
						alert("오류가 발생했습니다.");
					}
				},
				error		: function(xhr,status){
					alert("error!");
				}
			});
		},
		//비밀번호 변경
		updatePwd : function() {
			$.doPost({
				url	 : "/admin/updatePwd",
				data : {
					id 			: $("#chg-form-id").val(),
					oldPassword : $('#chg-form-oldPwd').val(),
					newPassword : $('#chg-form-newPwd1').val()
				},
				success		: function(result){
					if (result.msg === "success") {
						alert("비밀번호가 변경되었습니다.");
						fnCom.chgPwdInputClean();
						ajaxCom.getUserList();
						
					} else if (result.msg === "password mismatch") {
						alert("기존 비밀번호를 확인해주세요.");
						fnCom.chgPwdInputClean();
						$( "#dialog-chg-form" ).dialog( "open" );
						return;
					} else {
						alert("오류가 발생했습니다.");
						return;
					}
				},
				error		: function(xhr,status){
					alert("error!");
				}
			});
		}

	}; //ajaxCom END
	
	//버튼 클릭 이벤트 객체
	btnCom = {
		//조회
		btn_get : function() {
			ajaxCom.getUserList()
		},
		//사용자 추가
		btn_add : function() {
			dialog.dialog( "open" );
		},
		//저장 버튼
		btn_save : function() {
			let updateData = tuiGrid.getModifiedData(userGrid);

			if (updateData.length === 0){
				alert("수정할 데이터가 없습니다.");
				return;
			}
			
			//통신
			ajaxCom.updateUserList(updateData)
		}
	}// END btnCom
	
	//기타 함수 객체
	fnCom = {
		//사용자 추가 dialog input 박스 비우는 fn
		signupInputClean : function() {
				$("#dialog-form").find("input").val("");
				$("#dialog-form").find("textarea").val("");

				$("#checkId").html("");
				$("#checkPwd").html("");
				$("#id").attr("disabled", false);
		},
		//비밀번호 변경 dialog input 박스 비우는 fn
		chgPwdInputClean : function() {
			$("#chg-form-oldPwd").val("");
			$("#chg-form-newPwd1").val("");
			$("#chg-form-newPwd2").val("");
			$('#chg-form-checkPwd').html("");
		},
		//비밀번호 초기화
		resetPwd : function() {
			$.doPost({
				url	 : "/admin/resetPwd",
				data : {
					id : $("#chg-form-id").val()
				},
				success		: function(result){
					if (result.msg === "success") {
						alert('비밀번호가 1로 초기화 되었습니다.');
						$( "#dialog-chg-form" ).dialog("close");
					} else {
						alert("오류가 발생했습니다.");
					}
				},
				error		: function(xhr,status) {
					alert("error!");
				}
			});
		}
	};//END fnCom
	
	const userGrid = tuiGrid.createGrid(
		//그리드 옵션
		{
			gridId : 'user_grid',
			height : 600,
			readOnlyColorFlag : false,
			columns: [
				{header : 'ID',			name : 'id',		  width : 200,  align:'left'},
				{header : '사용자명',		name : 'name',		  width : 100,  align:'center'},
// 				{header : '권한',			name : 'user_role',	  width : 100,  align:'center', formatter: 'listItemText', style:'cursor:pointer;',
// 					editor: { type: 'select', options: { listItems: _comCode.user_role } }
// 				},
// 				{header : '캘린더',		name : 'calendar',	  width : 150,  align:'center', formatter: 'listItemText', style:'cursor:pointer;',
// 					editor: { type: 'select', options: { listItems: _comCode.calendar } }
// 				},
// 				{header : '사용여부',		name : 'user_status', width : 100,  align:'center', formatter: 'listItemText', style:'cursor:pointer;',
// 					editor: { type: 'select', options: { listItems: _comCode.use_yn } }
// 				},
				{header : '비밀번호 변경일',name : 'pswd_chg_dt', width : 150,  align:'center', style:'cursor:pointer;text-decoration:underline;' },
				{header : '등록일',		name : 'created_dt',  width : 100,  align:'center'},
				{header : '비고',			name : 'remark',	align:'left', 	editor:'text'}
			]
		},
		[],//초기 데이터
		//이벤트
		{
			cellclick : function(rowKey,colName,grid){
				if(colName=="pswd_chg_dt"){
					let row = grid.getRow(rowKey);
					let selectedId = row.id
					$("#chg-form-id").val(selectedId);
					$("#dialog-chg-form").dialog( "open" );
				}
			}
		}
	);
	
	let flag = false;
	$("#checkId").css('color', 'red');
	
	//id 확인 fn
	$("#id").keyup(function() {
		$("#checkId").html("ID 확인 버튼을 클릭해주세요");
	});
	
	//사용자 추가에서 비밀번호 일치 확인 fn
	$("#password2").keyup(function() {
		if ($("#password1").val() === $("#password2").val()) {
			$("#checkPwd").html("비밀번호 일치");
			$("#checkPwd").css("color", "blue");
		} else {
			$("#checkPwd").html("비밀번호 불일치");
			$("#checkPwd").css("color", "red");
		}
	});
	
	//비밀번호 변경에서 비밀번호 일치 확인 fn
	$("#chg-form-newPwd2").keyup(function() {
		if ($("#chg-form-newPwd1").val() === $("#chg-form-newPwd2").val()) {
			$("#chg-form-checkPwd").html("비밀번호 일치");
			$("#chg-form-checkPwd").css("color", "blue");
		} else {
			$("#chg-form-checkPwd").html("비밀번호 불일치");
			$("#chg-form-checkPwd").css("color", "red");
		}
	});
	
	//사용자 추가 dialog
	dialog = $( "#dialog-form" ).dialog({
		autoOpen		: false,
		height			: 480,
		width			: 320,
		modal			: true,
		resizable		:false,
		closeOnEscape	: false,
		buttons	: {
			"ID 확인" : function() {
				flag = false;
				let idVal = $("#id").val();
				if (idVal === "") {
					alert("ID를 입력해주세요");
					return;
				} else {
					flag = true;
					ajaxCom.validateId(idVal);
				}
			},
			"생성": function() {
				if ( $("#id").val() == "" || $("#name").val() == "" || $("#password1").val() == "" || $("#password2").val() == "" ) {
						alert("필수 항목 값을 입력해주세요.");
						return;
					}
				
				if ($("#password1").val() != $("#password2").val()) {
					alert("비밀번호를 확인해주세요.");
					return;
				}
				
				
				if (flag === false) {
					alert("ID 확인 버튼을 클릭해주세요.");
					return;
				}
				
				ajaxCom.addUser();

				$(this).dialog("close");
			},
			"취소": function() {
				flag = false;
				fnCom.signupInputClean();
				$("#id").attr('disabled', false);
				$(this).dialog("close");
			}
		}
	});

//비밀번호 변경 dialog + 초기화 버튼 
$( "#dialog-chg-form" ).dialog({
		autoOpen: false,
		height: 290,
		width: 320,
		modal: true,
		resizable:false,
		closeOnEscape: false,
		buttons: {
			"변경": function() {
				if ( $("#chg-form-id").val() == "" || $("#chg-form-oldPwd").val() == "" || $("#chg-form-newPwd1").val() == "" || $("#chg-form-newPwd2").val() == "") {
					alert("필수 항목 값을 입력해주세요.");
					return;
				}
			
				if ($("#chg-form-newPwd1").val() != $("#chg-form-newPwd2").val()) {
					alert("비밀번호를 확인해주세요.");
					return;
				}
				
				let code = $('#input_code').val();
				let codeName = $('#input_code_name').val();

				ajaxCom.updatePwd();

				$( "#dialog-chg-form" ).dialog("close");
			},
			"취소": function() {
				fnCom.chgPwdInputClean();
				$(this).dialog("close");
			},
			"비밀번호 초기화": function() {
				fnCom.resetPwd();
			}
		},
	});
	

	ajaxCom.getUserList();
}); //END $(document).ready

</script>
<div class="content-wrap">
	<div class="main">
		<div class="container-fluid">
			<section id="main-content">
				<div class="row">
					<div class="col-lg-12">
						<div class="card">
							<div class="card-title">
								<h3 class="float-left">사용자 관리</h3>
								<div class="button-list float-right">
									<button id="btn_get" type="button" class="btn btn-default m-b-10 m-l-5 float-left">조회</button>
									<button id="btn_add" type="button" class="btn btn-default m-b-10 m-l-5 float-left">추가</button>
									<button id="btn_save" type="button" class="btn btn-default m-b-10 m-l-5 float-left">저장</button>
								</div>
							</div>
							<div class="card-body">
								<div class="row search">
									<div class="col-sm-3">
										<span class="search-label float-left">ID</span>
										<input type="text" id="input_id" class="form-control form-control-sm" placeholder="ID를 입력해주세요"/>
									</div>
									<div class="col-sm-3">
										<span class="search-label float-left">사용자명</span>
										<input type="text" id="input_name" class="form-control form-control-sm" placeholder="사용자명을 입력해주세요"/>
									</div>
								</div>
								<div id="user_grid"></div>
							</div>
						</div>
					</div>
				</div>
			</section>
		</div>
	</div>
</div>

<div id="dialog-form" title="사용자 추가">
	<form>
		<div>
			<div class="form-group m-b-3">	
				<label for="id" class="popup-form-label">ID</label>
				<input type="text" id="id" class="form-control form-control-sm popup-form-input">
			</div>
			<div class="form-group-span">
				<span id="checkId" class="popup-form-span"></span>
			</div>
			<div class="form-group m-b-3">
				<label for="name" class="popup-form-label">사용자명</label>
				<input type="text" id="name" class="form-control form-control-sm popup-form-input">
				</div>
<!-- 			<div class="form-group m-b-3"> -->
<!-- 				<label for="user_role" class="popup-form-label">권한</label> -->
<!-- 				<select id="select_userRole" class="form-control form-control-sm popup-form-select"> -->
<!-- 				</select> -->
<!-- 			</div> -->
<!-- 			<div class="form-group m-b-3"> -->
<!-- 				<label for="calendar" class="popup-form-label">캘린더 범위</label> -->
<!-- 				<select id="select_calendar" class="form-control form-control-sm popup-form-select"> -->
<!-- 				</select> -->
<!-- 			</div> -->
			<div class="form-group m-b-3">
				<label for="password1" class="popup-form-label">비밀번호</label>
				<input type="password" id="password1" class="form-control form-control-sm popup-form-input">
			</div>
			<div class="form-group m-b-3">
				<label for="password2" class="popup-form-label">비밀번호 확인</label>
				<input type="password" id="password2" class="form-control form-control-sm popup-form-input">
			</div>
			<div class="form-group-span">
				<span id="checkPwd" class="popup-form-span"></span>
			</div>
			<div class="form-group m-b-3">
				<label for="remark" class="popup-form-label">비고</label>
				<textarea id="remark" cols="30" rows="4" class="popup-form-textarea"></textarea><br>
			</div>
		</div>
	</form>
</div>

<style>
#remark {
	resize: none;
}
</style>

<div id="dialog-chg-form" title="비밀번호 변경">
	<form>
		<div>
			<div class="form-group m-b-3">
				<label for="chg-form-id" class="popup-form-label">ID</label>
				<input type="text" id="chg-form-id" class="form-control form-control-sm popup-form-input" disabled>
			</div>
			<div class="form-group m-b-3">
				<label for="chg-form-oldPwd" class="popup-form-label">이전 비밀번호</label>
				<input type="password" id="chg-form-oldPwd" class="form-control form-control-sm popup-form-input">
			</div>
			<div class="form-group m-b-3">
				<label for="chg-form-newPwd1" class="popup-form-label">새 비밀번호</label>
				<input type="password" id="chg-form-newPwd1" class="form-control form-control-sm popup-form-input">
				</div>
			<div class="form-group m-b-3">
				<label for="chg-form-newPwd2" class="popup-form-label">비밀번호 확인</label>
				<input type="password" id="chg-form-newPwd2" class="form-control form-control-sm popup-form-input">
			</div>
			<div class="form-group-span">
				<span id="chg-form-checkPwd" class="popup-form-span"></span>
			</div>
		</div>
	</form>
</div>