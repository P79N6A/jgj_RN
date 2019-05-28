package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * 工头评价详情
 * @author Xuj
 * @time 2015年11月28日 11:00:59
 * @Version 1.0
 */
public class Evaluation extends BaseNetBean{
	/** 整体评价 */
	private int overall;
	/** 诚信度 */
	private int credibility;
	/** 付款速度 */
	private int payspeed;
	/** 待人态度 */
	private int appetence;
	/** 回复总条数 */
	private int count;
	/** 评价人真实姓名 */
	private String realname;
	/** 个人用户平价平均值 */
	private int store_avg;
	/** 评价的时间 */
	private String ctime;
	/** 评价的内容 */
	private String content;
	/** 是否匿名 */
	private int hidename;
	/** 评价详情 */
	private List<Evaluation> contents;
	
	public int getPayspeed() {
		return payspeed;
	}

	public int getAppetence() {
		return appetence;
	}


	public void setAppetence(int appetence) {
		this.appetence = appetence;
	}


	public int getOverall() {
		return overall;
	}
	public void setOverall(int overall) {
		this.overall = overall;
	}
	public int getCredibility() {
		return credibility;
	}
	public void setCredibility(int credibility) {
		this.credibility = credibility;
	}
	public void setPayspeed(int payspeed) {
		this.payspeed = payspeed;
	}

	public String getRealname() {
		return realname;
	}

	public void setRealname(String realname) {
		this.realname = realname;
	}

	public int getStore_avg() {
		return store_avg;
	}

	public void setStore_avg(int store_avg) {
		this.store_avg = store_avg;
	}


	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public List<Evaluation> getContents() {
		return contents;
	}

	public void setContents(List<Evaluation> contents) {
		this.contents = contents;
	}

	public int getHidename() {
		return hidename;
	}

	public void setHidename(int hidename) {
		this.hidename = hidename;
	}

	public Evaluation(String realName, int store_avg, String content) {
		super();
		this.realname = realName;
		this.store_avg = store_avg;
		this.content = content;
	}
	
	
	public Evaluation(){}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public String getCtime() {
		return ctime;
	}

	public void setCtime(String ctime) {
		this.ctime = ctime;
	}
	


}
