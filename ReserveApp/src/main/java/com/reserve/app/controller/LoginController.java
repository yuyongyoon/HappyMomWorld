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
//@RequestMapping(value = "/login")
public class LoginController {
	
	@Autowired
	LoginService loginService;
	
	// 로그인
	@RequestMapping(value="/login", method = RequestMethod.GET)
	public String login(@RequestParam(value = "error", required = false) String error, @RequestParam(value = "exception", required = false) String exception, Model model) {
		model.addAttribute("error",error);
		model.addAttribute("exception",exception);
		return "login";
	}
	// 회원가입
	@RequestMapping(value = "/signup", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> addUser(HttpServletRequest request, @RequestBody HashMap<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = loginService.signup(param);
		result.put("msg", msg);
		return result;
	}
	// 아이디 중복 확인
	@RequestMapping(value = "/checkId", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> checkId(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		int checkedId = loginService.checkId(param);
		result.put("idCnt", checkedId);
		System.out.println("idCnt :"+checkedId);
		return result;
	}

}
