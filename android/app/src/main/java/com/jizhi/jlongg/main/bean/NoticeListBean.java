package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 通知bean
 */
public class NoticeListBean implements Serializable{
    //通知ID
    private String msg_id;
    //通知内容
    private String msg_text;
    //通知图片
    private List<String> msg_src;
    //通知日期,分组用
    private String send_date;
    //发送时间
    private String send_time;
    // 通知发送者UID
    private String msg_sender;
    //是否可以展示1为可以
    private int is_active;
    //表示是否有接收人，0表示全体，1：表示几个人
    private int is_recieve;
    //通知日期(展示
    private String send_date_str;
    //通知发送者信息
    private UserInfo user_info;

    public String getMsg_id() {
        return msg_id;
    }

    public void setMsg_id(String msg_id) {
        this.msg_id = msg_id;
    }

    public String getMsg_text() {
        return msg_text;
    }

    public void setMsg_text(String msg_text) {
        this.msg_text = msg_text;
    }

    public List<String> getMsg_src() {
        return msg_src;
    }

    public void setMsg_src(List<String> msg_src) {
        this.msg_src = msg_src;
    }

    public String getSend_date() {
        return send_date;
    }

    public void setSend_date(String send_date) {
        this.send_date = send_date;
    }

    public String getSend_time() {
        return send_time;
    }

    public void setSend_time(String send_time) {
        this.send_time = send_time;
    }

    public String getMsg_sender() {
        return msg_sender;
    }

    public void setMsg_sender(String msg_sender) {
        this.msg_sender = msg_sender;
    }

    public int getIs_active() {
        return is_active;
    }

    public void setIs_active(int is_active) {
        this.is_active = is_active;
    }

    public int getIs_recieve() {
        return is_recieve;
    }

    public void setIs_recieve(int is_recieve) {
        this.is_recieve = is_recieve;
    }

    public String getSend_date_str() {
        return send_date_str;
    }

    public void setSend_date_str(String send_date_str) {
        this.send_date_str = send_date_str;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }
}
