package com.reserve.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reserve.app.mapper.adminMapper;

@Service
@Transactional
public class adminService {
	
	@Autowired
	private adminMapper mapper;
	
	public List<Map<String,Object>> getUserList(Map<String,Object> param) {
		return mapper.getUserList(param);
	}
	
	public String addUser(HashMap<String,Object> param) {
		String msg = "success";
		
		try {
//			String orgPassword = param.get("password").toString();
//			SHA512PasswordEncoder sha512Service = new SHA512PasswordEncoder();
//			String encPassword = sha512Service.encode(orgPassword);
//			param.put("encoded_password", encPassword);
			mapper.addUser((HashMap<String,Object>) param);
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	
	@SuppressWarnings("unchecked")
	public String updateUserList(Map<String, Object> param) {
		String msg = "success";
		List<Map<String,Object>> updateUserList = (List<Map<String,Object>>)param.get("updated_list");

		try {
			for(Map<String,Object> userMap : updateUserList) {
				if(userMap.get("status").equals("u")) {
					mapper.updateUser(userMap);
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}

	public String validateId(HashMap<String,Object> param) {
		String msg = "success";
		try {
				if (mapper.validateId((HashMap<String,Object>) param) == 0) {
					msg = "okok";
				} else {
					msg = "retry";
				}
		} catch(Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
}
