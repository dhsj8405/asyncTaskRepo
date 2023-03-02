package com.bit.restcontroller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bit.frame.web.Controller;
import com.bit.model.ApiResult;
import com.bit.model.BbsDao;

public class ListRestController  implements Controller {
	@Override
	public String execute(HttpServletRequest req,HttpServletResponse resp) {
			System.out.println("--ListController");
			String srhKey = req.getParameter("srhKey");
			String srhWord = req.getParameter("srhWord");
			int limit = Integer.parseInt(req.getParameter("limit"));
			int nowPage = Integer.parseInt(req.getParameter("nowPage"));
			resp.setCharacterEncoding("UTF-8");
		try (
				PrintWriter out=resp.getWriter();
			){
			BbsDao bbsDao = new BbsDao();
			ApiResult apiResult;
			apiResult = bbsDao.selectAll(srhKey,srhWord,limit,nowPage);
			apiResult.setStrData(bbsDao.selectMaxCnt(srhKey,srhWord,limit)+"");
			
			out.print(apiResult);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		//뷰 반환 필요 x
		return "";
	}

}
