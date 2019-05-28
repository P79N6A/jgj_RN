package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 记账单位
 */
public class AccountUtil implements Serializable {
    /**
     * 记账金额
     */
    private String total;
    /**
     * 记账单位 元、万元
     */
    private String unit;
    /**
     * 金额之前的单位
     */
    private String pre_unit;

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getPre_unit() {
        return pre_unit;
    }

    public void setPre_unit(String pre_unit) {
        this.pre_unit = pre_unit;
    }
}
