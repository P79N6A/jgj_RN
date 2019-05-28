package com.jizhi.jlongg.main.bean;

import java.io.Serializable;


/**
 * 功能:差帐实体类 3.4.1修改
 * 时间:2018-11-26 11:04
 * 作者:hcs
 */
public class CheckBillInfo implements Serializable {
    /**
     * 字段名称
     */
    private String fieldName;
    /**
     * 左边显示的内容
     */
    private String fieldLeft;
    /**
     * 右边显示的内容
     */
    private String fieldRight;
    /**
     * 是否差帐
     */
    private boolean isAudit;
    /**
     * 我的日薪模板
     */
    private Salary my_tpl;
    /**
     * 对方日薪模板
     */
    private Salary other_tpl;
    private int type;
    private CheckBillAllAccount workDetail;//单价  数量（工程量）
    /** 日薪模板正常上班时常我 */
    private String w_h_tpl_my;
    /** 日薪模板加班时常我 */
    private String o_h_tpl_my;
    /** 日薪模板正常上班时常对方 */
    private String w_h_tpl_other;
    /** 日薪模板加班时常对方 */
    private String o_h_tpl_other;
    /** 是否是模版 */
    private boolean isSalary;
    /**是否加粗*/
    private boolean isBold;

    public CheckBillInfo(String fieldName, int type) {
        this.fieldName = fieldName;
        this.type = type;
    }

    public CheckBillInfo(String fieldName, String fieldLeft, String fieldRight, int type) {
        this.fieldName = fieldName;
        this.fieldLeft = fieldLeft;
        this.fieldRight = fieldRight;
        this.type = type;
    }

    public CheckBillInfo(String fieldName, Salary my_tpl, Salary other_tpl, int type) {
        this.fieldName = fieldName;
        this.my_tpl = my_tpl;
        this.other_tpl = other_tpl;
        this.type = type;
    }
    public CheckBillInfo(CheckBillAllAccount workDetail, int type) {
        this.workDetail = workDetail;
        this.type = type;
    }
    public CheckBillInfo() {
    }

    public CheckBillAllAccount getWorkDetail() {
        return workDetail;
    }

    public void setWorkDetail(CheckBillAllAccount workDetail) {
        this.workDetail = workDetail;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }


    public String getFieldLeft() {
        return fieldLeft;
    }

    public void setFieldLeft(String fieldLeft) {
        this.fieldLeft = fieldLeft;
    }

    public String getFieldRight() {
        return fieldRight;
    }

    public void setFieldRight(String fieldRight) {
        this.fieldRight = fieldRight;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }


    public boolean isAudit() {
        return isAudit;
    }

    public void setAudit(boolean audit) {
        isAudit = audit;
    }


    public Salary getMy_tpl() {
        return my_tpl;
    }

    public void setMy_tpl(Salary my_tpl) {
        this.my_tpl = my_tpl;
    }

    public Salary getOther_tpl() {
        return other_tpl;
    }

    public void setOther_tpl(Salary other_tpl) {
        this.other_tpl = other_tpl;
    }

    public String getW_h_tpl_my() {
        return w_h_tpl_my;
    }

    public void setW_h_tpl_my(String w_h_tpl_my) {
        this.w_h_tpl_my = w_h_tpl_my;
    }

    public String getO_h_tpl_my() {
        return o_h_tpl_my;
    }

    public void setO_h_tpl_my(String o_h_tpl_my) {
        this.o_h_tpl_my = o_h_tpl_my;
    }

    public String getW_h_tpl_other() {
        return w_h_tpl_other;
    }

    public void setW_h_tpl_other(String w_h_tpl_other) {
        this.w_h_tpl_other = w_h_tpl_other;
    }

    public String getO_h_tpl_other() {
        return o_h_tpl_other;
    }

    public void setO_h_tpl_other(String o_h_tpl_other) {
        this.o_h_tpl_other = o_h_tpl_other;
    }

    public boolean isSalary() {
        return isSalary;
    }

    public void setSalary(boolean salary) {
        isSalary = salary;
    }

    public boolean isBold() {
        return isBold;
    }

    public void setBold(boolean bold) {
        isBold = bold;
    }
}
