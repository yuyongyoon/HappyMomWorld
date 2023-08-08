package com.reserve.app.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.postgresql.util.PSQLException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reserve.app.mapper.AdminMapper;
import com.reserve.app.util.SHA512PasswordEncoder;

@Service
@Transactional
public class AdminService {

	@Autowired
	private AdminMapper mapper;
	
	public List<Map<String, Object>> getBranchNameList(Map<String,Object> param){
		return mapper.getBranchNameList(param);
	}
	
	public List<Map<String,Object>> getUserList(Map<String,Object> param) {
		return mapper.getUserList(param);
	}
	
	public Map<String, Object> resetPassword(Map<String, Object> param) throws Exception {
		SHA512PasswordEncoder sha512Service = new SHA512PasswordEncoder();
		Map<String, Object> resetPwd = new HashMap<String, Object>();
		
		int p1 = (int)(Math.random() * 10);
		int p2 = (int)(Math.random() * 10);
		int p3 = (int)(Math.random() * 10);
		int p4 = (int)(Math.random() * 10);
			
		char p5 = (char)((int)(Math.random()*26)+97);
		char p6 = (char)((int)(Math.random()*26)+97);
		char p7 = (char)((int)(Math.random()*26)+65);
		char p8 = (char)((int)(Math.random()*26)+65);
			
		String pwd = "@" + p5 + Integer.toString(p1) + p6+ p7 + Integer.toString(p2) + Integer.toString(p3) + p8 + Integer.toString(p4);
		
		String encodePwd = sha512Service.encode(pwd);

		String rawPassword = pwd;
		
		param.put("raw_pw", rawPassword);
		param.put("user_pw", encodePwd);

		mapper.resetPassword(param);
		resetPwd.put("raw_pw", param.get("raw_pw"));
		
		return resetPwd;
	}
	
