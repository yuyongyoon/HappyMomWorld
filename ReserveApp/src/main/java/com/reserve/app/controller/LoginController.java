package com.reserve.app.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
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
	// 가입 코드 확인
	/*
	 * @RequestMapping(value = "/join/checkCode", method = RequestMethod.POST)
	 * 
	 * @ResponseBody public void checkCode(HttpServletRequest request, @RequestBody
	 * String code) throws Exception {
	 * 
	 * Map<String,Object> result = new HashMap<String,Object>(); int checkedCode =
	 * loginService.checkCode(code); result.put("codeCnt", checkedCode);
	 * System.out.println("codeCnt :"+checkedCode); return result; int result =
	 * loginService.checkCode(code); return result;
	 * 
	 * }
	 */
}
