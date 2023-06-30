package com.reserve.app;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.reserve.app.entity.LoginEntity;
import com.reserve.app.service.LoginService;


@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private LoginService loginService;


	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {

		String username = (String) authentication.getPrincipal();
		String password = (String) authentication.getCredentials();
		
		LoginEntity user = (LoginEntity) loginService.loadUserByUsername(username);
		
		System.out.println("CustomAuthenticationProvider username : " + username);
		System.out.println("CustomAuthenticationProvider password : " + user.getPassword());
		
		//패스워드 체크
		//password : 입력된 패스워드
		//user.getPassword() : 사용자 계정의 인코딩된 패스워드
		if (!isNotMatches(password, user.getPassword())){
			throw new BadCredentialsException(username);
		}
		
		//return new UsernamePasswordAuthenticationToken(user, password, user.getAuthorities());
		return new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());
	}
	
	@Override
	public boolean supports(Class<?> authentication) {
		//return true;
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}
	
	/**
	 * password : raw password
	 * encodePassword : encoded password
	 * */
	private boolean isNotMatches(String password, String encodePassword) {
		return passwordEncoder.matches(password, encodePassword);
	}
}