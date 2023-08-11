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
	@RequestMapping(value = "/reservation_status", method = RequestMethod.GET)
	public String viewReservationStatus(Model model, HttpServletRequest request) throws Exception {
		return "admin/reservation_status";
	}
	
	//예약 마스터 관리 화면
	@RequestMapping(value = "/reservation_master", method = RequestMethod.GET)
	public String viewReservationMaster(Model model, HttpServletRequest request) throws Exception {
		return "admin/reservation_master";
	}
	
	//지점 정보 관리 화면
	@RequestMapping(value = "/info_master", method = RequestMethod.GET)
	public String viewBranchMaster(Model model, HttpServletRequest request) throws Exception {
		return "admin/info_master";
	}
	
	//지점 관리 화면
	@RequestMapping(value = "/branch_manager", method = RequestMethod.GET)
	public String viewBranchManager(Model model, HttpServletRequest request) throws Exception {
		return "admin/branch_manager";
	}
	
	//qr 코드 관리 화면
	@RequestMapping(value = "/qrcode_manager", method = RequestMethod.GET)
	public String viewQrcodeManager(Model model, HttpServletRequest request) throws Exception {
		return "admin/qrcode_manager";
	}
	
	@RequestMapping(value = "/getBranchNameList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getBranchNameList(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> branchNameList = adminService.getBranchNameList(param);
		result.put("branchNameList", branchNameList);
		return result;
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
	
	@RequestMapping(value = "/updateAccount", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updateUser(HttpServletRequest request, @RequestBody HashMap<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.updateAccount(param);
		result.put("msg", msg);
		return result;
	}

	@RequestMapping(value = "/getBranchList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getBranchList(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> branchList = adminService.getBranchList(param);
		result.put("branchList", branchList);
		return result;
	}
	
	@RequestMapping(value = "/checkId", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> checkId(HttpServletRequest request, @RequestBody HashMap<String, Object> param) throws Exception {
		Map<String, Object> result = adminService.checkId(param);
		return result; 
	}

	@RequestMapping(value = "/addBranchInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> addBranch(HttpServletRequest request, @RequestBody HashMap<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.addBranchInfo(param);
		result.put("msg", msg);
		return result;
	}

	@RequestMapping(value = "/updateBranchInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updateBranchInfo(HttpServletRequest request, @RequestBody HashMap<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.updateBranchInfo(param);
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value="/resetMngPwd")
	@ResponseBody
	public Map<String, Object> resetMngPwd(@RequestBody Map<String, Object> param, HttpServletResponse response) throws Exception{
		return adminService.resetMngPwd(param);
	}

	@RequestMapping(value = "/updateManager", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updateManager(HttpServletRequest request, @RequestBody HashMap<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.updateManager(param);
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/getReservationMasterData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getReservationMasterData(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> masterList = adminService.getReservationMasterData(param);
		Map<String,Object> branchReservationInfo = adminService.getBranchReservationInfo(param);
		result.put("masterList", masterList);
		result.put("branchReservationInfo", branchReservationInfo);
		return result;
	}
	
	@RequestMapping(value = "/saveReservationMasterData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> saveReservationMasterData(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.saveReservationMasterData(param);
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/getCalendarEvent", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getCalendarEvent(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> calendarList = adminService.getCalendarEvent(param);
		result.put("calendarList", calendarList);
		return result;
	}
	
	@RequestMapping(value = "/getSeletedDateReservationList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getSeletedDateReservationList(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		Map<String,Object> theaderData = adminService.getSeletedDateReservationList(param);
		List<Map<String,Object>> rsvUserList = adminService.getRsvUserList(param);
		result.put("theaderData", theaderData);
		result.put("rsvUserList", rsvUserList);
		return result;
	}
	
	@RequestMapping(value = "/getDashInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getDashInfo(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		Map<String,Object> rsvLastMonth = adminService.getRsvLastMonth(param);
		List<Map<String,Object>> recentJoinData = adminService.getRecentJoinData(param);
		List<Map<String,Object>> recentRsvData = adminService.getRecentRsvData(param);
		List<Map<String,Object>> nonRsvData = adminService.getNonRsvData(param);
		List<Map<String,Object>> nonConfirmData = adminService.getNonConfirmData(param);
		
		result.put("rsvLastMonth", rsvLastMonth);
		result.put("recentJoinData", recentJoinData);
		result.put("recentRsvData", recentRsvData);
		result.put("nonRsvData", nonRsvData);
		result.put("nonConfirmData", nonConfirmData);
		return result;
	}
	
	@RequestMapping(value = "/getRecentJoinData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getRecentJoinData(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> recentJoinData = adminService.getRecentJoinData(param);
		
		result.put("recentJoinData", recentJoinData);
		return result;
	}
	
	@RequestMapping(value = "/getRecentRsvData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getRecentRsvData(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> recentRsvData = adminService.getRecentRsvData(param);
		
		result.put("recentRsvData", recentRsvData);
		return result;
	}

	@RequestMapping(value = "/getNonRsvData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getNonRsvData(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> nonRsvData = adminService.getNonRsvData(param);
		
		result.put("nonRsvData", nonRsvData);
		return result;
	}
	
	@RequestMapping(value = "/saveMsgLog", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> saveMsgLog(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.saveMsgLog(param);
		result.put("msg", msg);
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
	
	@RequestMapping(value = "/getBranchInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getBranchInfo(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		Map<String,Object> branchInfo = adminService.getBranchInfo(param);
		result.put("branchInfo", branchInfo);
		return result;
	}
	
	@RequestMapping(value = "/getNonConfirmData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getNonConfirmData(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> nonConfirmData = adminService.getNonConfirmData(param);
		result.put("nonConfirmData", nonConfirmData);
		return result;
	}
	
	@RequestMapping(value = "/getReservationList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getReservationModal(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> reservationList = adminService.getReservationList(param);
		result.put("reservationList", reservationList);
		return result;
	}
	
	@RequestMapping(value = "/updateReservation", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updateReservation(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.updateReservation(param);
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/removeReservationByAdmin", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> removeReservationByAdmin(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.removeReservationByAdmin(param);
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/updateRsvStatus", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updateRsvStatus(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.updateRsvStatus(param);
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/getMainUrl", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getMainUrl(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		Map<String,Object> mainUrl = adminService.getMainUrl(param);
		result.put("mainUrl", mainUrl);
		return result;
	}
	
	@RequestMapping(value = "/updateUrl", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updateUrl(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = adminService.updateUrl(param);
		result.put("msg", msg);
		return result;
	}
}
