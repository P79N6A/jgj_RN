package com.jizhi.jlongg.main.bean;

/**
 * 差帐
 * huchangsheng：Administrator on 2016/2/26 11:41
 */
public class DiffBill {


    /* 我的差帐 1表示已经删除了项目 需要显示成-.- */
    private int del_diff_left;
    /* 对方的差帐 1表示已经删除了项目 需要显示成-.- */
    private int del_diff_right;


    private int id;//本条记账的id
    private String main_name;//当前用户
    private int main_role;//当前角色1工友 2工头
    private int second_role;//对方角色1工友 2工头
    private int create_by_role;//账单创建角色
    private String second_name;//对方姓名
    private double main_s_tpl;//我的记账模板金额
    private double main_w_h_tpl;//我的记账模板正常工作时长
    private double main_o_h_tpl;//我的记账模板加班工作时长
    private double second_s_tpl;//对方记账模板金额
    private double second_w_h_tpl;//对方记账模板正常工作时长
    private double second_o_h_tpl;//对方记账模板加班工作时长
    //4.0.2
    private int main_hour_type;
    private int second_hour_type;
    private double main_o_s_tpl;
    private double second_o_s_tpl;
//
//    private float second_set_amount;//对方记账总额
//    private float main_set_amount;//我的记账总额


    private float main_manhour;//我的记账正常时长(时为单位)（当记账为点工时返回）
    private float main_manhour_hours;//我的记账正常时长(工为单位)（当记账为点工时返回）
    private float main_overtime;//我的记账加班时长(时为单位)（当记账为点工时返回）
    private float main_overtime_hours;//我的记账加班时长(工为单位)（当记账为点工时返回）
    private float second_manhour;//对方的记账正常时长(时为单位)（当记账为点工时返回）
    private float second_manhour_hours;//对方的记账正常时长(工为单位)（当记账为点工时返回）
    private float second_overtime;//对方记账加班时长(时为单位)（当记账为点工时返回）
    private float second_overtime_hours;//对方记账加班时长(工为单位)（当记账为点工时返回）
    private float main_set_unitprice;//我的记账单价（当记账为包工时返回）
    private float main_set_quantities;//我的记账数量（当记账为包工时返回）
    private float second_set_unitprice;//对方记账单价（当记账为包工时返回）
    private float second_set_quantities;//对方记账数量（当记账为包工时返回）
    private String date;
    private int show_lines;//1:左，2右

    private int main_del;//当前用户 删除
    private int second_del;//对方 删除
    private int main_line;//当前用户 显示‘--’ 1：表示显示
    private int second_line;//对方 显示‘--’  1：表示显示
    private String describe;//描述


    //结算
    private float main_balance_amount;//未结算金额
    private float main_subsidy_amount;//补贴金额
    private float main_reward_amount;//奖金金额
    private float main_penalty_amount;//惩罚金额
    private float main_deduct_amount;//抹零金额
    private float main_pay_amount; //结算的支付金额
    private float main_set_amount; //结算的结算金额
    private float second_balance_amount;//未结算金额
    private float second_subsidy_amount;//补贴金额
    private float second_reward_amount;//奖金金额
    private float second_penalty_amount;//惩罚金额
    private float second_deduct_amount;//抹零金额
    private float second_pay_amount; //结算的支付金额
    private float second_set_amount; //结算的结算金额

    private int accounts_type;
    private String second_name_mark;

    public int getMain_hour_type() {
        return main_hour_type;
    }

    public void setMain_hour_type(int main_hour_type) {
        this.main_hour_type = main_hour_type;
    }

    public int getSecond_hour_type() {
        return second_hour_type;
    }

    public void setSecond_hour_type(int second_hour_type) {
        this.second_hour_type = second_hour_type;
    }

    public double getMain_o_s_tpl() {
        return main_o_s_tpl;
    }

    public void setMain_o_s_tpl(double main_o_s_tpl) {
        this.main_o_s_tpl = main_o_s_tpl;
    }

    public double getSecond_o_s_tpl() {
        return second_o_s_tpl;
    }

    public void setSecond_o_s_tpl(double second_o_s_tpl) {
        this.second_o_s_tpl = second_o_s_tpl;
    }

