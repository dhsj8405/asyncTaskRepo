package com.bit.restcontroller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bit.frame.web.Controller;
import com.bit.model.ApiResult;
import com.bit.model.BbsDao;

public class DetailRestController  implements Controller {
	@Override
	public String execute(HttpServletRequest req,HttpServletResponse resp) {
//		req.getParameter("");
		int bbsNum = Integer.parseInt(req.getParameter("bbsNum"));
		resp.setCharacterEncoding("UTF-8");
		try (
				PrintWriter out=resp.getWriter();
			){
			BbsDao bbsDao = new BbsDao();
			ApiResult apiResult = new ApiResult();
			
			if(bbsDao.updateCnt(bbsNum)>0) {
				apiResult = bbsDao.selectOne(bbsNum); 
			}else {
				apiResult.setResult("FAIL");
				apiResult.setResultMsg("조회에 실패했습니다");
			}
			System.out.println(apiResult);
			out.print(apiResult);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "";
	}

}
