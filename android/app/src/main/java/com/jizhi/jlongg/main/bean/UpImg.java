package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * 图片上传
 */

public class UpImg {
    private int num;
    private String type;
    private int state;
    private List<String> imgdata;

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public List<String> getImgdata() {
        return imgdata;
    }

    public void setImgdata(List<String> imgdata) {
        this.imgdata = imgdata;
    }
}
