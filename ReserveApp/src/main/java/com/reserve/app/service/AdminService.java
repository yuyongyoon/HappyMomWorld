package com.reserve.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	
	public List<Map<String,Object>> getUserList(Map<String,Object> param) {
		return mapper.getUserList(param);
	}
	
	public Map<String, Object> resetPassword(Map<String, Object> param) throws Exception {
		SHA512PasswordEncoder sha512Service = new SHA512PasswordEncoder();
		Map<String, Object> resetPwd = new HashMap<String, Object>();
		
		// 4자리 초기화 번호 생성
		int p1 = (int)(Math.random() * 10);
		int p2 = (int)(Math.random() * 10);
		int p3 = (int)(Math.random() * 10);
		int p4 = (int)(Math.random() * 10);
			
		char p5 = (char)((int)(Math.random()*26)+97);
		char p6 = (char)((int)(Math.random()*26)+97);
		char p7 = (char)((int)(Math.random()*26)+65);
		char p8 = (char)((int)(Math.random()*26)+65);
			
		String pwd = "@" + p5 + Integer.toString(p1) + p6+ p7 + Integer.toString(p2) + Integer.toString(p3) + p8 + Integer.toString(p4);
		
		//암호화 
		String encodePwd = sha512Service.encode(pwd);

		//인코딩 체크
		String rawPassword = pwd;
		
		param.put("raw_pw", rawPassword);
		param.put("user_pw", encodePwd);

		mapper.resetPassword(param);
		
		//초기화 번호만 리턴 return
		resetPwd.put("raw_pw", param.get("raw_pw"));
		
		return resetPwd;
	}
	
	public String addAccount(Map<String,Object> param) {
		String msg = "success";
		
		try {
			String orgPassword = param.get("password").toString();
			SHA512PasswordEncoder sha512Service = new SHA512PasswordEncoder();
			String encPassword = sha512Service.encode(orgPassword);
			param.put("encoded_password", encPassword);
			
			mapper.addAccount((Map<String,Object>) param);
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
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

	public int checkId(Map<String,Object> param) {
		int idCnt = mapper.checkId(param);
		return idCnt;
	}
}
