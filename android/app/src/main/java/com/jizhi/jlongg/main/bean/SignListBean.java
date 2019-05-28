package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 签到我的信息
 */
public class SignListBean implements Serializable {
    private int id;
    //项目id
    private int group_id;
    //项目类型
    private String class_type;
    //uid
    private String sign_uid;
    //签到时间
    private String sign_time;
    //签到地址1
    private String sign_addr;
    //签到地址2
    private String sign_addr2;
    //签到备注
    private String sign_desc;
    //签到时间
    private String sign_date;
    //签到显示时间
    private String sign_date_str;
    //签到次数
    private String sign_date_num;
    //签到人信息
    private UserInfo sign_user_info;
    //坐标
    private String coordinate;
    //签到图片
    private List<String> sign_pic;

    public List<String> getSign_pic() {
        return sign_pic;
    }

    public void setSign_pic(List<String> sign_pic) {
        this.sign_pic = sign_pic;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getGroup_id() {
        return group_id;
    }

    public void setGroup_id(int group_id) {
        this.group_id = group_id;
    }

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getSign_uid() {
        return sign_uid;
    }

    public void setSign_uid(String sign_uid) {
        this.sign_uid = sign_uid;
    }

    public String getSign_time() {
        return sign_time;
    }

    public void setSign_time(String sign_time) {
        this.sign_time = sign_time;
    }

    public String getSign_addr() {
        return sign_addr;
    }

    public void setSign_addr(String sign_addr) {
        this.sign_addr = sign_addr;
    }

    public String getSign_addr2() {
        return sign_addr2;
    }

    public void setSign_addr2(String sign_addr2) {
        this.sign_addr2 = sign_addr2;
    }

    public String getSign_desc() {
        return sign_desc;
    }

    public void setSign_desc(String sign_desc) {
        this.sign_desc = sign_desc;
    }

    public String getSign_date() {
        return sign_date;
    }

    public void setSign_date(String sign_date) {
        this.sign_date = sign_date;
    }

    public String getSign_date_str() {
        return sign_date_str;
    }

    public void setSign_date_str(String sign_date_str) {
        this.sign_date_str = sign_date_str;
    }

    public String getSign_date_num() {
        return sign_date_num;
    }

    public void setSign_date_num(String sign_date_num) {
        this.sign_date_num = sign_date_num;
    }

    public UserInfo getSign_user_info() {
        return sign_user_info;
    }

    public void setSign_user_info(UserInfo sign_user_info) {
        this.sign_user_info = sign_user_info;
    }

    public String getCoordinate() {
        return coordinate;
    }

    public void setCoordinate(String coordinate) {
        this.coordinate = coordinate;
    }
}
