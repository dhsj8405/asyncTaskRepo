package com.bit.model;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class BbsDto {
	private int num,ref,seq,lvl;
	private String sub;
	private String id;
	private int cnt;
	private String content;
	private Date regDate;
	
	private List<ReplyDto> replyList;
	//검색영역 
	private int limit,nowPage,offset;
	private String srhKey,srhWord;
	
	public BbsDto() {
		
	}
	public BbsDto(String id, String sub ,  String content) {
		this.sub = sub;
		this.id = id;
		this.content = content;
	}
	public BbsDto(int num, int ref, int seq, int lvl, String sub, String id, int cnt, 
			String content, Date regDate) {
		this.num = num;
		this.ref = ref;
		this.seq = seq;
		this.lvl = lvl;
		this.sub = sub;
		this.id = id;
		this.cnt = cnt;
		this.content = content;
		this.regDate = regDate;
	}
	


	public BbsDto(String id, String sub, String content, int num) {
		this.num = num;
		this.sub = sub;
		this.id = id;
		this.content = content;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getRef() {
		return ref;
	}
	public void setRef(int ref) {
		this.ref = ref;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public int getLvl() {
		return lvl;
	}
	public void setLvl(int lvl) {
		this.lvl = lvl;
	}
	public String getSub() {
		return sub;
	}
	public void setSub(String sub) {
		this.sub = sub;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}

	public int getLimit() {
		return limit;
	}
	public void setLimit(int limit) {
		this.limit = limit;
	}
	
	public String getSrhKey() {
		return srhKey;
	}
	public void setSrhKey(String srhKey) {
		this.srhKey = srhKey;
	}
	public String getSrhWord() {
		return srhWord;
	}
	public void setSrhWord(String srhWord) {
		this.srhWord = srhWord;
	}
	
	public int getNowPage() {
		return nowPage;
	}
	public void setNowPage(int nowPage) {
		this.nowPage = nowPage;
	}
	
	public int getOffset() {
		return offset;
	}
	public void setOffset(int offset) {
		this.offset = offset;
	}
	
	public List<ReplyDto> getReplyList() {
		return replyList;
	}
	public void setReplyList(List<ReplyDto> replyList) {
		this.replyList = replyList;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + cnt;
		result = prime * result + ((content == null) ? 0 : content.hashCode());
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result + lvl;
		result = prime * result + num;
		result = prime * result + ref;
		result = prime * result + ((regDate == null) ? 0 : regDate.hashCode());
		result = prime * result + seq;
		result = prime * result + ((sub == null) ? 0 : sub.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		BbsDto other = (BbsDto) obj;
		if (cnt != other.cnt)
			return false;
		if (content == null) {
			if (other.content != null)
				return false;
		} else if (!content.equals(other.content))
			return false;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (lvl != other.lvl)
			return false;
		if (num != other.num)
			return false;
		if (ref != other.ref)
			return false;
		if (regDate == null) {
			if (other.regDate != null)
				return false;
		} else if (!regDate.equals(other.regDate))
			return false;
		if (seq != other.seq)
			return false;
		if (sub == null) {
			if (other.sub != null)
				return false;
		} else if (!sub.equals(other.sub))
			return false;
		return true;
	}
	
	public String dateFomatting(Date nowDate){
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss"); 
		String strNowDate = simpleDateFormat.format(nowDate); 
		return strNowDate;
	}
	

	@Override
	public String toString() {
		return "{\"num\":\"" + num + "\", \"ref\":\"" + ref + "\", \"seq\":\"" + seq + "\", \"lvl\":\"" + lvl + "\", \"sub\":\""
				+ sub + "\", \"id\":\"" + id + "\", \"cnt\":\"" + cnt + "\", \"content\":\"" + content + "\", \"regDate\":\""
				+ dateFomatting(regDate) + "\"}";
	}
	
	
}
