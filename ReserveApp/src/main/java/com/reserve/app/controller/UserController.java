package com.reserve.app.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value = "/user")
public class UserController {
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
}
