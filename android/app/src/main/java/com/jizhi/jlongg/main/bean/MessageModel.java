package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 消息模板信息
 *
 * @author Xuj
 * @version 1.0
 * @time 2017年2月24日10:07:33
 */
public class MessageModel implements Serializable {

    private String msg_text;

    private String msg_type;

    public String getMsg_text() {
        return msg_text;
    }

    public void setMsg_text(String msg_text) {
        this.msg_text = msg_text;
    }

    public String getMsg_type() {
        return msg_type;
    }

    public void setMsg_type(String msg_type) {
        this.msg_type = msg_type;
    }
}
