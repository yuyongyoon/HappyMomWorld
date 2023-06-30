package com.reserve.app.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class CalendarController {
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String viewCalendar(Model model, HttpServletRequest request) throws Exception{
		return "calendar";
	}
}
