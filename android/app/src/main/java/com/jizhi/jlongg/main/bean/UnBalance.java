package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * 未结工资
 * huchangsheng：Administrator on 2016/2/22 14:41
 */
public class UnBalance implements Serializable {
    /**
     * 未结总金额
     */
    private String total_amount;
    /**
     * 未设置金额模板数
     */
    private int un_salary_tpl;
    /**
     * 未结工资列表数据
     */
    private ArrayList<WorkBaseInfo> list;


    public String getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(String total_amount) {
        this.total_amount = total_amount;
    }

    public int getUn_salary_tpl() {
        return un_salary_tpl;
    }

    public void setUn_salary_tpl(int un_salary_tpl) {
        this.un_salary_tpl = un_salary_tpl;
    }

    public ArrayList<WorkBaseInfo> getList() {
        return list;
    }

    public void setList(ArrayList<WorkBaseInfo> list) {
        this.list = list;
    }
}
