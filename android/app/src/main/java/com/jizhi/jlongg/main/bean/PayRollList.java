package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 工资清单 列表
 * huchangsheng：Xuj on 2016/2/22 14:41
 */
public class PayRollList extends WorkDetail implements Serializable {


    /**
     * 本月应收、应付
     */
    private float total_month;
    /**
     * 月
     */
    private int month;
    /**
     * 年
     */
    private int year;
    /**
     * 差帐总数
     */
    private int t_poor;
    /**
     * 应收总和
     */
    private float total_income;
    /**
     * 借支总和
     */
    private float total_expend;
    /**
     * 结算总和
     */
    private float total_balance;
    /**
     * 上班合计
     */
    private float total_manhour;
    /**
     * 加班合计
     */
    private float total_overtime;
    /**
     * 上班时长描述
     */
    private String total_manhour_txt;
    /**
     * 加班时长描述
     */
    private String total_overtime_txt;
    /**
     * 记账对象名称
     */
    private String name;
    /**
     * 工资清单列表
     */
    private List<PayRollItem> list;
    /**
     * 日期
     */
    private String date_txt;
    /**
     * 阴历
     */
    private String date_turn;
    /**
     * 结算总和 新记账单位
     */
    private AccountUtil new_total_balance;
    /**
     * 借支总和 新记账单位
     */
    private AccountUtil new_total_expend;
    /**
     * 应收总和 新记账单位
     */
    private AccountUtil new_total_income;
    /**
     * 总金额 新记账单位
     */
    private AccountUtil new_total;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    public float getTotal_manhour() {
        return total_manhour;
    }

    public void setTotal_manhour(float total_manhour) {
        this.total_manhour = total_manhour;
    }

    public float getTotal_overtime() {
        return total_overtime;
    }

    public void setTotal_overtime(float total_overtime) {
        this.total_overtime = total_overtime;
    }


    public float getTotal() {
        return total;
    }

    public void setTotal(float total) {
        this.total = total;
    }


    public float getTotal_income() {
        return total_income;
    }

    public void setTotal_income(float total_income) {
        this.total_income = total_income;
    }

    public float getTotal_expend() {
        return total_expend;
    }

    public void setTotal_expend(float total_expend) {
        this.total_expend = total_expend;
    }

    public int getT_poor() {
        return t_poor;
    }

    public void setT_poor(int t_poor) {
        this.t_poor = t_poor;
    }

    public List<PayRollItem> getList() {
        return list;
    }

    public void setList(List<PayRollItem> list) {
        this.list = list;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public float getTotal_balance() {
        return total_balance;
    }

    public void setTotal_balance(float total_balance) {
        this.total_balance = total_balance;
    }

    public float getTotal_month() {
        return total_month;
    }

    public void setTotal_month(float total_month) {
        this.total_month = total_month;
    }


    public String getDate_txt() {
        return date_txt;
    }

    public void setDate_txt(String date_txt) {
        this.date_txt = date_txt;
    }

    public String getDate_turn() {
        return date_turn;
    }

    public void setDate_turn(String date_turn) {
        this.date_turn = date_turn;
    }



    public String getTotal_manhour_txt() {
        return total_manhour_txt;
    }

    public void setTotal_manhour_txt(String total_manhour_txt) {
        this.total_manhour_txt = total_manhour_txt;
    }

    public String getTotal_overtime_txt() {
        return total_overtime_txt;
    }

    public void setTotal_overtime_txt(String total_overtime_txt) {
        this.total_overtime_txt = total_overtime_txt;
    }





    public AccountUtil getNew_total_balance() {
        return new_total_balance;
    }

    public void setNew_total_balance(AccountUtil new_total_balance) {
        this.new_total_balance = new_total_balance;
    }

    public AccountUtil getNew_total_expend() {
        return new_total_expend;
    }

    public void setNew_total_expend(AccountUtil new_total_expend) {
        this.new_total_expend = new_total_expend;
    }

    public AccountUtil getNew_total_income() {
        return new_total_income;
    }

    public void setNew_total_income(AccountUtil new_total_income) {
        this.new_total_income = new_total_income;
    }

    public AccountUtil getNew_total() {
        return new_total;
    }

    public void setNew_total(AccountUtil new_total) {
        this.new_total = new_total;
    }

}
