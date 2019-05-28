package com.jizhi.jlongg.main.bean.status;

import com.jizhi.jlongg.main.bean.BaseNetBean;

@SuppressWarnings("serial")
public class UpHeadState extends BaseNetBean {
	private String imgpath;
	private UpHeadState values;

	public UpHeadState getValues() {
		return values;
	}

	public void setValues(UpHeadState values) {
		this.values = values;
	}

	public String getImgpath() {
		return imgpath;
	}

	public void setImgpath(String imgpath) {
		this.imgpath = imgpath;
	}

}
