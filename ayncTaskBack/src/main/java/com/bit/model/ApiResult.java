package com.bit.model;

import java.util.List;

public class ApiResult {
	private String result = "";		// catch에서 FAIL 넣어주기
    private String resultMsg = "";			// 모달에 넣어줄 알림메시지
    private List data;						// 조회 데이터
    private String strData;					//추가적으로 필요한 문자
    
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public String getResultMsg() {
		return resultMsg;
	}
	public void setResultMsg(String resultMsg) {
		this.resultMsg = resultMsg;
	}
	public List getData() {
		return data;
	}
	public void setData(List data) {
		this.data = data;
	}
	public String getStrData() {
		return strData;
	}
	public void setStrData(String strData) {
		this.strData = strData;
	}
	@Override
	public String toString() {
		return "{ \"result\" : \"" + result + "\", \"resultMsg\":\"" + resultMsg + "\", \"data\":" + data + ", \"strData\":\"" + strData
				+ "\"}";
	}
    
    
	
}
