package com.bit.restcontroller;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bit.frame.web.Controller;
import com.bit.model.ApiResult;
import com.bit.model.BbsDao;
import com.bit.model.BbsDto;
import com.bit.model.RespVo;
import com.mysql.cj.xdevapi.JsonParser;

public class UpdateRestController  implements Controller {
	@Override
	public String execute(HttpServletRequest req,HttpServletResponse resp)  {
			String id = req.getParameter("id");
			String sub = req.getParameter("sub");
			String content = req.getParameter("content");
			
			int bbsNum = Integer.parseInt(req.getParameter("num"));
			
			content = content.replaceAll("\n", "<br/>");
			BbsDto bbsDto = new BbsDto(id,sub,content,bbsNum);
			BbsDao bbsDao = new BbsDao();
			resp.setCharacterEncoding("UTF-8");
			try (
					PrintWriter out=resp.getWriter();
			){
				ApiResult apiResult = bbsDao.updateOne(bbsDto);
				if("SUCCESS".equals(apiResult.getResult())) {
					apiResult = bbsDao.selectOne(bbsNum);
				}else {
					apiResult.setResult("FAIL");
					apiResult.setResultMsg("수정에 실패했습니다.");
				}
				out.print(apiResult );
				
				
			} catch (IOException e) {
				e.printStackTrace();
			}
		//뷰 반환 필요 x
		return "";
	}

}
