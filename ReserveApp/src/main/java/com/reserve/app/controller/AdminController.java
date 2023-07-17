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
	
	//관리자 대시보드
	@RequestMapping(value = "/dashboard", method = RequestMethod.GET)
	public String viewDashboard(Model model, HttpServletRequest request) throws Exception {
		return "admin/dashboard";
	}
	
	//회원 관리 화면
	@RequestMapping(value = "/user", method = RequestMethod.GET)
	public String viewUser(Model model, HttpServletRequest request) throws Exception {
		return "admin/user";
	}
	
	//예약 현황 조회 화면
	@RequestMapping(value = "/reservationStatus", method = RequestMethod.GET)
	public String viewSearch(Model model, HttpServletRequest request) throws Exception {
		return "admin/reservationStatus";
	}
	
	//예약 마스터 관리 화면
	@RequestMapping(value = "/reservation_master", method = RequestMethod.GET)
	public String viewReservationMaster(Model model, HttpServletRequest request) throws Exception {
		return "admin/reservation_master";
	}
	
	//지점 정보 관리 화면
	@RequestMapping(value = "/branch_master", method = RequestMethod.GET)
	public String viewBranchMaster(Model model, HttpServletRequest request) throws Exception {
		return "admin/branch_master";
	}
	
	//지점 관리 화면
	@RequestMapping(value = "/branch", method = RequestMethod.GET)
	public String viewBranch(Model model, HttpServletRequest request) throws Exception {
		return "admin/branch";
	}
	
	//=======================nav 지점 코드 가져오기=====================
	@RequestMapping(value = "/getBranchInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getBranchInfo(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> branchList = adminService.getBranchInfo(param);
		result.put("branchList", branchList);
		return result;
	}
	
	//=======================회원 관리 controller=====================
	
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
	
	/*
	 * @RequestMapping(value = "/addAccount", method = RequestMethod.POST)
	 * 
	 * @ResponseBody public Map<String,Object> addUser(HttpServletRequest
	 * request, @RequestBody HashMap<String,Object> param) throws Exception {
	 * Map<String,Object> result = new HashMap<String,Object>(); String msg =
	 * adminService.addAccount(param); result.put("msg", msg); return result; }
	 */	
	@RequestMapping(value = "/updateAccount", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updateUser(HttpServletRequest request, @RequestBody HashMap<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.updateAccount(param);
		result.put("msg", msg);
		return result;
	}

	@RequestMapping(value = "/checkId", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> checkId(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		int checkedId = adminService.checkId(param);
		result.put("idCnt", checkedId);
		return result;
	}
	
	//=======================지점 관리 controller=====================
	@RequestMapping(value = "/getBranchList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getBranchList(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> branchList = adminService.getBranchList(param);
		result.put("branchList", branchList);
		return result;
	}
	
	@RequestMapping(value = "/saveBranchInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> saveBranchInfo(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.saveBranchInfo(param);
		result.put("msg", msg);
		return result;
	}
}
