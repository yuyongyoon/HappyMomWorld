package com.reserve.app.service;

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
	public Map<String, Object> getUserInfo(Map<String,Object> param){
		return mapper.getUserInfo(param);
	}
	
	// 개인 정보 변경
	public String updateUserInfo(Map<String, Object> param) {
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
//	public int checkOrgPwd(Map<String,Object> org_pwd) {
//		int pwdCnt = mapper.checkOrgPwd(org_pwd);
//		System.out.println("checkOrgPwd(service): " + pwdCnt);	//test
//		return pwdCnt;
//	}
	// 비밀번호 변경
	public String updateUserPwd(Map<String,Object> param) {
		String msg = "success";
		
		try {
			String orgPassword = param.get("org_pwd").toString();
			String newPassword = param.get("new_pwd").toString();
			
			SHA512PasswordEncoder sha512Service = new SHA512PasswordEncoder();
			String encOrgPassword = sha512Service.encode(orgPassword);
			String encNewPassword = sha512Service.encode(newPassword);
			
			param.put("encOrgPassword", encOrgPassword);
			param.put("encNewPassword", encNewPassword);
			
			//기존 비밀번호 확인
			int pwdCnt = mapper.checkOrgPwd(param);
			if(pwdCnt != 1) {
				msg = "not found Pwd";
			} else {
				mapper.updateUserPwd(param);
			}
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	// 예약 리스트 가져오기
	public List<Map<String, Object>> getReservation(Map<String,Object> param){
		return mapper.getReservation(param);
	}
	// 기간별 예약 조회
	public List<Map<String, Object>> searchRsv(Map<String,Object> param){
		return mapper.searchRsv(param);
	}
}
