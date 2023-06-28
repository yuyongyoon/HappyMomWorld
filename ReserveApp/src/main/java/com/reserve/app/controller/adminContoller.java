package com.reserve.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.reserve.app.service.adminService;

@Controller
@RequestMapping(value = "/admin")
public class adminContoller {
	
	@Autowired
	adminService adminService;

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
	
	@RequestMapping(value = "/validateId", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> validateId(HttpServletRequest request, @RequestBody HashMap<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.validateId(param);
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/addUser", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> addUser(HttpServletRequest request, @RequestBody HashMap<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.addUser(param);
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/updateUserList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updateUserList(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.updateUserList(param);
		result.put("msg", msg);
		return result;
	}
}
