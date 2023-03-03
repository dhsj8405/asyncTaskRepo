package com.bit.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bit.frame.web.Controller;
import com.bit.model.RespVo;

public class IndexController implements Controller{
	
	@Override
	public String execute(HttpServletRequest req, HttpServletResponse resp) {
		return "index";
	}
}
