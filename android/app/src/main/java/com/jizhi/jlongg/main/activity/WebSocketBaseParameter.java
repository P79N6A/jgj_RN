package com.jizhi.jlongg.main.activity;

import org.litepal.crud.LitePalSupport;

import java.io.Serializable;

/**
 * 功能: WebSocket基础参数
 * 作者：Xuj
 * 时间: 2016年8月27日 17:03:14
 */
public class WebSocketBaseParameter extends LitePalSupport implements Serializable {
    /**
     * token
     */
    public String token;
    /**
     * 值notice 控制器名
     */
    public String ctrl;
    /**
     * 值noticeList
     */
    public String action;

    /**
     * 平台类型 person 个人端 manage 管理端
     */
    public String client_type = "person";
    /**
     * 消息平台
     */
    public String os = "A";
    /**
     * 应用版本
     */
    public String ver;

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getCtrl() {
        return ctrl;
    }

    public void setCtrl(String ctrl) {
        this.ctrl = ctrl;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getClient_type() {
        return client_type;
    }

    public void setClient_type(String client_type) {
        this.client_type = client_type;
    }

    public String getOs() {
        return os;
    }

    public void setOs(String os) {
        this.os = os;
    }

    public String getVer() {
        return ver;
    }

    public void setVer(String ver) {
        this.ver = ver;
    }
}
