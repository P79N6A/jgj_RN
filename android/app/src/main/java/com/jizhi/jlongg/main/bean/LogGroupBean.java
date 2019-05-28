package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Administrator on 2017/7/20 0020.
 */

public class LogGroupBean implements Serializable {

    private String log_date;
    private int day_num;
    private List<LogChildBean> list;
    private String cat_id;
    private String cat_name;
    private String log_type;
    private boolean Checked;
    //筛选字段
    private String uid;//提交人uid
    private String name;//提交人name
    private String send_stime;//发送开始时间20170603
    private String send_etime;//发送结束时间20170603

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getSend_stime() {
        return send_stime;
    }

    public void setSend_stime(String send_stime) {
        this.send_stime = send_stime;
    }

    public String getSend_etime() {
        return send_etime;
    }

    public void setSend_etime(String send_etime) {
        this.send_etime = send_etime;
    }

    public boolean isChecked() {
        return Checked;
    }

    public void setChecked(boolean checked) {
        Checked = checked;
    }

    public String getCat_id() {
        return cat_id;
    }

    public void setCat_id(String cat_id) {
        this.cat_id = cat_id;
    }

    public String getCat_name() {
        return cat_name;
    }

    public void setCat_name(String cat_name) {
        this.cat_name = cat_name;
    }

    public String getLog_type() {
        return log_type;
    }

    public void setLog_type(String log_type) {
        this.log_type = log_type;
    }

    public String getLog_date() {
        return log_date;
    }

    public void setLog_date(String log_date) {
        this.log_date = log_date;
    }

    public int getDay_num() {
        return day_num;
    }

    public void setDay_num(int day_num) {
        this.day_num = day_num;
    }

    public List<LogChildBean> getList() {
        return list;
    }

    public void setList(List<LogChildBean> list) {
        this.list = list;
    }
}
