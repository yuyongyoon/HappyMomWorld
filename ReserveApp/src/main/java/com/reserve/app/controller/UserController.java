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

import com.reserve.app.service.UserService;

@Controller
@RequestMapping(value = "/user")
public class UserController {
	
	@Autowired
	UserService userService;
	//캘린더 화면
	@RequestMapping(value = "/calendar", method = RequestMethod.GET)
	public String viewCalendar(Model model, HttpServletRequest request) throws Exception{
		return "user/calendar";
	}	
	//예약 확인 화면
	@RequestMapping(value = "/reservation", method = RequestMethod.GET)
	public String viewReservation(Model model, HttpServletRequest request) throws Exception{
		return "user/reservation";
	}
	
	//-------------------------------------------------------------------------------------------------
	
	//개인 정보 가져오기
	@RequestMapping(value = "/getUserInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getUserInfo(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> userList = userService.getUserInfo(param);
		result.put("name", userList.get(0).get("name").toString());
		result.put("phone_number", userList.get(0).get("phone_number").toString());
		result.put("due_date", userList.get(0).get("due_date").toString());
		result.put("hospital", userList.get(0).get("hospital").toString());
		return result;
	}
	
	// 개인 정보 변경
	@RequestMapping(value = "/updateUserInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updateUserInfo(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = userService.updateUserInfo(param);
		result.put("msg", msg);
		return result;
	}
	
	// 비밀번호 확인
//	@RequestMapping(value = "/checkOrgPwd", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String,Object> checkId(HttpServletRequest request, @RequestBody Map<String,Object> org_pwd) throws Exception {
//		Map<String,Object> result = new HashMap<String,Object>();
//		int pwdCnt = userService.checkOrgPwd(org_pwd);
//		result.put("pwdCnt : ", pwdCnt);
//		return result;
//	}
	
	// 비밀번호 변경
	@RequestMapping(value = "/updateUserPwd", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updatePwd(HttpServletRequest request, @RequestBody HashMap<String,Object> new_pwd) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = userService.updateUserPwd(new_pwd);
		result.put("msg", msg);
		return result;
	}
	
	//-------------------------------------------------------------------------------------------------
	
	//지점 정보 가져오기
	@RequestMapping(value = "/selectBranch", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> selectBranch(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> branchList = userService.selectBranch(param);
		result.put("branchList", branchList);
		return result;
	}

}
