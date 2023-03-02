package com.bit.frame.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bit.model.RespVo;

public interface Controller {
	String execute(HttpServletRequest req, HttpServletResponse resp);
}
