package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 功能:缩略图对象
 * 时间:2016/3/13 17:58
 * 作者:xuj
 */
public class ImageItem implements Serializable {
	/** 图片id */
	public String imageId;
	/** 缩略图路径 */
	public String thumbnailPath;
	/** 图片路径 */
	public String imagePath;
	/** 是否选择了当前图片 */
	public boolean isSelected;
	/**  是否是网络图片 */
	public boolean isNetPicture;
	/**  是否是拍照的图片 */
	public boolean isCamenrPicture;
	public String url;


    public ImageItem() {

    }

    public ImageItem(boolean isNetPicture) {
        this.isNetPicture = isNetPicture;
    }

    public ImageItem(String imagePath, boolean isNetPicture) {
        this.imagePath = imagePath;
        this.isNetPicture = isNetPicture;
    }


	@Override
	public String toString() {
		return "ImageItem{" +
				"imageId='" + imageId + '\'' +
				", thumbnailPath='" + thumbnailPath + '\'' +
				", imagePath='" + imagePath + '\'' +
				", isSelected=" + isSelected +
				", isNetPicture=" + isNetPicture +
				'}';
	}
}
