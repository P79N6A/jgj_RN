package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

public class WorkerDay implements Serializable {

    private int id;
    /**
     * uid
     */
    private int uid;
    /**
     * 记账总额
     */
    private double amounts;
    /**
     * 名称
     */
    private String name;
    /**
     * 日期
     */
    private String date_txt;
    /**
     * 农历
     */
    private String date_turn;
    /**
     * 是否有差账  1有差账   0代表未有差账 老版本所需
     */
    private int amounts_diff;
    /**
     * 是否有差账 0、没有差帐  2、等待自己确认  3、等待对方修改
     */
    private int modify_marking;
    /**
     * 正常工作时长（点工项目才返回）
     */
    private String manhour;
    /**
     * 加班时长（点工项目才返回）
     */
    private String overtime;
    /**
     * 工种类型
     */
    private WorkType accounts_type;

    /**
     * 是否已经删除了帐   1代表已经删除了 需要显示成--  0表示未删除
     */
    private int del_diff_tag;

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public double getAmounts() {
        return amounts;
    }

    public void setAmounts(double amounts) {
        this.amounts = amounts;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDate_txt() {
        return date_txt;
    }

    public void setDate_txt(String date_txt) {
        this.date_txt = date_txt;
    }

    public String getDate_turn() {
        return date_turn;
    }

    public void setDate_turn(String date_turn) {
        this.date_turn = date_turn;
    }

    public int getAmounts_diff() {
        return amounts_diff;
    }

    public void setAmounts_diff(int amounts_diff) {
        this.amounts_diff = amounts_diff;
    }

    public String getManhour() {
        return manhour;
    }

    public void setManhour(String manhour) {
        this.manhour = manhour;
    }

    public String getOvertime() {
        return overtime;
    }

    public void setOvertime(String overtime) {
        this.overtime = overtime;
    }

    public WorkType getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(WorkType accounts_type) {
        this.accounts_type = accounts_type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getModify_marking() {
        return modify_marking;
    }

    public void setModify_marking(int modify_marking) {
        this.modify_marking = modify_marking;
    }

    public int getDel_diff_tag() {
        return del_diff_tag;
    }

    public void setDel_diff_tag(int del_diff_tag) {
        this.del_diff_tag = del_diff_tag;
    }
}
