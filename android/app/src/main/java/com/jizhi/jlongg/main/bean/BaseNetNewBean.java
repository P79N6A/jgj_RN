package com.jizhi.jlongg.main.bean;

import org.litepal.crud.LitePalSupport;

import java.io.Serializable;

/**
 * 父bean 存取网络连接相关 所有java bean 都继承此类
 *
 * @author Xuj
 * @version 1.0
 * @time 2015年11月28日 10:58:29
 */
public class BaseNetNewBean extends LitePalSupport implements Serializable {
    /**
     * 服务器状态码
     */
    private int code;
    /**
     * 服务器返回的错误信息
     */
    private String msg;
    /**
     * 主要是Socket 区分发送的方法
     */
    private String action;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }
}
