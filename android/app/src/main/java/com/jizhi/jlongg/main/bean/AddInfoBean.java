package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 新增记账信息
 */
public class AddInfoBean implements Serializable{
    //阳历
    private  String date;
    //农历
    private  String nl_date;
    //记账笔数
    private  int num;

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getNl_date() {
        return nl_date;
    }

    public void setNl_date(String nl_date) {
        this.nl_date = nl_date;
    }

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }
}

