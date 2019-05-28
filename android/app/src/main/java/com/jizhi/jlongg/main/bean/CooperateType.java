package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
/**
 * 合作方式
 * @author Xuj
 * @time 
 * @Version 1.0
 */
public class CooperateType implements Serializable{
	/** 编号 */
	private int type_id;
	/** 
	 * 1、点工
	 * 2、包工
	 * 3、总包 
	 */
	private String type_name;

	public int getType_id() {
		return type_id;
	}

	public void setType_id(int type_id) {
		this.type_id = type_id;
	}

	public String getType_name() {
		return type_name;
	}

	public void setType_name(String type_name) {
		this.type_name = type_name;
	}
}
