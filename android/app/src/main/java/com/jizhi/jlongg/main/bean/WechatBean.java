package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 微信用户信息
 */
public class WechatBean implements Serializable {
    private String ticket;
    private String expire_seconds;
    private String url;
    /**
     * 当前是否绑定 0，没有绑定 1，绑定成功
     */
    private int status;

    public String getTicket() {
        return ticket;
    }

    public void setTicket(String ticket) {
        this.ticket = ticket;
    }

    public String getExpire_seconds() {
        return expire_seconds;
    }

    public void setExpire_seconds(String expire_seconds) {
        this.expire_seconds = expire_seconds;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
