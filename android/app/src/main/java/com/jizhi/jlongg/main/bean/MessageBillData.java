package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * CName:消息记工列表数据
 * User: hcs
 * Date: 2016-09-02
 * Time: 10:52
 */
public class MessageBillData implements Serializable {
    private String date;//日期
    private String manhour;//上班工天
    private String overtime;//加班工天
    private String name;//班组成员名
    private List<MessageBillData> list;

    public List<MessageBillData> getList() {
        return list;
    }

    public void setList(List<MessageBillData> list) {
        this.list = list;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getManhour() {
        return manhour;
    }

    public void setManhour(String manhour) {
        this.manhour = manhour;
    }

    public String getOvertime() {
        return overtime;
    }

    public void setOvertime(String overtime) {
        this.overtime = overtime;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
