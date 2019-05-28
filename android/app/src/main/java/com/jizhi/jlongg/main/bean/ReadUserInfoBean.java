package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 已读未读实体
 */
public class ReadUserInfoBean implements Serializable {
    /**
     * readed 已读,unread未读
     */
    private String type;

    private List<UserInfo> list;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public List<UserInfo> getList() {
        return list;
    }

    public void setList(List<UserInfo> list) {
        this.list = list;
    }
}
