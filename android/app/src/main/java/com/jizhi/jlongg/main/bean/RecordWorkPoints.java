package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * 记工 记账
 *
 * @author Xuj
 * @time 2016年2月3日 14:37:50
 * @Version 1.0
 */
public class RecordWorkPoints {
    /**
     * 总工天数
     */
    private float total_workday;
    /**
     * 总收入
     */
    private float total_amounts;
    /**
     * 加班时长
     */
    private float total_overtime;
    /**
     * 记账详情
     */
    private List<RecordAccount> list;
    /**
     * 总收入的单位（元 / 万元）
     */
    private String unit;
    /**
     * 待确认记账笔数
     */
    private int wait_confirm_num;
    /**
     * 本年收入
     */
    private AccountUtil y_total;
    /**
     * 本月收入
     */
    private AccountUtil m_total;
    /**
     * 未结工资
     */
    private AccountUtil b_total;
    /**
     * 1表示上次记账的角色和本次不同 弹出是否需要切换角色的提示
     */
    private int is_diff_role;

    /**
     * 今天是否已记帐 1：已记 0：未记
     */
    private int recorded;
    /**
     * 不需要对账的数据
     */
    private int[] normal;
    /**
     * 需要对账的数据
     */
    private int[] abnormal;
    /**
     * 今日考勤数
     */
    private int todaybill_count;
    /**
     * 昨日考勤数
     */
    private int yestodaybill_count;
    /**
     * 是否有同步记工小红点
     */
    private int is_red_flag;
    /**
     * 年、月
     */
    private String y_m;


    public float getTotal_workday() {
        return total_workday;
    }

    public void setTotal_workday(float total_workday) {
        this.total_workday = total_workday;
    }

    public float getTotal_amounts() {
        return total_amounts;
    }

    public void setTotal_amounts(float total_amounts) {
        this.total_amounts = total_amounts;
    }

    public float getTotal_overtime() {
        return total_overtime;
    }

    public void setTotal_overtime(float total_overtime) {
        this.total_overtime = total_overtime;
    }

    public List<RecordAccount> getList() {
        return list;
    }

    public void setList(List<RecordAccount> list) {
        this.list = list;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public int getWait_confirm_num() {
        return wait_confirm_num;
    }

    public void setWait_confirm_num(int wait_confirm_num) {
        this.wait_confirm_num = wait_confirm_num;
    }

    public AccountUtil getY_total() {
        return y_total;
    }

    public void setY_total(AccountUtil y_total) {
        this.y_total = y_total;
    }

    public AccountUtil getM_total() {
        return m_total;
    }

    public void setM_total(AccountUtil m_total) {
        this.m_total = m_total;
    }

    public AccountUtil getB_total() {
        return b_total;
    }

    public void setB_total(AccountUtil b_total) {
        this.b_total = b_total;
    }

    public int getRecorded() {
        return recorded;
    }

    public void setRecorded(int recorded) {
        this.recorded = recorded;
    }

    public int[] getNormal() {
        return normal;
    }

    public void setNormal(int[] normal) {
        this.normal = normal;
    }

    public int[] getAbnormal() {
        return abnormal;
    }

    public void setAbnormal(int[] abnormal) {
        this.abnormal = abnormal;
    }

    public int getTodaybill_count() {
        return todaybill_count;
    }

    public void setTodaybill_count(int todaybill_count) {
        this.todaybill_count = todaybill_count;
    }

    public int getYestodaybill_count() {
        return yestodaybill_count;
    }

    public void setYestodaybill_count(int yestodaybill_count) {
        this.yestodaybill_count = yestodaybill_count;
    }


    public String getY_m() {
        return y_m;
    }

    public void setY_m(String y_m) {
        this.y_m = y_m;
    }

    public int getIs_red_flag() {
        return is_red_flag;
    }

    public void setIs_red_flag(int is_red_flag) {
        this.is_red_flag = is_red_flag;
    }

    public int getIs_diff_role() {
        return is_diff_role;
    }

    public void setIs_diff_role(int is_diff_role) {
        this.is_diff_role = is_diff_role;
    }
}
