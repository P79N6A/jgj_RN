package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 功能:记工基础信息
 * 时间:2017-9-27 10:23
 * 作者:hcs
 */
public class WorkBaseInfo implements Serializable {
    /**
     * 正常上班小时
     */
    public float manhour;
    /**
     * 加班小时
     */
    public float overtime;
    /**
     * 记工笔数
     */
    public float total;
    /**
     * 上班工时
     */
    public String working_hours;
    /**
     * 加班工时
     */
    public String overtime_hours;
    /**
     * 金额
     */
    public String amounts;
    /**
     * 批量计算时 true表示选中了当前bean
     */
    public boolean is_selected;
    /**
     * 用户信息
     */
    public UserInfo user_info;
    /**
     * 获取当前选择的记账类型
     * 以小时为单位 ==1
     * 以工为单位 ==2
     * 上班按工天，加班按小时”“按工天 ==3
     */
    public int account_unit_show_type;
    /**
     * 获取当前选择的记账显示文本
     */
    public String account_unit_show_string;
    /**
     * 1表示记账设置了备注信息
     */
    public int is_notes;


    public float getManhour() {
        return manhour;
    }

    public void setManhour(float manhour) {
        this.manhour = manhour;
    }

    public float getOvertime() {
        return overtime;
    }

    public void setOvertime(float overtime) {
        this.overtime = overtime;
    }


    public String getAmounts() {
        return amounts;
    }

    public void setAmounts(String amounts) {
        this.amounts = amounts;
    }

    public float getTotal() {
        return total;
    }

    public void setTotal(float total) {
        this.total = total;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public String getWorking_hours() {
        return working_hours;
    }

    public void setWorking_hours(String working_hours) {
        this.working_hours = working_hours;
    }

    public String getOvertime_hours() {
        return overtime_hours;
    }

    public void setOvertime_hours(String overtime_hours) {
        this.overtime_hours = overtime_hours;
    }

    public boolean is_selected() {
        return is_selected;
    }

    public void setIs_selected(boolean is_selected) {
        this.is_selected = is_selected;
    }


    public String getAccount_unit_show_string() {
        return account_unit_show_string;
    }

    public void setAccount_unit_show_string(String account_unit_show_string) {
        this.account_unit_show_string = account_unit_show_string;
    }

    public int getAccount_unit_show_type() {
        return account_unit_show_type;
    }

    public void setAccount_unit_show_type(int account_unit_show_type) {
        this.account_unit_show_type = account_unit_show_type;
    }

    public int getIs_notes() {
        return is_notes;
    }

    public void setIs_notes(int is_notes) {
        this.is_notes = is_notes;
    }
}
