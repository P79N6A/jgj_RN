package com.jizhi.jlongg.main.bean;

/**
 * 记功类型
 * xuj：Administrator on 2016/2/22 14:41
 */
public class FriendValidate extends UserInfo {
    /**
     * 验证信息
     */
    private String msg_text;
    /**
     * 1：未加入,2:已加入，3：已过期
     */
    private int status;


    public FriendValidate(){

    }

    public String getMsg_text() {
        return msg_text;
    }

    public void setMsg_text(String msg_text) {
        this.msg_text = msg_text;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

}
