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
	
	public Map<String,Object> checkId(HashMap<String, Object> param) {
		Map<String,Object> result = new HashMap<String,Object>();
		int idCnt = mapper.checkId(param);
		System.out.println("중복 아이디 수: "+idCnt);
		
		if(idCnt < 1) {
			result.put("msg", "success");
		}else {
			result.put("msg", "fail");
		}
		return result;
	}
	
	public String addBranchInfo(HashMap<String, Object> param) {
		String msg = "success";
		
		try {
			String pwd = param.get("password").toString();
			SHA512PasswordEncoder sha512Service = new SHA512PasswordEncoder();
			
			String encpwd = sha512Service.encode(pwd);
			param.put("encpwd", encpwd);
			
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
			
			mapper.deleteReservationMasterData(delInfo);
			mapper.addReservationMasterData(saveReservationMasterData);
		} catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}

	public Map<String, Object> getBranchReservationInfo(Map<String, Object> param) throws Exception {
		return mapper.getBranchReservationInfo(param);
	}
	
	public List<Map<String, Object>> getCalendarEvent(Map<String,Object> param){
		return mapper.getCalendarEvent(param);
	}
	
	public List<Map<String, Object>> getRsvUserList(Map<String,Object> param){
		return mapper.getRsvUserList(param);
	}
	
	public Map<String, Object> getSeletedDateReservationList(Map<String,Object> param){
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
	
	public List<Map<String, Object>> getNonConfirmData(Map<String, Object> param) throws Exception {
		return mapper.getNonConfirmData(param);
	}
	
	public List<Map<String, Object>> getReservationList(Map<String, Object> param) throws Exception {
		param.put("timeSlots", Arrays.asList("1", "2", "3", "4", "5", "6", "7", "8", "9", "10"));
		return mapper.getReservationList(param);
	}
	
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
	
	public Map<String,Object> getMainUrl(Map<String,Object>param) throws Exception{
		return mapper.getMainUrl(param);
	}
	
	public String updateUrl(Map<String,Object> param){
		String msg = "success";
		try {
			mapper.updateUrl(param);
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
}