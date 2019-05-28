package com.jizhi.jlongg.main.bean;

import android.graphics.drawable.Drawable;

/**
 * 记账列表实体
 */

public class AccountBean extends BaseNetBean {
    //点工、包工、借支共有的item
    public static final String SELECTED_ROLE = "SELECTED_ROLE"; //选择工人、班组长item
    public static final String SELECTED_DATE = "SELECTED_DATE"; //选择日期
    public static final String SELECTED_PROJECT = "SELECTED_PROJECT"; //所属项目
    public static final String RECORD_REMARK = "RECORD_REMARK"; //备注
    public static final String ROLE_FM = "RECORD_FM"; //班组长/工头
    public static final String ROLE_WORKER = "ROLE_WORKER"; //工人
    public static final String ALL_MONEY = "all_money"; //工钱
    public static final String LINE = "line";
    //点工
    public static final String WORK_TIME = "WORK_TIME"; //上班时常
    public static final String OVER_TIME = "OVER_TIME"; //加班时常
    public static final String SALARY = "SALARY"; //工资标准
    public static final String SALARY_TOTAL = "SALARY_TOTAL"; //工资
    public static final String SALARY_MONEY = "SALARY_MONEY"; //借支,结算金额
    public static final String P_S_TIME = "P_S_TIME"; //开工时间按
    public static final String P_E_TIME = "P_E_TIME"; //完工时间
    //包工
    public static final String SUBENTRY_NAME = "SUBENTRY_NAME"; //分项名称
    public static final String UNIT_PRICE = "UNIT_PRICE"; //单价
    public static final String COUNT = "COUNT"; //数量
    public static final String CONTRACTOT_TYPE = "contractor_type"; //1承包 2。分包
    //借支
    public static final String SUM_MONEY = "SUM_MONEY"; //金额
    //结算
    public static final String WAGE_UNSET = "wage_unset"; //未结工资
    public static final String WAGE_S_R_F = "wage_s_r_f"; //补贴，奖励，罚款金额
    public static final String WAGE_SUBSIDY = "wage_subsidy"; //补贴金额
    public static final String WAGE_REWARD = "wage_reward"; //奖励金额
    public static final String WAGE_FINE = "wage_fine"; //罚款金额
    public static final String WAGE_INCOME_MONEY = "wage_income_money"; //本次实收收金额
    public static final String WAGE_DEL = "wage_del"; //抹零金额
    public static final String WAGE_WAGES = "wage_wages"; //本次结算金额
    public static final String WAGE_SURPLUS_UNSET = "wage_supplus_unset"; //剩余未结金额
    public static final int TYPE_EDIT = 1;

    public static final int TYPE_TEXT = 2;

    //左侧图片
    private Drawable icon_drawable;
    //左侧文字
    private String left_text;
    //右侧提示文字
    private String right_hint;
    //右边显示内容
    private String right_value;
    //是否显示右侧内容
    private boolean isShowArrow;
    //右侧文本类型 1.textview  2.edittext
    private int text_type;
    //右侧文字颜色
    private int text_color;
    //类型
    private String item_type;
    //是否可以点击 true
    private boolean click;
    //是否显示10dp分割线
    private boolean isShowLine10;
    private String company;
    private boolean isExpanded;

    private String balance_amount;//未结工资
    private int un_salary_tpl;//未结数量
    private double wage_subsidy;//补贴金额
    private double wage_reward; //奖励金额
    private double wage_fine; //罚款金额
    private String bill_desc;//存在待确认记工
    //1 ：一个工 2：半个工 3：正常
    private int oneWork;
    /**
     * 上班工时
     */
    public String working_hours;
    /**
     * 加班工时
     */
    public String overtime_hours;

    public AccountBean(String item_type, int text_type, String right_value, int text_color, boolean isShowArrow, String left_text, String right_hint, Drawable icon_drawable, boolean click, boolean isShowLine10) {
        this.item_type = item_type;
        this.text_type = text_type;
        this.right_value = right_value;
        this.text_color = text_color;
        this.isShowArrow = isShowArrow;
        this.left_text = left_text;
        this.right_hint = right_hint;
        this.icon_drawable = icon_drawable;
        this.click = click;
        this.isShowLine10 = isShowLine10;
    }

    public AccountBean(String left_text, String right_hint, String item_type) {
        this.left_text = left_text;
        this.right_hint = right_hint;
        this.item_type = item_type;
    }

    public boolean isExpanded() {
        return isExpanded;
    }

    public void setExpanded(boolean expanded) {
        isExpanded = expanded;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public boolean isShowLine10() {
        return isShowLine10;
    }

    public void setShowLine10(boolean showLine10) {
        isShowLine10 = showLine10;
    }

    public boolean isClick() {
        return click;
    }

    public void setClick(boolean click) {
        this.click = click;
    }

    public String getItem_type() {
        return item_type;
    }

    public void setItem_type(String item_type) {
        this.item_type = item_type;
    }

    public Drawable getIcon_drawable() {
        return icon_drawable;
    }

    public void setIcon_drawable(Drawable icon_drawable) {
        this.icon_drawable = icon_drawable;
    }

    public String getLeft_text() {
        return left_text;
    }

    public void setLeft_text(String left_text) {
        this.left_text = left_text;
    }

    public String getRight_hint() {
        return right_hint;
    }

    public void setRight_hint(String right_hint) {
        this.right_hint = right_hint;
    }

    public String getRight_value() {
        return right_value;
    }

    public void setRight_value(String right_value) {
        this.right_value = right_value;
    }

    public boolean isShowArrow() {
        return isShowArrow;
    }

    public void setShowArrow(boolean showArrow) {
        isShowArrow = showArrow;
    }

    public int getText_type() {
        return text_type;
    }

    public void setText_type(int text_type) {
        this.text_type = text_type;
    }

    public int getText_color() {
        return text_color;
    }

    public void setText_color(int text_color) {
        this.text_color = text_color;
    }

    public String getBalance_amount() {
        return balance_amount;
    }

    public void setBalance_amount(String balance_amount) {
        this.balance_amount = balance_amount;
    }

    public int getUn_salary_tpl() {
        return un_salary_tpl;
    }

    public void setUn_salary_tpl(int un_salary_tpl) {
        this.un_salary_tpl = un_salary_tpl;
    }

    public double getWage_subsidy() {
        return wage_subsidy;
    }

    public void setWage_subsidy(double wage_subsidy) {
        this.wage_subsidy = wage_subsidy;
    }

    public double getWage_reward() {
        return wage_reward;
    }

    public void setWage_reward(double wage_reward) {
        this.wage_reward = wage_reward;
    }

    public double getWage_fine() {
        return wage_fine;
    }

    public void setWage_fine(double wage_fine) {
        this.wage_fine = wage_fine;
    }


    public String getBill_desc() {
        return bill_desc;
    }

    public void setBill_desc(String bill_desc) {
        this.bill_desc = bill_desc;
    }

    public int getOneWork() {
        return oneWork;
    }

    public void setOneWork(int oneWork) {
        this.oneWork = oneWork;
    }

    public String getWorking_hours() {
        return working_hours;
    }

    public void setWorking_hours(String working_hours) {
        this.working_hours = working_hours;
    }

    public String getOvertime_hours() {
        return overtime_hours;
    }

    public void setOvertime_hours(String overtime_hours) {
        this.overtime_hours = overtime_hours;
    }
}
