package com.jizhi.jlongg.main.bean;

import android.graphics.Bitmap;

import java.io.Serializable;
/**
 * 功能:图片
 * 时间:2016-4-7 16:05
 * 作者:xuj
 */
public class Photo implements Serializable {
	/** 图片id 方便图片排序 */
    private int id;
	/** 图片url */
	private String[] url;
	/** 是否是网络图片 */
	private boolean isNetImage = false;
	/** 图片路径 */
	private String imagePath;

	private Bitmap bitmap;
	

	public Photo(int id, Bitmap bitmap) {
		this.id = id;
	}
	
	public Photo(String imagePath, boolean isNetImage){
		this.imagePath = imagePath;
		this.isNetImage = isNetImage;
	}
	
	public Photo(Bitmap bitmap, String imagePath){
		this.imagePath = imagePath;
	}
	
	public Photo(int id, String imagePath, boolean isNetImage){
		this.id = id;
		this.imagePath = imagePath;
		this.isNetImage = isNetImage;
	}
	
	
	public boolean isNetImage() {
		return isNetImage;
	}
	public void setNetImage(boolean isNetImage) {
		this.isNetImage = isNetImage;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String[] getUrl() {
		return url;
	}
	public void setUrl(String[] url) {
		this.url = url;
	}
	public String getImagePath() {
		return imagePath;
	}
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}


	public Bitmap getBitmap() {
		return bitmap;
	}

	public void setBitmap(Bitmap bitmap) {
		this.bitmap = bitmap;
	}
}
