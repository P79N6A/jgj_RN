package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 好友
 * @author Xuj
 * @time 2015年11月28日 11:01:37
 * @Version 1.0
 */
public class FriendBean implements Serializable {
	/** 电话 */
	private String telph;
	/** 好友头像 */
	private String head_pic;
	/** 好友头像  */
	private String headpic;
	/** 朋友姓名 */
	private String friendname;
	/**朋友数*/
	private int counts;
	/** uid */
	private int uid;

	private String sortLetters;
	
	public int getCounts() {
		return counts;
	}
	public void setCounts(int counts) {
		this.counts = counts;
	}
	public String getHeadpic() {
		return headpic;
	}
	public void setHeadpic(String headpic) {
		this.headpic = headpic;
	}
	public String getFriendname() {
		return friendname;
	}
	public void setFriendname(String friendname) {
		this.friendname = friendname;
	}
	
	public FriendBean(){
		
	}
	public String getTelph() {
		return telph;
	}
	public void setTelph(String telph) {
		this.telph = telph;
	}
	public FriendBean(String head_pic,String friendname,int uid,String telph){
		this.head_pic = head_pic;
		this.friendname = friendname;
		this.uid = uid;
		this.telph = telph;
	}
	public int getUid() {
		return uid;
	}
	public void setUid(int uid) {
		this.uid = uid;
	}


	public String getHead_pic() {
		return head_pic;
	}

	public void setHead_pic(String head_pic) {
		this.head_pic = head_pic;
	}


	public String getSortLetters() {
		return sortLetters;
	}

	public void setSortLetters(String sortLetters) {
		this.sortLetters = sortLetters;
	}
}
