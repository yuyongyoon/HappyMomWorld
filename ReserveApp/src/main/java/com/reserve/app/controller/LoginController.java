package com.reserve.app.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class LoginController {

	@RequestMapping(value="/login", method = RequestMethod.GET)
	public String login(@RequestParam(value = "error", required = false) String error, @RequestParam(value = "exception", required = false) String exception, Model model) {
		model.addAttribute("error",error);
		model.addAttribute("exception",exception);
		return "login";
	}
	
	@RequestMapping(value = "/addAccount", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> addUser(HttpServletRequest request, @RequestBody HashMap<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = loginService.addAccount(param);
		result.put("msg", msg);
		return result;
	}

}
