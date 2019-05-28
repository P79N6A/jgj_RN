package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 薪资模板
 * @author hcs
 * @time 2018年11月23日 17:13:55
 * @version 3.4.1
 */
public class SalaryTpl implements Serializable {
    //
    private String uid;  //用户id
    private String salary_tpl;  //金额
    private String work_hour_tpl;  //上班时间
    private String overtime_hour_tpl;  //加班时间
    private String accounts_type;  //类型
    private String overtime_salary_tpl;//4.0.2表示按小时算加班工资
    private int hour_type;// 1:按小时计费；0:按工天

    public int getHour_type() {
        return hour_type;
    }

    public void setHour_type(int hour_type) {
        this.hour_type = hour_type;
    }

    public String getOvertime_salary_tpl() {
        return overtime_salary_tpl;
    }

    public void setOvertime_salary_tpl(String overtime_salary_tpl) {
        this.overtime_salary_tpl = overtime_salary_tpl;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getSalary_tpl() {
        return salary_tpl;
    }

    public void setSalary_tpl(String salary_tpl) {
        this.salary_tpl = salary_tpl;
    }

    public String getWork_hour_tpl() {
        return work_hour_tpl;
    }

    public void setWork_hour_tpl(String work_hour_tpl) {
        this.work_hour_tpl = work_hour_tpl;
    }

    public String getOvertime_hour_tpl() {
        return overtime_hour_tpl;
    }

    public void setOvertime_hour_tpl(String overtime_hour_tpl) {
        this.overtime_hour_tpl = overtime_hour_tpl;
    }

    public String getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(String accounts_type) {
        this.accounts_type = accounts_type;
    }
}
