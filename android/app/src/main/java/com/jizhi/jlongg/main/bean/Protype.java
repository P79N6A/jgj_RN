package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

public class Protype implements Serializable{
	/** 项目编号 */
	private int code;
	/** 项目名称 */
	private String name;
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
}
