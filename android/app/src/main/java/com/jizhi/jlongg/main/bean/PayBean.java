package com.jizhi.jlongg.main.bean;

/**
 * 支付类型
 */

public class PayBean {
    private int pay_type;//  微信1；支付宝2（app端必传
    private int state;// 1(成功)， 2（失败）
    private String record_id;// 为请求后端返回的支付参数

    public int getPay_type() {
        return pay_type;
    }

    public void setPay_type(int pay_type) {
        this.pay_type = pay_type;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public String getRecord_id() {
        return record_id;
    }

    public void setRecord_id(String record_id) {
        this.record_id = record_id;
    }
}
