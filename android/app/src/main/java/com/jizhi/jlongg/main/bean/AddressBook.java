package com.jizhi.jlongg.main.bean;

/**
 * 通讯录
 * 
 * @author hcs
 * @time 2015年11月28日 10:59:23
 * @version 1.0
 */
public class AddressBook {
	/** 用户名 */
	private String name;
	/** 电话号码 */
	private String telph;
	private int name_id;

	public int getName_id() {
		return name_id;
	}

	public void setName_id(int name_id) {
		this.name_id = name_id;
	}

	public AddressBook() {
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTelph() {
		return telph;
	}

	public void setTelph(String telph) {
		this.telph = telph;
	}

}
