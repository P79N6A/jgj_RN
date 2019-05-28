package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 发布记账记工参数3.2.0
 */

public class AccountInfoBean implements Serializable {
    //    private String id;//记账id
    private String record_id;//记账id
    private String uid;//记账对象uid
    private String name;//记账对象名称
    private String work_time;//上班时间
    private String over_time;//加班时间
    // 记账类型---1、点工  2、包工记账  3、借支 4、结算 5、包工记工天
    private String accounts_type;
    private String pid;//项目id
    private String pro_name;//项目名称
    private String date;//记账日期
    private String work_hour_tpl;//模版上班时间
    private String overtime_hour_tpl;//模版加班时间
    private String overtime_salary_tpl;//4.0.2表示按小时算加班工资
    private String salary_tpl;//模版金额
    private String sub_pro_name;//项目名称
    private String unit_price;//单价
    private String quantity;//数量
    private String units;//数量单位
    private String salary;//总金额
    private String p_s_time;//开工时间
    private String p_e_time;//完工时间
    private String text;//备注描述
    private String amounts;//借支金额
    private String imgs;//图片信息
    private String balance_amount;// 未结工资
    private String subsidy_amount;//补贴工资
    private String reward_amount;//奖金工资
    private String penalty_amount;//惩罚工资
    private String deduct_amount;// 抹零工资
    private int hour_type;


    private WorkBaseInfo month; //首页记账数据
    private WorkBaseInfo today; //首页记账数据
    private int tpl_id;
    public int getTpl_id() {
        return tpl_id;
    }

    public void setTpl_id(int tpl_id) {
        this.tpl_id = tpl_id;
    }

    public String getAmounts() {
        return amounts;
    }

    public void setAmounts(String amounts) {
        this.amounts = amounts;
    }
    //    public String getId() {
//        return id;
//    }
//
//    public void setId(String id) {
//        this.id = id;
//    }


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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getWork_time() {
        return work_time;
    }

    public void setWork_time(String work_time) {
        this.work_time = work_time;
    }

    public String getOver_time() {
        return over_time;
    }

    public void setOver_time(String over_time) {
        this.over_time = over_time;
    }

    public String getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(String accounts_type) {
        this.accounts_type = accounts_type;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
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

    public String getSalary_tpl() {
        return salary_tpl;
    }

    public void setSalary_tpl(String salary_tpl) {
        this.salary_tpl = salary_tpl;
    }

    public String getSub_pro_name() {
        return sub_pro_name;
    }

    public void setSub_pro_name(String sub_pro_name) {
        this.sub_pro_name = sub_pro_name;
    }

    public String getUnit_price() {
        return unit_price;
    }

    public void setUnit_price(String unit_price) {
        this.unit_price = unit_price;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    public String getUnits() {
        return units;
    }

    public void setUnits(String units) {
        this.units = units;
    }

    public String getSalary() {
        return salary;
    }

    public void setSalary(String salary) {
        this.salary = salary;
    }

    public String getP_s_time() {
        return p_s_time;
    }

    public void setP_s_time(String p_s_time) {
        this.p_s_time = p_s_time;
    }

    public String getP_e_time() {
        return p_e_time;
    }

    public void setP_e_time(String p_e_time) {
        this.p_e_time = p_e_time;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getRecord_id() {
        return record_id;
    }

    public void setRecord_id(String record_id) {
        this.record_id = record_id;
    }

    public String getImgs() {
        return imgs;
    }

    public void setImgs(String imgs) {
        this.imgs = imgs;
    }

    public String getBalance_amount() {
        return balance_amount;
    }

    public void setBalance_amount(String balance_amount) {
        this.balance_amount = balance_amount;
    }

    public String getSubsidy_amount() {
        return subsidy_amount;
    }

    public void setSubsidy_amount(String subsidy_amount) {
        this.subsidy_amount = subsidy_amount;
    }

    public String getReward_amount() {
        return reward_amount;
    }

    public void setReward_amount(String reward_amount) {
        this.reward_amount = reward_amount;
    }

    public String getPenalty_amount() {
        return penalty_amount;
    }

    public void setPenalty_amount(String penalty_amount) {
        this.penalty_amount = penalty_amount;
    }

    public String getDeduct_amount() {
        return deduct_amount;
    }

    public void setDeduct_amount(String deduct_amount) {
        this.deduct_amount = deduct_amount;
    }

    public WorkBaseInfo getMonth() {
        return month;
    }

    public void setMonth(WorkBaseInfo month) {
        this.month = month;
    }

    public WorkBaseInfo getToday() {
        return today;
    }

    public void setToday(WorkBaseInfo today) {
        this.today = today;
    }


    public int getHour_type() {
        return hour_type;
    }

    public void setHour_type(int hour_type) {
        this.hour_type = hour_type;
    }
}
