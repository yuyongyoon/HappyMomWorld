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

import com.reserve.app.entity.LoginEntity;
import com.reserve.app.mapper.LoginMapper;
import com.reserve.app.util.SHA512PasswordEncoder;

@Service
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
}