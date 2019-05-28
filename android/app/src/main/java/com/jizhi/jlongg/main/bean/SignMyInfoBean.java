package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 签到我的信息
 */
public class SignMyInfoBean implements Serializable {
    //进入签到次数
    private int today_sign_record_num;
    //签到地址
    private String sign_addr;
    //签到时间
    private String sign_time;
    private UserInfo user_info;

    public int getToday_sign_record_num() {
        return today_sign_record_num;
    }

    public void setToday_sign_record_num(int today_sign_record_num) {
        this.today_sign_record_num = today_sign_record_num;
    }

    public String getSign_addr() {
        return sign_addr;
    }

    public void setSign_addr(String sign_addr) {
        this.sign_addr = sign_addr;
    }

    public String getSign_time() {
        return sign_time;
    }

    public void setSign_time(String sign_time) {
        this.sign_time = sign_time;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }
}
