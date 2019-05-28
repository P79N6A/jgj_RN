package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 包工差帐-包工标准信息
 */

public class CheckBillAllAccount implements Serializable {
    private String unitprice_my;
    private String unitprice_other;
    private String quantities_my;
    private String quantities_other;

    public CheckBillAllAccount(String unitprice_my, String unitprice_other, String quantities_my, String quantities_other) {
        this.unitprice_my = unitprice_my;
        this.unitprice_other = unitprice_other;
        this.quantities_my = quantities_my;
        this.quantities_other = quantities_other;
    }
    public CheckBillAllAccount() {
    }
    public String getUnitprice_my() {
        return unitprice_my;
    }

    public void setUnitprice_my(String unitprice_my) {
        this.unitprice_my = unitprice_my;
    }

    public String getUnitprice_other() {
        return unitprice_other;
    }

    public void setUnitprice_other(String unitprice_other) {
        this.unitprice_other = unitprice_other;
    }

    public String getQuantities_my() {
        return quantities_my;
    }

    public void setQuantities_my(String quantities_my) {
        this.quantities_my = quantities_my;
    }

    public String getQuantities_other() {
        return quantities_other;
    }

    public void setQuantities_other(String quantities_other) {
        this.quantities_other = quantities_other;
    }
}
