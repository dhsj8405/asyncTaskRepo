package com.bit.frame.web;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bit.model.RespVo;

public class DispatchServlet extends HttpServlet{
	Map<String,Controller> handler= new HashMap<>();

	@Override
	public void init(ServletConfig config) throws ServletException {
/*
		    톰캣은 Servlet을 다음과 같이 관리
		  Servlet 객체를 생성하고 초기화하는 작업은 비용이 많은 작업, 
		    다음에 또 요청이 올 때를 대비하여 이미 생성된 Servlet 객체는 메모리에 남겨둠
*/
		Map<String,String> mapping = new HashMap<>();
		System.out.println(config.getServletName());
		String fname = config.getServletName() != null ? config.getServletName():"bit";
		URL res = config.getServletContext().getClassLoader().getResource(fname + ".properties");
		Properties prop= new Properties();
		try {
			prop.load(res.openStream());
			Set<Entry<Object,Object>> entrys = prop.entrySet();
			for(Entry<Object,Object> entry:entrys) {
				mapping.put(entry.getKey().toString(), entry.getValue().toString());
			}
		} catch (IOException e3) {
			e3.printStackTrace();
		} 
		Set<Entry<String,String>> entrys =  mapping.entrySet();
		Iterator<Entry<String,String>>  ite = entrys.iterator(); 
		try {
			while(ite.hasNext()) {
				Entry<String,String> entry = ite.next();
				Controller controller = (Controller) Class.forName(entry.getValue()).newInstance();
				handler.put(entry.getKey(),controller);
			}
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
	}
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doDo(req,resp);
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		doDo(req,resp);
	}
	@Override
	protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		doDo(req,resp);
	}
	@Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doDo(req,resp);
	}
	
	protected void doDo(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		//hanler map
		String url = req.getRequestURI();
		url=url.substring(req.getContextPath().length());
		Controller controller = handler.get(url);

		String viewName = controller.execute(req,resp);
		if(!"".equals(viewName)) {
			if(viewName.startsWith("redirect:")) {
				resp.sendRedirect(viewName.substring("redirect:".length()));
				return;
			}else {
				String prefix = "/WEB-INF/views/";
				String suffix = ".jsp";
				req.getRequestDispatcher(prefix + viewName + suffix).forward(req, resp);
				return;
			}
		}
	
		
	}
	
}
