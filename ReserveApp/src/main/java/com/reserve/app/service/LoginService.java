package com.reserve.app.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reserve.app.entity.LoginEntity;
import com.reserve.app.mapper.LoginMapper;
import com.reserve.app.util.SHA512PasswordEncoder;

@Service
@Transactional
public class LoginService implements UserDetailsService {
	
	@Autowired
	private LoginMapper mapper;

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new SHA512PasswordEncoder();
	}
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("id", username);
		
		LoginEntity loginEntity = mapper.getUserInfo(param);
		
		if (loginEntity == null ) {
			throw new UsernameNotFoundException("User not authorized.");
		}
		
		return loginEntity;
	}
	//회원 가입
	public String signup(Map<String,Object> param) {
		String msg = "success";
		
		try {
			String orgPassword = param.get("password").toString();
			SHA512PasswordEncoder sha512Service = new SHA512PasswordEncoder();
			String encPassword = sha512Service.encode(orgPassword);
			param.put("encoded_password", encPassword);
			
			mapper.signup((Map<String,Object>) param);
		}catch (Exception e) {
			e.printStackTrace();
			msg = "fail";
		}
		return msg;
	}
	//아이디 중복 확인
	public int checkId(Map<String,Object> param) {
		int idCnt = mapper.checkId(param);
		return idCnt;
	}
}