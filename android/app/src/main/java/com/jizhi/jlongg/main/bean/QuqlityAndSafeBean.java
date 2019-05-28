package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 质量安全筛选bean
 */

public class QuqlityAndSafeBean implements Serializable {
    private int filter_state;//问题状态
    private String filter_state_name;//问题状态名字
    private int filter_level;//隐患级别
    private String filter_level_name;//隐患级名字
    private String filter_date_start; //提交日期开始
    private String filter_date_end;//提交日期结束
    private String filter_time_start;//整改期限开始
    private String filter_time_end;//整改期限结束
    private int filter_change;//及时整改
    private String filter_change_name;//及时整改名字
    private String filter_people_uid;//整改负责人uid
    private String filter_people_name;//整改负责人名字
    private String filter_submit_people_uid;//问题提交人uid
    private String filter_submit_people_name;//问题提交人名字

    public String getFilter_people_name() {
        return filter_people_name;
    }

    public void setFilter_people_name(String filter_people_name) {
        this.filter_people_name = filter_people_name;
    }

    public String getFilter_submit_people_name() {
        return filter_submit_people_name;
    }

    public void setFilter_submit_people_name(String filter_submit_people_name) {
        this.filter_submit_people_name = filter_submit_people_name;
    }

    public String getFilter_state_name() {
        return filter_state_name;
    }

    public void setFilter_state_name(String filter_state_name) {
        this.filter_state_name = filter_state_name;
    }

    public String getFilter_level_name() {
        return filter_level_name;
    }

    public void setFilter_level_name(String filter_level_name) {
        this.filter_level_name = filter_level_name;
    }

    public String getFilter_change_name() {
        return filter_change_name;
    }

    public void setFilter_change_name(String filter_change_name) {
        this.filter_change_name = filter_change_name;
    }

    public int getFilter_state() {
        return filter_state;
    }

    public void setFilter_state(int filter_state) {
        this.filter_state = filter_state;
    }

    public int getFilter_level() {
        return filter_level;
    }

    public void setFilter_level(int filter_level) {
        this.filter_level = filter_level;
    }

    public String getFilter_date_start() {
        return filter_date_start;
    }

    public void setFilter_date_start(String filter_date_start) {
        this.filter_date_start = filter_date_start;
    }

    public String getFilter_date_end() {
        return filter_date_end;
    }

    public void setFilter_date_end(String filter_date_end) {
        this.filter_date_end = filter_date_end;
    }

    public String getFilter_time_start() {
        return filter_time_start;
    }

    public void setFilter_time_start(String filter_time_start) {
        this.filter_time_start = filter_time_start;
    }

    public String getFilter_time_end() {
        return filter_time_end;
    }

    public void setFilter_time_end(String filter_time_end) {
        this.filter_time_end = filter_time_end;
    }

    public int getFilter_change() {
        return filter_change;
    }

    public void setFilter_change(int filter_change) {
        this.filter_change = filter_change;
    }

    public String getFilter_people_uid() {
        return filter_people_uid;
    }

    public void setFilter_people_uid(String filter_people_uid) {
        this.filter_people_uid = filter_people_uid;
    }

    public String getFilter_submit_people_uid() {
        return filter_submit_people_uid;
    }

    public void setFilter_submit_people_uid(String filter_submit_people_uid) {
        this.filter_submit_people_uid = filter_submit_people_uid;
    }
}
