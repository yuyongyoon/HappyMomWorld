package com.reserve.app.service;

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


	public List<Map<String, Object>> getBranchList(Map<String,Object> param){
		return mapper.getBranchList(param);
	}
	
	@SuppressWarnings("unchecked")
	public String saveBranchInfo(Map<String,Object> param) {
		String msg = "success";
		
		List<Map<String,Object>> branchList = (List<Map<String,Object>>)param.get("data");

		try {
			for (Map<String,Object> branchData : branchList) {
				if (branchData.get("status").equals("i")) {
					int p1 = (int)(Math.random() * 10);
					int p2 = (int)(Math.random() * 10);
					char p3 = (char)((int)(Math.random()*26)+97);
					char p4 = (char)((int)(Math.random()*26)+97);
					String joinCode = "@" + p3 + Integer.toString(p1) + p4 + Integer.toString(p2);
					
					branchData.put("join_code", joinCode);
					mapper.addBranchInfo(branchData);
				} else if (branchData.get("status").equals("u")) {
					mapper.updateBranchInfo(branchData);
				} else {
					mapper.deleteBranchInfo(branchData);
				}
			}
		} catch (Exception e) {
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
	
	public List<Map<String, Object>> getReservationMasterData(Map<String,Object> param){
		return mapper.getReservationMasterData(param);
	}
	
	@SuppressWarnings("unchecked")
	public String saveReservationMasterData(Map<String,Object> param) {
		String msg = "success";
		try {
			List<Map<String,Object>> saveReservationMasterData = (List<Map<String,Object>>)param.get("data");
			Map<String,Object> delInfo = (Map<String,Object>)param.get("delInfo");
			Map<String,Object> branchReservationInfo = (Map<String,Object>)param.get("branchReservationInfo");
			
			mapper.deleteReservationMasterData(delInfo);
			mapper.addReservationMasterData(saveReservationMasterData);
			mapper.addbranchReservationInfo(branchReservationInfo);
		} catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}

	public Map<String, Object> getBranchReservationInfo(Map<String, Object> param) throws Exception {
		int cntBranchReservationInfo = mapper.getCntBranchReservationInfo(param);
		
		if(cntBranchReservationInfo == 0) {
			param.put("rsv_month", "2023-00"); //기본값 하드코딩
			return mapper.getBranchReservationInfo(param);
		} else {
			return mapper.getBranchReservationInfo(param);
		}
	}
	
	public String saveBranchReservationInfo(Map<String,Object> param) {
		String msg = "success";
		
		try {
			int branchReservationInfo = mapper.getCntbranchReservationInfo(param);
			
			if(branchReservationInfo > 0) {
				mapper.updatebranchReservationInfo(param);
			} else {
				mapper.addbranchReservationInfo(param);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
}