package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 记功类型
 * huchangsheng：Administrator on 2016/2/22 14:41
 */
public class AccountsType implements Serializable {
    /**
     * 1:点工 2:包工 3:借支  4:结算
     */
    private int code;
    /**
     * 文本
     */
    private String txt;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getTxt() {
        return txt;
    }

    public void setTxt(String txt) {
        this.txt = txt;
    }
}
