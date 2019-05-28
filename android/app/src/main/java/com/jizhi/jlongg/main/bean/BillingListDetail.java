package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 记账清单详情
 */
public class BillingListDetail implements Serializable{
	/** 工头id（非必传，当前用户角色为1时返回） */
	private int uid;
	/** 每一条的差帐笔数 */
	private int t_poor;
	/** 工钱 */
	private String t_total;
	/** 名称 */
	private String name;
	/** 金额 */
	private float set_amount;
	/** 是否有差账 */
	private int amounts_diff;
	/** 日期 */
	private String date_txt;
	/** 正常工作时长（点工项目才返回） */
	private String manhour;
	/** 加班时间 */
	private String overtime;
	/** 项目名称 */
	private String pname;
	/** 项目id */
	private int pid;


	public float getSet_amount() {
		return set_amount;
	}

	public void setSet_amount(float set_amount) {
		this.set_amount = set_amount;
	}

	public int getAmounts_diff() {
		return amounts_diff;
	}

	public void setAmounts_diff(int amounts_diff) {
		this.amounts_diff = amounts_diff;
	}

	public String getDate_txt() {
		return date_txt;
	}

	public void setDate_txt(String date_txt) {
		this.date_txt = date_txt;
	}

	public String getManhour() {
		return manhour;
	}

	public void setManhour(String manhour) {
		this.manhour = manhour;
	}

	public String getOvertime() {
		return overtime;
	}

	public void setOvertime(String overtime) {
		this.overtime = overtime;
	}

	public int getT_poor() {
		return t_poor;
	}
	public void setT_poor(int t_poor) {
		this.t_poor = t_poor;
	}

	public String getT_total() {
		return t_total;
	}

	public void setT_total(String t_total) {
		this.t_total = t_total;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

	public int getUid() {
		return uid;
	}

	public void setUid(int uid) {
		this.uid = uid;
	}

	public String getPname() {
		return pname;
	}

	public void setPname(String pname) {
		this.pname = pname;
	}

	public int getPid() {
		return pid;
	}

	public void setPid(int pid) {
		this.pid = pid;
	}
}
