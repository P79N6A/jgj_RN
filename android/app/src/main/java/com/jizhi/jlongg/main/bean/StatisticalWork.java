package com.jizhi.jlongg.main.bean;

import java.util.ArrayList;

/**
 * 记工统计
 */

public class StatisticalWork extends WorkBaseInfo {
    /**
     * 记账人名称
     */
    private String name;
    /**
     * 未结算金额
     */
    private String balance_amount;
    /**
     * 点工信息
     */
    private WorkBaseInfo work_type;
    /**
     * 包工信息
     */
    private WorkBaseInfo contract_type;

    /**
     * 包工承包信息
     */
    private WorkBaseInfo contract_type_one;
    /**
     * 包工分包信息
     */
    private WorkBaseInfo contract_type_two;
    /**
     * 包工记工天
     */
    private WorkBaseInfo attendance_type;
    /**
     * 借支信息
     */
    private WorkBaseInfo expend_type;
    /**
     * 结算信息
     */
    private WorkBaseInfo balance_type;
    /**
     * 记工统计列表数据(非月统计)
     */
    private ArrayList<StatisticalWork> list;
    /**
     * 记工统计列表数据(月统计)
     */
    private ArrayList<StatisticalWork> month_list;
    /**
     * 记工统计列表数据(月统计)
     */
    private StatisticalWork month;
    /**
     * 记账日期
     */
    private String date;
    /**
     * id
     */
    private String class_type_id;
    /**
     * 项目类型id
     */
    private String class_type_target_id;

    private String target_name;
    /**
     *
     */
    private String pro_name;
    /**
     * 记账类型名称
     */
    private String accounts_type_name;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBalance_amount() {
        return balance_amount;
    }

    public void setBalance_amount(String balance_amount) {
        this.balance_amount = balance_amount;
    }

    public WorkBaseInfo getWork_type() {
        return work_type;
    }

    public void setWork_type(WorkBaseInfo work_type) {
        this.work_type = work_type;
    }

    public WorkBaseInfo getContract_type() {
        return contract_type;
    }

    public void setContract_type(WorkBaseInfo contract_type) {
        this.contract_type = contract_type;
    }

    public WorkBaseInfo getExpend_type() {
        return expend_type;
    }

    public void setExpend_type(WorkBaseInfo expend_type) {
        this.expend_type = expend_type;
    }

    public WorkBaseInfo getBalance_type() {
        return balance_type;
    }

    public void setBalance_type(WorkBaseInfo balance_type) {
        this.balance_type = balance_type;
    }

    public ArrayList<StatisticalWork> getList() {
        return list;
    }

    public void setList(ArrayList<StatisticalWork> list) {
        this.list = list;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public ArrayList<StatisticalWork> getMonth_list() {
        return month_list;
    }

    public void setMonth_list(ArrayList<StatisticalWork> month_list) {
        this.month_list = month_list;
    }

    public StatisticalWork getMonth() {
        return month;
    }

    public void setMonth(StatisticalWork month) {
        this.month = month;
    }

    public String getClass_type_id() {
        return class_type_id;
    }

    public void setClass_type_id(String class_type_id) {
        this.class_type_id = class_type_id;
    }

    public String getTarget_name() {
        return target_name;
    }

    public void setTarget_name(String target_name) {
        this.target_name = target_name;
    }

    public String getClass_type_target_id() {
        return class_type_target_id;
    }

    public void setClass_type_target_id(String class_type_target_id) {
        this.class_type_target_id = class_type_target_id;
    }

    public WorkBaseInfo getAttendance_type() {
        return attendance_type;
    }

    public void setAttendance_type(WorkBaseInfo attendance_type) {
        this.attendance_type = attendance_type;
    }

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public String getAccounts_type_name() {
        return accounts_type_name;
    }

    public void setAccounts_type_name(String accounts_type_name) {
        this.accounts_type_name = accounts_type_name;
    }

    public WorkBaseInfo getContract_type_one() {
        return contract_type_one;
    }

    public void setContract_type_one(WorkBaseInfo contract_type_one) {
        this.contract_type_one = contract_type_one;
    }

    public WorkBaseInfo getContract_type_two() {
        return contract_type_two;
    }

    public void setContract_type_two(WorkBaseInfo contract_type_two) {
        this.contract_type_two = contract_type_two;
    }
}
