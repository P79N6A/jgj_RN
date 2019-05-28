package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.ArrayList;

public class TurnOutForWork implements Serializable {
    /**
     * 未确认的记工笔数
     */
    private int num;
    /**
     * 出勤公示
     */
    private ArrayList<AccountDateList> list;


    public ArrayList<AccountDateList> getList() {
        return list;
    }

    public void setList(ArrayList<AccountDateList> list) {
        this.list = list;
    }

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }
}
