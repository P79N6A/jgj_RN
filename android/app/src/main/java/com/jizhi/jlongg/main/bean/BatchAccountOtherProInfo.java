package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

public class BatchAccountOtherProInfo implements Serializable {
    /**
     * 记账信息描述
     */
    private String msg_text;
    /**
     * 记账类型
     */
    private String accounts_type;


    public String getMsg_text() {
        return msg_text;
    }

    public void setMsg_text(String msg_text) {
        this.msg_text = msg_text;
    }

    public String getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(String accounts_type) {
        this.accounts_type = accounts_type;
    }
}