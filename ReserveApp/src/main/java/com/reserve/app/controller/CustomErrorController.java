package com.reserve.app.controller;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CustomErrorController implements ErrorController {
	@RequestMapping("/error")
	public String handleError(HttpServletRequest request, Model model) {
		Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
	
		// 에러 코드에 따라서 에러 메시지 설정
		if (status != null) {
			int statusCode = Integer.valueOf(status.toString());
			if (statusCode == HttpStatus.FORBIDDEN.value()) {
//				System.out.println("에러 페이지 이동 403 - 접근 거부");
				model.addAttribute("errorCode", "403");
				model.addAttribute("errorMessage", "접근이 거부되었습니다.");
			} else if (statusCode == HttpStatus.UNAUTHORIZED.value()) {
//				System.out.println("에러 페이지 이동 401 - 인증 실패");
				model.addAttribute("errorCode", "401");
				model.addAttribute("errorMessage", "인증에 실패하였습니다.");
			} else if (statusCode == HttpStatus.NOT_FOUND.value()) {
//				System.out.println("에러 페이지 이동 404 - 페이지 찾을 수 없음");
				model.addAttribute("errorCode", "404");
				model.addAttribute("errorMessage", "페이지를 찾을 수 없습니다.");
			} else {
//				System.out.println("에러 페이지 이동 " + statusCode);
				model.addAttribute("errorCode", String.valueOf(statusCode));
				model.addAttribute("errorMessage", "알 수 없는 오류가 발생하였습니다.");
			}
		}
		
		return "error"; // 에러 페이지의 뷰 이름
	}
}