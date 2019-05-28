package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 记账清单
 *
 * @Author xuj
 * @date 2016年2月25日 16:52:58
 */
public class BillingList implements Serializable {
    /**
     * 年
     */
    private int year;
    /**
     * 月
     */
    private int month;
    /**
     * 当月总收入
     */
    private String m_total_income;
    /**
     * 当月总借支
     */
    private String m_total_expend;
    /**
     * 当月实际收入
     */
    private String m_total;
    /**
     * 记工清单详情当月总收入
     */
    private String t_total;
    /**
     * 如:2016年02月收入
     */
    private String month_txt;
    /**
     * 状态 是否欠钱
     */
    private String month_total_txt;
    /**
     * 记工详情
     */
    private List<BillingListDetail> list;
    /**
     * 项目详情
     */
    private List<Project> pro_list;

    private List<WorkerDay> workday;

    /**
     * 自己uid
     */
    private int cur_uid;

    /**
     * 是否选择
     */
    private boolean isSelected = false;

    public List<WorkerDay> getWorkday() {
        return workday;
    }

    public void setWorkday(List<WorkerDay> workday) {
        this.workday = workday;
    }

    public String getMonth_total_txt() {
        return month_total_txt;
    }

    public void setMonth_total_txt(String month_total_txt) {
        this.month_total_txt = month_total_txt;
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

    public List<BillingListDetail> getList() {
        return list;
    }

    public void setList(List<BillingListDetail> list) {
        this.list = list;
    }

    public String getMonth_txt() {
        return month_txt;
    }

    public void setMonth_txt(String month_txt) {
        this.month_txt = month_txt;
    }

    public List<Project> getPro_list() {
        return pro_list;
    }

    public void setPro_list(List<Project> pro_list) {
        this.pro_list = pro_list;
    }


    public boolean isSelected() {
        return isSelected;
    }

    public void setIsSelected(boolean isSelected) {
        this.isSelected = isSelected;
    }

    public String getM_total_income() {
        return m_total_income;
    }

    public void setM_total_income(String m_total_income) {
        this.m_total_income = m_total_income;
    }

    public String getM_total_expend() {
        return m_total_expend;
    }

    public void setM_total_expend(String m_total_expend) {
        this.m_total_expend = m_total_expend;
    }

    public String getM_total() {
        return m_total;
    }

    public void setM_total(String m_total) {
        this.m_total = m_total;
    }

    public String getT_total() {
        return t_total;
    }

    public void setT_total(String t_total) {
        this.t_total = t_total;
    }

    public int getCur_uid() {
        return cur_uid;
    }

    public void setCur_uid(int cur_uid) {
        this.cur_uid = cur_uid;
    }
}
