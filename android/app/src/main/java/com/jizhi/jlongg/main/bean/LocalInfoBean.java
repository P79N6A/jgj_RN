package com.jizhi.jlongg.main.bean;

import org.litepal.crud.LitePalSupport;

import java.io.Serializable;

/**
 * 本地草稿信息
 */

public class LocalInfoBean extends LitePalSupport implements Serializable {
    /*消息id*/
    private long msg_id = 0;
    /*消息类型 group,team*/
    private String class_type;
    /*消息类型 group,team*/
    private String msg_type;
    /*组id*/
    private String group_id;
    /*用户手机号*/
    private String mobile_phone;
    /*草稿信息*/
    private String content;
    /*草稿类型  1，发布  2.回复  3.聊天*/
    private int info_type;

    public static final int TYPE_SEND = 1;
    public static final int TYPE_REPLY = 2;
    public static final int TYPE_MSG = 3;

    public LocalInfoBean() {
    }

    public LocalInfoBean(long msg_id, String class_type, String msg_type, String group_id, String content, int info_type) {
        this.msg_id = msg_id;
        this.class_type = class_type;
        this.msg_type = msg_type;
        this.group_id = group_id;
        this.content = content;
        this.info_type = info_type;
    }

    public String getMsg_type() {
        return msg_type;
    }

    public void setMsg_type(String msg_type) {
        this.msg_type = msg_type;
    }

    public int getInfo_type() {
        return info_type;
    }

    public void setInfo_type(int info_type) {
        this.info_type = info_type;
    }

    public long getMsg_id() {
        return msg_id;
    }

    public void setMsg_id(long msg_id) {
        this.msg_id = msg_id;
    }

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getMobile_phone() {
        return mobile_phone;
    }

    public void setMobile_phone(String mobile_phone) {
        this.mobile_phone = mobile_phone;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
