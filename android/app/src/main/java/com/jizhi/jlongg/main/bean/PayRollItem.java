package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 工资清单 列表
 * huchangsheng：Xuj on 2016/2/22 14:41
 */
public class PayRollItem implements Serializable {
    /**
     * 年
     */
    private int year;
    /**
     * 日期
     */
    private int date;
    /**
     * 列表数据
     */
    private List<PayRollList> list;


    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public List<PayRollList> getList() {
        return list;
    }

    public void setList(List<PayRollList> list) {
        this.list = list;
    }

    public int getDate() {
        return date;
    }

    public void setDate(int date) {
        this.date = date;
    }
}
