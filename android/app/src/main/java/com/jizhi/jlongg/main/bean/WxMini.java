package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * hcs by微信小程序重新 2018/5/5 0005.
 */

public class WxMini implements Serializable {
    private String appId;
    private String path;
    //小程序pic
    private String typeImg;

    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getTypeImg() {
        return typeImg;
    }

    public void setTypeImg(String typeImg) {
        this.typeImg = typeImg;
    }
}
