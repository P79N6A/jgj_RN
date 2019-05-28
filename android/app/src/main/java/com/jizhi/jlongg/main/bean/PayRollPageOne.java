package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 工资清单 列表
 * huchangsheng：Xuj on 2016/2/22 14:41
 */
public class PayRollPageOne implements Serializable {
    /**
     * 当前登录人id
     */
    private int cur_uid;
    /**
     * 记账对象名称
     */
    private String name;
    /**
     * 记账对象ID
     */
    private int uid;
    /**
     * 上班合计
     */
    private float total_manhour;
    /**
     * 加班合计
     */
    private float total_overtime;
    /**
     * 总金额
     */
    private float total;
    /**
     * 目标id
     */
    private int target_id;
    /**
     * 记账新单位
     */
    private AccountUtil new_total;





    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public float getTotal_manhour() {
        return total_manhour;
    }

    public void setTotal_manhour(float total_manhour) {
        this.total_manhour = total_manhour;
    }

    public float getTotal_overtime() {
        return total_overtime;
    }

    public void setTotal_overtime(float total_overtime) {
        this.total_overtime = total_overtime;
    }

    public float getTotal() {
        return total;
    }

    public void setTotal(float total) {
        this.total = total;
    }

    public int getCur_uid() {
        return cur_uid;
    }

    public void setCur_uid(int cur_uid) {
        this.cur_uid = cur_uid;
    }

    public int getTarget_id() {
        return target_id;
    }

    public void setTarget_id(int target_id) {
        this.target_id = target_id;
    }

    public AccountUtil getNew_total() {
        return new_total;
    }

    public void setNew_total(AccountUtil new_total) {
        this.new_total = new_total;
    }
}
