package com.jizhi.jlongg.main.bean;

import com.jizhi.jlongg.main.activity.WebSocketBaseParameter;

import java.util.List;

/**
 * 功能: 班组讨论消息
 * 作者：xuj
 * 时间: 2016-8-30 10:49
 */
public class GroupList extends WebSocketBaseParameter {
    /**
     * 项目名
     */
    private String pro_name;
    /**
     * 项目id
     */
    private String pro_id;
    /**
     * 讨论组详情
     */
    private List<GroupDiscussionInfo> list;

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public String getPro_id() {
        return pro_id;
    }

    public void setPro_id(String pro_id) {
        this.pro_id = pro_id;
    }

    public List<GroupDiscussionInfo> getList() {
        return list;
    }

    public void setList(List<GroupDiscussionInfo> list) {
        this.list = list;
    }

    public GroupList() {

    }

    public GroupList(String pro_name) {
        this.pro_name = pro_name;
    }
}
