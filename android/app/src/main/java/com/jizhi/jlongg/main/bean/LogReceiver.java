package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Administrator on 2018/3/30 0030.
 */

public class LogReceiver implements Serializable{
    //接收人uid
    private String receiver_uid;
    //接收人个数
    private String allnum;
    private List<GroupMemberInfo> list;
    public String getReceiver_uid() {
        return receiver_uid;
    }

    public void setReceiver_uid(String receiver_uid) {
        this.receiver_uid = receiver_uid;
    }

    public String getAllnum() {
        return allnum;
    }

    public void setAllnum(String allnum) {
        this.allnum = allnum;
    }

    public List<GroupMemberInfo> getList() {
        return list;
    }

    public void setList(List<GroupMemberInfo> list) {
        this.list = list;
    }
}
