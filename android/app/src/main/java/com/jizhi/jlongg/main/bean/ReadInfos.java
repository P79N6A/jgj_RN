package com.jizhi.jlongg.main.bean;

import org.litepal.crud.LitePalSupport;

import java.io.Serializable;

/**
 * CName:
 * User: hcs
 * Date: 2016-09-03
 * Time: 16:56
 */
public class ReadInfos extends LitePalSupport implements Serializable {

    private String real_name;
    private String telphone;
    private String head_pic;
    private String uid;
    //1已注册
    private int is_active;

    public int getIs_active() {
        return is_active;
    }

    public void setIs_active(int is_active) {
        this.is_active = is_active;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }

    public String getTelphone() {
        return telphone;
    }

    public void setTelphone(String telphone) {
        this.telphone = telphone;
    }

    public String getHead_pic() {
        return head_pic;
    }

    public void setHead_pic(String head_pic) {
        this.head_pic = head_pic;
    }
}
