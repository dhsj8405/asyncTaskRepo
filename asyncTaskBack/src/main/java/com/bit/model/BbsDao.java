package com.bit.model;

import java.io.IOException;
import java.io.Reader;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;


import com.bit.framework.jdbc.JdbcTemplate;
import com.bit.framework.jdbc.RowMapper;
import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.mysql.cj.jdbc.MysqlDataSource;

public class BbsDao {
	SqlMapClient sqlMapClient;
	ApiResult apiResult = new ApiResult();
	public BbsDao() {
		try {
			Reader reader = Resources.getResourceAsReader("/SqlMapConfig.xml");
			sqlMapClient = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public ApiResult selectAll(String srhKey, String srhWord, int limit, int nowPage){
		BbsDto bean = new BbsDto();
		bean.setSrhKey(srhKey);
		bean.setSrhWord(srhWord);
		bean.setLimit(limit);
		bean.setNowPage(nowPage);
		bean.setOffset((nowPage-1) * limit);
		try {
			apiResult.setData(sqlMapClient.queryForList("selectAll",bean));
			if(apiResult.getData().size()>0) {
				apiResult.setResult("SUCCESS");	
			}else {
				apiResult.setResult("FAIL");
				//apiResult.setResultMsg("조회에 실패했습니다");	
				apiResult.setResultMsg(apiResult);	
			}
		} catch (SQLException e) {
			e.printStackTrace();
			apiResult.setResult("FAIL");
// 			apiResult.setResultMsg("조회에 실패했습니다");
			apiResult.setResultMsg(e);
		}
		return  apiResult;
	}
	
	public ApiResult insertOne(BbsDto bean) {
		try {
			
			int resultBbsNum = (int) sqlMapClient.insert("insertOne",bean);
			if(resultBbsNum > 0) {
				apiResult.setStrData(String.valueOf(resultBbsNum));
				apiResult.setResult("SUCCESS");
				apiResult.setResultMsg("등록이 완료되었습니다.");
			}else {
				apiResult.setResult("FAIL");
				apiResult.setResultMsg("등록에 실패했습니다");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			apiResult.setResult("FAIL");
			apiResult.setResultMsg("등록에 실패했습니다");
		}
		return apiResult;
	}

	public ApiResult selectOne(int bbsNum) {
		try {
			apiResult.setData(sqlMapClient.queryForList("selectOne",bbsNum));
			if(apiResult.getData().size()>0) {
				apiResult.setResult("SUCCESS");	
			}else {
				apiResult.setResult("FAIL");
				apiResult.setResultMsg("조회에 실패했습니다");	
			}
		} catch (SQLException e) {
			e.printStackTrace();
			apiResult.setResult("FAIL");
			apiResult.setResultMsg("조회에 실패했습니다");
		}
		return apiResult; 
	}
	public ApiResult updateOne(BbsDto bbsDto) {
		try {
			if(sqlMapClient.update("updateOne",bbsDto)>0) {
				apiResult.setResult("SUCCESS");
				apiResult.setResultMsg("수정이 완료되었습니다.");	
			}else {
				apiResult.setResult("FAIL");
				apiResult.setResultMsg("수정에 실패했습니다.");	
			}
		} catch (SQLException e) {
			e.printStackTrace();
			apiResult.setResult("FAIL");
			apiResult.setResultMsg("수정에 실패했습니다.");
		}
		return apiResult;
	}
	public ApiResult deleteOne(int bbsNum) {
		try {
			
			if(sqlMapClient.delete("deleteOne",bbsNum)>0) {
				apiResult.setResult("SUCCESS");
				apiResult.setResultMsg("삭제가 완료되었습니다.");
			}else {
				apiResult.setResult("FAIL");
				apiResult.setResultMsg("삭제에 실패했습니다.");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			apiResult.setResult("FAIL");
			apiResult.setResultMsg("삭제에 실패했습니다.");
		}
		return apiResult;
	}
	public int updateCnt(int bbsNum) {
		int result = 0;
		try {
			result = sqlMapClient.update("updateCnt",bbsNum);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}

	public int selectMaxCnt(String srhKey, String srhWord, int limit) {
		BbsDto bean = new BbsDto();
		bean.setSrhKey(srhKey);
		bean.setSrhWord(srhWord);
		bean.setLimit(limit);
		int result = 0;
		try {
			result = (int) sqlMapClient.queryForObject("selectMaxCnt",bean);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}


}
