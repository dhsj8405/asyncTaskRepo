package com.bit.model;

public class RespVo {
	private String respTyp ;
	private Object obj;
	public RespVo(String string) {
		this.respTyp  = "CONTROLLER";
		this.obj = string;	
	}
	public RespVo(Object obj) {
		this.respTyp  = "RESCONTROLLER";
		this.obj = obj;
	}
	
	
	public String getRespTyp() {
		return respTyp ;
	}
	public Object getObj() {
		return obj;
	}
	
	
}
