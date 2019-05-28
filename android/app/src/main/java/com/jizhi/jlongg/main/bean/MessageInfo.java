package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 回执消息用的消息类
 */
public class MessageInfo implements Serializable {
    private String msg_id;
    private String class_type;
    private String group_id;
    private String msg_sender;

    public String getMsg_sender() {
        return msg_sender;
    }

    public void setMsg_sender(String msg_sender) {
        this.msg_sender = msg_sender;
    }

    public String getMsg_id() {
        return msg_id;
    }

    public void setMsg_id(String msg_id) {
        this.msg_id = msg_id;
    }

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }
}
