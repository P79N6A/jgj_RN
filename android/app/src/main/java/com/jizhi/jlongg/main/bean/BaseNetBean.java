package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 父bean 存取网络连接相关 所有java bean 都继承此类
 *
 * @author Xuj
 * @version 1.0
 * @time 2015年11月28日 10:58:29
 */
public class BaseNetBean implements Serializable {
    /**
     * 服务器状态码
     */
    private int state;
    /**
     * 服务器返回的错误信息
     */
    private String errmsg;
    /**
     * 服务器返回的错误编码
     */
    private String errno;
    private String msg;
    private String code;


    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

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

}
