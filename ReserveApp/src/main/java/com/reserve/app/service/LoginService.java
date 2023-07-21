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
	
	public Map<String,Object> signup(Map<String,Object> param) {
		Map<String,Object> result = new HashMap<String,Object>();
		try {
			String orgPassword = param.get("password").toString();
			SHA512PasswordEncoder sha512Service = new SHA512PasswordEncoder();
			String encPassword = sha512Service.encode(orgPassword);
			param.put("encoded_password", encPassword);

			int codeCnt = checkCode(param);
			
			if(codeCnt < 1) {
				result.put("msg", "notFoundCode");
			} else {
				mapper.signup((Map<String,Object>) param);
				result.put("msg", "success");
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "fail");
		}
		return result;
	}

	public Map<String,Object> checkId(HashMap<String, Object> param) {
		Map<String,Object> result = new HashMap<String,Object>();
		int idCnt = mapper.checkId(param);
		System.out.println("idCnt :"+idCnt);
		
		if(idCnt < 1) {// 아이디 중복X
			result.put("msg", "success");
		}else {
			result.put("msg", "fail");
		}
		return result;
	}

	public int checkCode(Map<String,Object> param) {
		int codeCnt = mapper.checkCode(param);
		return codeCnt;
	}
}