package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * Created by Administrator on 2018/1/11 0011.
 */

public class AccountDateList implements Serializable {
    /**
     * 日期
     */
    private String date;
    /**
     * 农历
     */
    private String date_turn;

    /**
     * 添加人员统计字段：mem_cnt
     */
    private int mem_cnt;
    /**
     * 列表数据
     */
    private ArrayList<PayRollList> list;
    /**
     * 列表数据
     */
    private ArrayList<PayRollList> date_list;

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public ArrayList<PayRollList> getList() {
        return list;
    }

    public void setList(ArrayList<PayRollList> list) {
        this.list = list;
    }

    public ArrayList<PayRollList> getDate_list() {
        return date_list;
    }

    public void setDate_list(ArrayList<PayRollList> date_list) {
        this.date_list = date_list;
    }

    public int getMem_cnt() {
        return mem_cnt;
    }

    public void setMem_cnt(int mem_cnt) {
        this.mem_cnt = mem_cnt;
    }

    public String getDate_turn() {
        return date_turn;
    }

    public void setDate_turn(String date_turn) {
        this.date_turn = date_turn;
    }
}
