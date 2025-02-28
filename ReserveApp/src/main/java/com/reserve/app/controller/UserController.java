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
	
	// 캘린더 화면
	@RequestMapping(value = "/calendar", method = RequestMethod.GET)
	public String viewCalendar(Model model, HttpServletRequest request) throws Exception{
		return "user/calendar";
	}
	
	// 예약 확인 화면
	@RequestMapping(value = "/reservation", method = RequestMethod.GET)
	public String viewReservation(Model model, HttpServletRequest request) throws Exception{
		return "user/reservation";
	}
	
	//-------------------------------------------------------------------------------------------------
	
	//개인 정보 가져오기
	@RequestMapping(value = "/getUserInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getUserInfo(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = userService.getUserInfo(param);
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

	// 비밀번호 변경
	@RequestMapping(value = "/updateUserPwd", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updatePwd(HttpServletRequest request, @RequestBody HashMap<String,Object> new_pwd) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = userService.updateUserPwd(new_pwd);
		result.put("msg", msg);
		return result;
	}
	
	// 예약 리스트 가져오기
	@RequestMapping(value = "/getReservation", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getReservation(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> rsvList = userService.getReservation(param);
		Map<String,Object> massageCnt = userService.getMassageCnt(param);
		result.put("rsvList", rsvList);
		result.put("massageCnt", massageCnt);
		return result;
	}
	
	// 예약 취소
	@RequestMapping(value = "/removeReservation", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> removeReservation(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = userService.removeReservation(param);
		result.put("msg", msg);
		return result;
	}
	
	
	// 캘린더 목록
	@RequestMapping(value = "/getAvailableDate", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getAvailableDate(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> calendarList = userService.getAvailableDate(param);
		result.put("calendarList", calendarList);
		return result;
	}
	
	@RequestMapping(value = "/getAvailableData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getAvailableData(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		Map<String,Object> availableData = userService.getAvailableData(param);
		Map<String,Object> reservationTimeInfo = userService.reservationTimeInfo(param);
		result.put("availableData", availableData);
		result.put("reservationTimeInfo", reservationTimeInfo);
		result.put("rsv_date", param.get("rsv_date"));
		return result;
	}
	
	@RequestMapping(value = "/saveReservation", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> saveReservation(HttpServletRequest request, @RequestBody Map<String,Object> param) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = userService.saveReservation(param);
		result.put("msg", msg);
		return result;
	}
}
