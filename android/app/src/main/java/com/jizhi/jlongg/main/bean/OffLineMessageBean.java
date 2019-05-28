package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 离线消息列表
 */
public class OffLineMessageBean implements Serializable {
    /**
     * 消息类型 group,team ,singleChat
     */
    private String class_type;
    /**
     * 组id
     */
    private String group_id;
    /**
     * 单个组消息列表
     */
    private List<MessageBean> list;

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

    public List<MessageBean> getList() {
        return list;
    }

    public void setList(List<MessageBean> list) {
        this.list = list;
    }
}
