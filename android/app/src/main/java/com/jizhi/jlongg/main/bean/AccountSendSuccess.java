package com.jizhi.jlongg.main.bean;


import java.io.Serializable;

public class AccountSendSuccess implements Serializable {
    private int is_exist;
    //班组group_id，0:表示没有班组 如果是全局是工人角色，不会返回此字段
    private String group_id;
    private String record_id;
    private String msg;
    private String accounts_type;
    private String uid;
    //名字
    private String date;
    private int is_next_act;
    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }
    public int getIs_exist() {
        return is_exist;
    }

    public void setIs_exist(int is_exist) {
        this.is_exist = is_exist;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
    public String getRecord_id() {
        return record_id;
    }

    public void setRecord_id(String record_id) {
        this.record_id = record_id;
    }
    public String getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(String accounts_type) {
        this.accounts_type = accounts_type;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }
    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
    public int getIs_next_act() {
        return is_next_act;
    }

    public void setIs_next_act(int is_next_act) {
        this.is_next_act = is_next_act;
    }
}
