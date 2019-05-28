package com.jizhi.jlongg.main.bean;

import java.util.ArrayList;

/**
 * 功能: 展示webview图片类
 * 作者：huchangsheng
 * 时间: 2017-10-20 10:03
 */

public class WebImageBean {
    private ArrayList<String> imgData;//图片数组
    private String imgDiv;//图片的地址前段（包括域名）
    private int imgIndex;//显示第几张图，未传时为显示第0张

    public ArrayList<String> getImgData() {
        return imgData;
    }

    public void setImgData(ArrayList<String> imgData) {
        this.imgData = imgData;
    }

    public String getImgDiv() {
        return imgDiv;
    }

    public void setImgDiv(String imgDiv) {
        this.imgDiv = imgDiv;
    }

    public int getImgIndex() {
        return imgIndex;
    }

    public void setImgIndex(int imgIndex) {
        this.imgIndex = imgIndex;
    }
}