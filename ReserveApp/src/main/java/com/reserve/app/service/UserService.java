package com.reserve.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reserve.app.mapper.UserMapper;
import com.reserve.app.util.SHA512PasswordEncoder;

@Service
@Transactional
public class UserService {

	@Autowired
	private UserMapper mapper;
	
	// 개인 정보 가져오기
	public List<Map<String, Object>> getUserInfo(Map<String,Object> param){
		return mapper.getUserInfo(param);
	}
	
	// 개인 정보 변경
	public String updateUserInfo(HashMap<String, Object> param) {
		String msg = "success";
		
		try {
			mapper.updateUserInfo((Map<String,Object>) param);
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	// 기존 비밀번호 확인
	public int checkOrgPwd(Map<String,Object> org_pwd) {
		int pwdCnt = mapper.checkOrgPwd(org_pwd);
		System.out.println("checkOrgPwd(service): " + pwdCnt);	//test
		return pwdCnt;
	}
	// 비밀번호 변경
	public String updateUserPwd(Map<String,Object> new_pwd) {
		String msg = "success";
		
		try {
			String orgPassword = new_pwd.get("password").toString();
			System.out.println("새로운 비밀 번호 : " + orgPassword);		//test
			SHA512PasswordEncoder sha512Service = new SHA512PasswordEncoder();
			String encPassword = sha512Service.encode(orgPassword);
			new_pwd.put("encoded_password", encPassword);
			
			mapper.updateUserPwd((Map<String,Object>) new_pwd);
			System.out.println("updateUserPwd_service: " + msg);	//test
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	
}
