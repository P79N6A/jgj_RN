package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 功能: WebSocket 基础类  所有的返回都经过此
 * 作者：Xuj
 * 时间: 2016年8月29日 15:33:06
 */
public class WebSocketRequest implements Serializable {
    /**
     * 分发路径
     */
    private String action;
    /**
     * 网络请求状态
     */
    private int state;
    /**
     * 控制器
     */
    private String ctrl;

    private String errmsg;
    private String errno;

    public String getErrmsg() {
        return errmsg;
    }

    public void setErrmsg(String errmsg) {
        this.errmsg = errmsg;
    }

    public String getErrno() {
        return errno;
    }

    public void setErrno(String errno) {
        this.errno = errno;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public String getCtrl() {
        return ctrl;
    }

    public void setCtrl(String ctrl) {
        this.ctrl = ctrl;
    }

    @Override
    public String toString() {
        return "WebSocketRequest{" +
                "action='" + action + '\'' +
                ", state=" + state +
                ", ctrl='" + ctrl + '\'' +
                '}';
    }
}
