package com.jizhi.jlongg.main.bean;

/**
 * 认证
 * 
 * @author hcs
 * @time 2015年11月28日 10:59:23
 * @version 1.0
 */
public class IDU {
	/** 验证状态  */
	private int verified;
	/** 姓名 */
	private String realname;
	/** 身份证号*/
	private String icno;
	public int getVerified() {
		return verified;
	}
	public void setVerified(int verified) {
		this.verified = verified;
	}
	public String getRealname() {
		return realname;
	}
	public void setRealname(String realname) {
		this.realname = realname;
	}
	public String getIcno() {
		return icno;
	}
	public void setIcno(String icno) {
		this.icno = icno;
	}
	
	

}
