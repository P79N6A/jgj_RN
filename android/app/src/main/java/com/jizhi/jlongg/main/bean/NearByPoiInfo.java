package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

public class NearByPoiInfo implements Serializable {
	/**
	 * 
	 */
	private int tag;
	private static final long serialVersionUID = 1L;
	private String address;
	private String name;
	private double longitude;// 经度
	private double latitude;// 纬度
	private String other;
	private String eg;

	public NearByPoiInfo() {
	}

	public NearByPoiInfo(String address, String name, double longitude,
			double latitude) {
		super();
		this.address = address;
		this.name = name;
		this.longitude = longitude;
		this.latitude = latitude;
	}

	public NearByPoiInfo(int tag, String address, String name,
			double longitude, double latitude, String other) {
		super();
		this.tag = tag;
		this.address = address;
		this.name = name;
		this.longitude = longitude;
		this.latitude = latitude;
		this.other = other;
	}

	public String getEg() {
		return eg;
	}

	public void setEg(String eg) {
		this.eg = eg;
	}

	public String getOther() {
		return other;
	}

	public void setOther(String other) {
		this.other = other;
	}

	public int getTag() {
		return tag;
	}

	public void setTag(int tag) {
		this.tag = tag;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

}
