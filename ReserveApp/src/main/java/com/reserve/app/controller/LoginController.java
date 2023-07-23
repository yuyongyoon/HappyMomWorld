package com.reserve.app.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.reserve.app.service.LoginService;

@Controller
public class LoginController {

	@Autowired
	LoginService loginService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public void redirectUrl(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
		Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
		
		if (roles.contains("ROLE_ADMIN") || roles.contains("ROLE_SUPERADMIN")) {
			response.sendRedirect("/admin/dashboard");
		} else {
			response.sendRedirect("/user/calendar");
		}
	}

	// 로그인
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(@RequestParam(value = "error", required = false) String error,
			@RequestParam(value = "exception", required = false) String exception, Model model) {
		model.addAttribute("error", error);
		model.addAttribute("exception", exception);
		return "login";
	}

	// 회원가입
	@RequestMapping(value = "/join/signup", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> signup(HttpServletRequest request, @RequestBody HashMap<String, Object> param) throws Exception {
		Map<String, Object> result = loginService.signup(param);
		return result;
	}

	// 아이디 중복 확인
	@RequestMapping(value = "/join/checkId", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> checkId(HttpServletRequest request, @RequestBody HashMap<String, Object> param) throws Exception {
		Map<String, Object> result = loginService.checkId(param);
		return result; 
	}
}
