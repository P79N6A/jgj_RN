package com.jizhi.jlongg.main.bean;

import java.util.ArrayList;
/**
 * 功能:项目经验
 * 时间:2016-4-22 10:51
 * 作者:xuj
 */
public class Experience extends BaseNetBean {
	private int id;
	/** 创建时间 */
	private String ctime;
	/** urls */
	private ArrayList<String> imgs;
	/** 地址 */
	private String proaddress;
	/** 城市名称 */
	private String regionname;
	/** 城市编号 */
	private String region;
	/** 项目名称 */
	private String proname;
	/** 项目id */
	private int pid;
	/** url 路径 */
	private String[] url;

	private ArrayList<ImageItem> imageItem;

	public String[] getUrl() {
		return url;
	}

	public void setUrl(String[] url) {
		this.url = url;
	}


	public String getCtime() {
		return ctime;
	}

	public void setCtime(String ctime) {
		this.ctime = ctime;
	}

	public String getProaddress() {
		return proaddress;
	}

	public void setProaddress(String proaddress) {
		this.proaddress = proaddress;
	}

	public String getProname() {
		return proname;
	}

	public void setProname(String proname) {
		this.proname = proname;
	}

	public String getRegionname() {
		return regionname;
	}

	public void setRegionname(String regionname) {
		this.regionname = regionname;
	}

	public ArrayList<String> getImgs() {
		return imgs;
	}

	public void setImgs(ArrayList<String> imgs) {
		this.imgs = imgs;
	}

	public String getRegion() {
		return region;
	}

	public void setRegion(String region) {
		this.region = region;
	}


	public int getPid() {
		return pid;
	}

	public void setPid(int pid) {
		this.pid = pid;
	}

	public ArrayList<ImageItem> getImageItem() {
		return imageItem;
	}

	public void setImageItem(ArrayList<ImageItem> imageItem) {
		this.imageItem = imageItem;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
}