	public String updateAccount(HashMap<String, Object> param) {
		String msg = "success";
		
		try {
			mapper.updateAccount((Map<String,Object>) param);
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	// ===================== 지점 관리  =====================
	public List<Map<String, Object>> getBranchList(Map<String,Object> param){
		return mapper.getBranchList(param);
	}
	
	/*
	 * @SuppressWarnings("unchecked") public String
	 * saveBranchInfo(Map<String,Object> param) { String msg = "success";
	 * 
	 * List<Map<String,Object>> branchList =
	 * (List<Map<String,Object>>)param.get("data");
	 * 
	 * try { for (Map<String,Object> branchData : branchList) { if
	 * (branchData.get("status").equals("i")) { int p1 = (int)(Math.random() * 10);
	 * int p2 = (int)(Math.random() * 10); char p3 =
	 * (char)((int)(Math.random()*26)+97); char p4 =
	 * (char)((int)(Math.random()*26)+97); String joinCode = "@" + p3 +
	 * Integer.toString(p1) + p4 + Integer.toString(p2);
	 * 
	 * branchData.put("join_code", joinCode); mapper.addBranchInfo(branchData); }
	 * else if (branchData.get("status").equals("u")) {
	 * mapper.updateBranchInfo(branchData); } else {
	 * mapper.deleteBranchInfo(branchData); } } } catch (Exception e) {
	 * e.printStackTrace(); if (e.getCause() instanceof PSQLException) {
	 * PSQLException psqlException = (PSQLException) e.getCause(); String sqlState =
	 * psqlException.getSQLState(); if ("23505".equals(sqlState)) { String errorMsg
	 * = "지점 코드가 중복되었습니다. 지점 코드를 변경 후 다시 저장하세요."; msg = errorMsg; } else { msg =
	 * "fail"; } } else { msg = "fail"; } } return msg; }
	 */
	
	public Map<String,Object> checkId(HashMap<String, Object> param) {
		Map<String,Object> result = new HashMap<String,Object>();
		int idCnt = mapper.checkId(param);
		System.out.println("중복 아이디 수: "+idCnt);
		
		if(idCnt < 1) {// 아이디 중복X
			result.put("msg", "success");
		}else {
			result.put("msg", "fail");
		}
		return result;
	}
	
	public String addBranchInfo(HashMap<String, Object> param) {
		String msg = "success";
		
		try {
			// 비밀번호 암호화
			String pwd = param.get("password").toString();
			SHA512PasswordEncoder sha512Service = new SHA512PasswordEncoder();
			
			String encpwd = sha512Service.encode(pwd);
			param.put("encpwd", encpwd);
			
			// 가입 코드
			int p1 = (int)(Math.random() * 10);
			int p2 = (int)(Math.random() * 10);
			char p3 = (char)((int)(Math.random()*26)+97);
			char p4 = (char)((int)(Math.random()*26)+97);
			
			String joinCode = "@" + p3 + Integer.toString(p1) + p4 + Integer.toString(p2);
			param.put("join_code", joinCode);
			
			mapper.addBranchToMng((Map<String,Object>) param);
			mapper.addBranchToInfo((Map<String,Object>) param);
			mapper.addBranchToUser((Map<String,Object>) param);
			mapper.addBranchInToRsv((Map<String,Object>) param);
			
		}catch (Exception e) {
			e.printStackTrace();
			if (e.getCause() instanceof PSQLException) {
				PSQLException psqlException = (PSQLException) e.getCause();
				String sqlState = psqlException.getSQLState();
				if ("23505".equals(sqlState)) {
					String errorMsg = "지점 코드가 중복되었습니다. 지점 코드를 변경 후 다시 저장하세요.";
					msg = errorMsg;
				} else {
					msg = "fail";
				}
			} else {
				msg = "fail";
			}
		}
		return msg;
	}
	public String updateBranchInfo(HashMap<String, Object> param) {
		String msg = "success";
		
		try {
			mapper.updateBranchInfo((Map<String,Object>) param);
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	public Map<String, Object> resetMngPwd(Map<String, Object> param) throws Exception {
		SHA512PasswordEncoder sha512Service = new SHA512PasswordEncoder();
		Map<String, Object> resetPwd = new HashMap<String, Object>();
		
		int p1 = (int)(Math.random() * 10);
		int p2 = (int)(Math.random() * 10);
		int p3 = (int)(Math.random() * 10);
		int p4 = (int)(Math.random() * 10);
			
		char p5 = (char)((int)(Math.random()*26)+97);
		char p6 = (char)((int)(Math.random()*26)+97);
		char p7 = (char)((int)(Math.random()*26)+65);
		char p8 = (char)((int)(Math.random()*26)+65);
			
		String pwd = "@" + p5 + Integer.toString(p1) + p6+ p7 + Integer.toString(p2) + Integer.toString(p3) + p8 + Integer.toString(p4);
		
		String encodePwd = sha512Service.encode(pwd);

		String rawPassword = pwd;
		
		param.put("raw_pw", rawPassword);
		param.put("password", encodePwd);

		mapper.resetMngPwd(param);
		resetPwd.put("raw_pw", param.get("raw_pw"));
		
		return resetPwd;
	}
	
	public String updateManager(HashMap<String, Object> param) {
		String msg = "success";
		
		try {
			mapper.updateManager((Map<String,Object>) param);
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	public List<Map<String, Object>> getReservationMasterData(Map<String,Object> param){
		return mapper.getReservationMasterData(param);
	}
	
	@SuppressWarnings("unchecked")
	public String saveReservationMasterData(Map<String,Object> param) {
		String msg = "success";
		try {
			List<Map<String,Object>> saveReservationMasterData = (List<Map<String,Object>>)param.get("data");
			Map<String,Object> delInfo = (Map<String,Object>)param.get("delInfo");
//			Map<String,Object> branchReservationInfo = (Map<String,Object>)param.get("branchReservationInfo");
			
			mapper.deleteReservationMasterData(delInfo);
			mapper.addReservationMasterData(saveReservationMasterData);

//			int branchReservationInfoCnt = mapper.getCntBranchReservationInfo(branchReservationInfo);
			
//			if(branchReservationInfoCnt == 0) {
//				mapper.addbranchReservationInfo(branchReservationInfo);
//			} else if(branchReservationInfoCnt >= 1) {
//				mapper.updatebranchReservationInfo(branchReservationInfo);
//			}
		} catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}

	public Map<String, Object> getBranchReservationInfo(Map<String, Object> param) throws Exception {
//		int cntBranchReservationInfo = mapper.getCntBranchReservationInfo(param);
		
//		if(cntBranchReservationInfo == 0) {
//			param.put("rsv_month", "2023-00");
			return mapper.getBranchReservationInfo(param);
//		} else {
//			return mapper.getBranchReservationInfo(param);
//		}
	}
	
//	public String saveBranchReservationInfo(Map<String,Object> param) {
//		String msg = "success";
//		try {
//			int branchReservationInfo = mapper.getCntBranchReservationInfo(param);
//			
//			if(branchReservationInfo == 0) {
//				mapper.addbranchReservationInfo(param);
//			} else if(branchReservationInfo >= 1) {
//				mapper.updatebranchReservationInfo(param);
//			}
//			
//		} catch (Exception e) {
//			e.printStackTrace();
//			msg = "fail";
//		}
//		return msg;
//	}
	
	public List<Map<String, Object>> getCalendarEvent(Map<String,Object> param){
		return mapper.getCalendarEvent(param);
	}
	
	public List<Map<String, Object>> getSeletedDateReservationList(Map<String,Object> param){
		return mapper.getSeletedDateReservationList(param);
	}
	
	public Map<String,Object> getRsvLastMonth(Map<String,Object> param) {
		return mapper.getRsvLastMonth(param);
	}
	
	public List<Map<String,Object>> getRecentJoinData(Map<String,Object> param){
		return mapper.getRecentJoinData(param);
	}
	
	public List<Map<String,Object>> getRecentRsvData(Map<String,Object> param){
		return mapper.getRecentRsvData(param);
	}
	
	public List<Map<String,Object>> getNonRsvData(Map<String,Object> param){
		return mapper.getNonRsvData(param);
	}
	
	public Map<String, Object> getBranchInfo(Map<String, Object> param) throws Exception {
		return mapper.getBranchInfo(param);
	}
	
	public String saveBranchInfo(Map<String,Object> param) {
		String msg = "success";
		
		try {
			mapper.saveBranchInfo(param);
		} catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	
	public List<Map<String, Object>> getReservationStatusList(Map<String, Object> param) throws Exception {
		return mapper.getReservationStatusList(param);
	}
	
	public List<Map<String, Object>> getReservationModal(Map<String, Object> param) throws Exception {
		param.put("timeSlots", Arrays.asList("1", "2", "3", "4", "5", "6", "7", "8", "9", "10"));
		List<Map<String, Object>> result = mapper.getReservationModal(param);
		
		return result;
	}
	
	public List<Map<String, Object>> getUserReservationList(Map<String, Object> param) throws Exception {
		return mapper.getUserReservationList(param);
	}
	
	// 예약 변경
	public String updateReservation(Map<String,Object> param){ 
		String msg = "success";
		try {
			Map<String,Object> paramU = new HashMap<String,Object>();
			Map<String,Object> paramD = new HashMap<String,Object>();
			paramD.putAll(param);
			paramU.putAll(param);
			paramD.replace("rsv_date", param.get("pre_rsv_date"));
			paramD.replace("select_time", param.get("pre_select_time"));
			paramD.put("flag", "d");
			paramU.put("flag", "i");
			
			mapper.removeReservationByAdmin(paramD); 
			mapper.changeMagCnt(paramD);
			mapper.saveCancelLog(paramD); 
			mapper.updateReservationByAdmin(paramU);
			mapper.changeMagCnt(paramU);
			 
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	// 예약 취소
	public String removeReservationByAdmin(Map<String,Object> param){ 
		String msg = "success";
		try {
			mapper.removeReservationByAdmin(param);
			mapper.changeMagCnt(param);
			mapper.saveCancelLog(param);
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	
//	public Map<String,Object> getRecentlyBranchReservationInfo(Map<String,Object>param) throws Exception{
//		return mapper.getRecentlyBranchReservationInfo(param);
//	}
	
	public String updateRsvStatus(Map<String,Object> param){
		String msg = "success";
		try {
			mapper.updateRsvStatus(param);
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	
	public String saveMsgLog(Map<String,Object> param) {
		String msg = "success";
		
		try {
			int cnt = mapper.getMsgLogCnt(param);
			if(cnt > 0) {
				mapper.updateMsgLog(param);
			} else {
				mapper.saveMsgLog(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
}