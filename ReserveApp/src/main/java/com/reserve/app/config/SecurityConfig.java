package com.reserve.app.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.reserve.app.CustomAuthenticationProvider;
import com.reserve.app.service.LoginService;



@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
	
	@Autowired
	LoginService loginService;
	
	@Autowired
	AuthenticationFailureHandler loginFailureHandler;
	
	@Autowired
	AuthenticationSuccessHandler loginSuccessHandler;
	
	@Autowired
	private CustomAuthenticationProvider authProvider;
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http
			.authorizeRequests()
				.antMatchers("/admin//dashboard").hasAnyRole("ADMIN", "SUPERADMIN")
				.antMatchers("/admin/user").hasAnyRole("ADMIN", "SUPERADMIN")
				.antMatchers("/admin/reservation_status").hasAnyRole("ADMIN", "SUPERADMIN")
				.antMatchers("/admin//admin/reservation_master").hasAnyRole("ADMIN", "SUPERADMIN")
				.antMatchers("/admin//admin/branch_master").hasAnyRole("ADMIN", "SUPERADMIN")
				.antMatchers("/admin/branch_manager").hasAnyRole("SUPERADMIN")
				.antMatchers("/login").permitAll()
				.antMatchers("/join/**").permitAll()
				.antMatchers("/static/**").permitAll()
				.anyRequest().authenticated()
			.and()
				.formLogin()
				.loginPage("/login")
				.loginProcessingUrl("/loginProc")
				.usernameParameter("id")
				.passwordParameter("password")
				.successHandler(loginSuccessHandler)
				.failureHandler(loginFailureHandler)
				.permitAll()
			.and()
				.logout()
				.logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
				.logoutSuccessUrl("/login")
				.invalidateHttpSession(true)
			.and()
			.exceptionHandling()
			.authenticationEntryPoint((request, response, authException) -> {
				response.sendRedirect("/login");
			})
			;
		
		//remember 기능
		http.rememberMe() //사용자 계정 저장
				.rememberMeParameter("rememberme")
				.tokenValiditySeconds(86400 * 30) //30일
				.alwaysRemember(false)
				.userDetailsService(loginService);
		
		http.csrf().disable();
	}
	
	@Override
	public void configure(WebSecurity web) throws Exception {
		web.ignoring().antMatchers("/static/**");
	}
	
	@Override
	public void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.authenticationProvider(authProvider);
	}
}