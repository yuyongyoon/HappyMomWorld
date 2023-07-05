package com.reserve.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.reserve.app.service.AdminService;

@Controller
@RequestMapping(value = "/admin")
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	//기본틀 config.xml에 작성
	//화면 호출
	@RequestMapping(value = "/user", method = RequestMethod.GET)
	public String viewUser(Model model, HttpServletRequest request) throws Exception {
		return "admin/user";
	}
	
	@RequestMapping(value = "/getUserList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getUserList(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> userList = adminService.getUserList(param);
		result.put("userList", userList);
		return result;
	}
	
	@RequestMapping(value="/resetPassword")
	@ResponseBody
	public Map<String, Object> resetPassword(@RequestBody Map<String, Object> param, HttpServletResponse response) throws Exception{
		return adminService.resetPassword(param);
	}
	
	@RequestMapping(value = "/addAccount", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> addUser(HttpServletRequest request, @RequestBody HashMap<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.addAccount(param);
		result.put("msg", msg);
		return result;
	}
}
