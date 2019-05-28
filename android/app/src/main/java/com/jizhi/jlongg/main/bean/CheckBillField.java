package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 差帐弹出框字段
 * huchangsheng：Administrator on 2016/2/22 14:41
 */
public class CheckBillField implements Serializable {
    /**
     * 字段名称
     */
    private String fieldName;
    /**
     * 左边显示的内容
     */
    private String fieldKey;
    /**
     * 右边显示的内容
     */
    private String fieldValue;
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

    public CheckBillField(String fieldName, int type) {
        this.fieldName = fieldName;
        this.type = type;
    }

    public CheckBillField(String fieldName, String fieldKey, String fieldValue, int type) {
        this.fieldName = fieldName;
        this.fieldKey = fieldKey;
        this.fieldValue = fieldValue;
        this.type = type;
    }

    public CheckBillField(String fieldName, Salary my_tpl, Salary other_tpl, int type) {
        this.fieldName = fieldName;
        this.my_tpl = my_tpl;
        this.other_tpl = other_tpl;
        this.type = type;
    }
    public CheckBillField(CheckBillAllAccount workDetail, int type) {
        this.workDetail = workDetail;
        this.type = type;
    }
    public CheckBillField() {
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

    public String getFieldKey() {
        return fieldKey;
    }

    public void setFieldKey(String fieldKey) {
        this.fieldKey = fieldKey;
    }

    public String getFieldValue() {
        return fieldValue;
    }

    public void setFieldValue(String fieldValue) {
        this.fieldValue = fieldValue;
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
}
