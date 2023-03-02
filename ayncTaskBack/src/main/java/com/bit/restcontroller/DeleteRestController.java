package com.bit.restcontroller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bit.frame.web.Controller;
import com.bit.model.ApiResult;
import com.bit.model.BbsDao;
import com.bit.model.RespVo;

public class DeleteRestController  implements Controller {
	@Override
	public String execute(HttpServletRequest req,HttpServletResponse resp) {
		int bbsNum = Integer.parseInt(req.getParameter("num"));
		resp.setCharacterEncoding("UTF-8");

		try (
				PrintWriter out=resp.getWriter();
			){
			BbsDao bbsDao = new BbsDao();
			ApiResult apiResult = bbsDao.deleteOne(bbsNum);
			out.print(apiResult);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "";
	}

}
