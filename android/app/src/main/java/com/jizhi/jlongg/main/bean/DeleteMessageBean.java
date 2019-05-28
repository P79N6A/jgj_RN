package com.jizhi.jlongg.main.bean;

import org.litepal.crud.LitePalSupport;

import java.io.Serializable;

/**
 * 清空的消息对象
 */
public class DeleteMessageBean extends LitePalSupport implements Serializable {
    public DeleteMessageBean(String class_type, String group_id, long msg_id, String message_uid) {
        this.class_type = class_type;
        this.group_id = group_id;
        this.msg_id = msg_id;
        this.message_uid = message_uid;
    }

    /**
     * 消息类型 group,team ,singleChat
     */
    private String class_type;
    /**
     * 组id
     */
    private String group_id;
    /**
     * 消息id
     */
    private long msg_id;

    /**
     * 当前用户uid
     */
    private String message_uid;

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

    public long getMsg_id() {
        return msg_id;
    }

    public void setMsg_id(long msg_id) {
        this.msg_id = msg_id;
    }

    public String getMessage_uid() {
        return message_uid;
    }

    public void setMessage_uid(String message_uid) {
        this.message_uid = message_uid;
    }
}
