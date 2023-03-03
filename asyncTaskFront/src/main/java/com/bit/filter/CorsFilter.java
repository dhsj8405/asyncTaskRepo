package com.bit.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

public class CorsFilter implements Filter{

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		System.out.println("[CorsFilter.java] CORS 필터 동작");
		HttpServletResponse resp = (HttpServletResponse) res;
		resp.setHeader("Access-Control-Allow-Origin", "*");
		resp.setHeader("Access-Control-Allow-Methods", "*");
	    resp.setHeader("Access-Control-Allow-Headers", "*");
		resp.setHeader("Access-Control-Expose-Headers", "*");
		resp.setContentType("application/json; charset=utf8");

		chain.doFilter(req, res);
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// TODO Auto-generated method stub
	
		
	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

}