    public String getSecond_name_mark() {
        return second_name_mark;
    }

    public void setSecond_name_mark(String second_name_mark) {
        this.second_name_mark = second_name_mark;
    }

    public int getDel_diff_left() {
        return del_diff_left;
    }

    public void setDel_diff_left(int del_diff_left) {
        this.del_diff_left = del_diff_left;
    }

    public int getDel_diff_right() {
        return del_diff_right;
    }

    public void setDel_diff_right(int del_diff_right) {
        this.del_diff_right = del_diff_right;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMain_name() {
        return main_name;
    }

    public void setMain_name(String main_name) {
        this.main_name = main_name;
    }

    public int getMain_role() {
        return main_role;
    }

    public void setMain_role(int main_role) {
        this.main_role = main_role;
    }

    public int getSecond_role() {
        return second_role;
    }

    public void setSecond_role(int second_role) {
        this.second_role = second_role;
    }

    public int getCreate_by_role() {
        return create_by_role;
    }

    public void setCreate_by_role(int create_by_role) {
        this.create_by_role = create_by_role;
    }

    public String getSecond_name() {
        return second_name;
    }

    public void setSecond_name(String second_name) {
        this.second_name = second_name;
    }

    public double getMain_s_tpl() {
        return main_s_tpl;
    }

    public void setMain_s_tpl(double main_s_tpl) {
        this.main_s_tpl = main_s_tpl;
    }

    public double getMain_w_h_tpl() {
        return main_w_h_tpl;
    }

    public void setMain_w_h_tpl(double main_w_h_tpl) {
        this.main_w_h_tpl = main_w_h_tpl;
    }

    public double getMain_o_h_tpl() {
        return main_o_h_tpl;
    }

    public void setMain_o_h_tpl(double main_o_h_tpl) {
        this.main_o_h_tpl = main_o_h_tpl;
    }

    public double getSecond_s_tpl() {
        return second_s_tpl;
    }

    public void setSecond_s_tpl(double second_s_tpl) {
        this.second_s_tpl = second_s_tpl;
    }

    public double getSecond_w_h_tpl() {
        return second_w_h_tpl;
    }

    public void setSecond_w_h_tpl(double second_w_h_tpl) {
        this.second_w_h_tpl = second_w_h_tpl;
    }

    public double getSecond_o_h_tpl() {
        return second_o_h_tpl;
    }

    public void setSecond_o_h_tpl(double second_o_h_tpl) {
        this.second_o_h_tpl = second_o_h_tpl;
    }

    public float getMain_manhour() {
        return main_manhour;
    }

    public void setMain_manhour(float main_manhour) {
        this.main_manhour = main_manhour;
    }

    public float getMain_manhour_hours() {
        return main_manhour_hours;
    }

    public void setMain_manhour_hours(float main_manhour_hours) {
        this.main_manhour_hours = main_manhour_hours;
    }

    public float getMain_overtime() {
        return main_overtime;
    }

    public void setMain_overtime(float main_overtime) {
        this.main_overtime = main_overtime;
    }

    public float getMain_overtime_hours() {
        return main_overtime_hours;
    }

    public void setMain_overtime_hours(float main_overtime_hours) {
        this.main_overtime_hours = main_overtime_hours;
    }

    public float getSecond_manhour() {
        return second_manhour;
    }

    public void setSecond_manhour(float second_manhour) {
        this.second_manhour = second_manhour;
    }

    public float getSecond_manhour_hours() {
        return second_manhour_hours;
    }

    public void setSecond_manhour_hours(float second_manhour_hours) {
        this.second_manhour_hours = second_manhour_hours;
    }

    public float getSecond_overtime() {
        return second_overtime;
    }

    public void setSecond_overtime(float second_overtime) {
        this.second_overtime = second_overtime;
    }

    public float getSecond_overtime_hours() {
        return second_overtime_hours;
    }

    public void setSecond_overtime_hours(float second_overtime_hours) {
        this.second_overtime_hours = second_overtime_hours;
    }

    public float getMain_set_unitprice() {
        return main_set_unitprice;
    }

    public void setMain_set_unitprice(float main_set_unitprice) {
        this.main_set_unitprice = main_set_unitprice;
    }

    public float getMain_set_quantities() {
        return main_set_quantities;
    }

    public void setMain_set_quantities(float main_set_quantities) {
        this.main_set_quantities = main_set_quantities;
    }

    public float getSecond_set_unitprice() {
        return second_set_unitprice;
    }

    public void setSecond_set_unitprice(float second_set_unitprice) {
        this.second_set_unitprice = second_set_unitprice;
    }

    public float getSecond_set_quantities() {
        return second_set_quantities;
    }

    public void setSecond_set_quantities(float second_set_quantities) {
        this.second_set_quantities = second_set_quantities;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getShow_lines() {
        return show_lines;
    }

    public void setShow_lines(int show_lines) {
        this.show_lines = show_lines;
    }

    public int getMain_del() {
        return main_del;
    }

    public void setMain_del(int main_del) {
        this.main_del = main_del;
    }

    public int getSecond_del() {
        return second_del;
    }

    public void setSecond_del(int second_del) {
        this.second_del = second_del;
    }

    public int getMain_line() {
        return main_line;
    }

    public void setMain_line(int main_line) {
        this.main_line = main_line;
    }

    public int getSecond_line() {
        return second_line;
    }

    public void setSecond_line(int second_line) {
        this.second_line = second_line;
    }

    public String getDescribe() {
        return describe;
    }

    public void setDescribe(String describe) {
        this.describe = describe;
    }

    public float getMain_balance_amount() {
        return main_balance_amount;
    }

    public void setMain_balance_amount(float main_balance_amount) {
        this.main_balance_amount = main_balance_amount;
    }

    public float getMain_subsidy_amount() {
        return main_subsidy_amount;
    }

    public void setMain_subsidy_amount(float main_subsidy_amount) {
        this.main_subsidy_amount = main_subsidy_amount;
    }

    public float getMain_reward_amount() {
        return main_reward_amount;
    }

    public void setMain_reward_amount(float main_reward_amount) {
        this.main_reward_amount = main_reward_amount;
    }

    public float getMain_penalty_amount() {
        return main_penalty_amount;
    }

    public void setMain_penalty_amount(float main_penalty_amount) {
        this.main_penalty_amount = main_penalty_amount;
    }

    public float getMain_deduct_amount() {
        return main_deduct_amount;
    }

    public void setMain_deduct_amount(float main_deduct_amount) {
        this.main_deduct_amount = main_deduct_amount;
    }

    public float getMain_pay_amount() {
        return main_pay_amount;
    }

    public void setMain_pay_amount(float main_pay_amount) {
        this.main_pay_amount = main_pay_amount;
    }

    public float getMain_set_amount() {
        return main_set_amount;
    }

    public void setMain_set_amount(float main_set_amount) {
        this.main_set_amount = main_set_amount;
    }

    public float getSecond_balance_amount() {
        return second_balance_amount;
    }

    public void setSecond_balance_amount(float second_balance_amount) {
        this.second_balance_amount = second_balance_amount;
    }

    public float getSecond_subsidy_amount() {
        return second_subsidy_amount;
    }

    public void setSecond_subsidy_amount(float second_subsidy_amount) {
        this.second_subsidy_amount = second_subsidy_amount;
    }

    public float getSecond_reward_amount() {
        return second_reward_amount;
    }

    public void setSecond_reward_amount(float second_reward_amount) {
        this.second_reward_amount = second_reward_amount;
    }

    public float getSecond_penalty_amount() {
        return second_penalty_amount;
    }

    public void setSecond_penalty_amount(float second_penalty_amount) {
        this.second_penalty_amount = second_penalty_amount;
    }

    public float getSecond_deduct_amount() {
        return second_deduct_amount;
    }

    public void setSecond_deduct_amount(float second_deduct_amount) {
        this.second_deduct_amount = second_deduct_amount;
    }

    public float getSecond_pay_amount() {
        return second_pay_amount;
    }

    public void setSecond_pay_amount(float second_pay_amount) {
        this.second_pay_amount = second_pay_amount;
    }

    public float getSecond_set_amount() {
        return second_set_amount;
    }

    public void setSecond_set_amount(float second_set_amount) {
        this.second_set_amount = second_set_amount;
    }

    public int getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(int accounts_type) {
        this.accounts_type = accounts_type;
    }

}