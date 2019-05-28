package com.jizhi.jlongg.main.bean;

/**
 * 记工流水2.3.7
 */

public class AccountWorkRember {
    private String date; //日期
    private String date_turn;//农历
    private int id;//记账id
    private int accounts_type;//工种 1：点工；2：包工；3：借支；4：结算 5:包工记账
    private String units;
    private String sub_proname;
    private String working_hours;//点工  工单位
    private String manhour;//点工  小时单位
    private String uid;////对方uid
    private String overtime_hours;//加班 工单位
    private String overtime;//加班  小时单位
    private String amounts;//金额
    private String pid;//项目id
    private String proname;//项目名称
    private String unitprice;//点工  小时单位
    private String quantities;//点工  小时单位
    private int is_diff;//差账
    private int amounts_diff;//差账
    private String balance_amount;//未结算金额
    private String subsidy_amount;//补贴金额
    private String reward_amount;//奖金金额
    private String penalty_amount;//惩罚金额
    private String deduct_amount;//抹零金额
    private String pay_amount;//结算的支付金额
    private String p_s_time;//
    private String p_e_time;//
    private String worker_name;//工人名称
    private String foreman_name;//工头名称
    private String record_id;//记账id
    private String wuid;//
    private String fuid;//
    private String agency_uid;//
    private String update_time;//
    private String create_by_role;//创建者角色
    private String be_booked_user_name;//
    private Salary set_tpl;
    //是否勾选了删除按钮
    private boolean isSelected;
    private boolean isExist;
    //是否显示删除框
    private boolean isShowCb;
    private boolean isShowAnim;
    //项目id
    private String group_id;
    //项目
    private int record_type;
    //item显示类型  1增加 2.点工，包工记工天 3.借支结算包工记账
    private int type;
    private UserInfo user_info;
    //创建时间
    private String create_time;
    //
    private String nl_date;// 操作农历日期
    //是否有备注
    private int is_notes;
    //我的薪资模版
    private Salary my_tpl;
    //对方的薪资模版
    private Salary oth_tpl;
    private String telph;
    //1承包 2分包
    private int contractor_type;

    public String getTelph() {
        return telph;
    }

    public void setTelph(String telph) {
        this.telph = telph;
    }

    public int getIs_notes() {
        return is_notes;
    }

    public void setIs_notes(int is_notes) {
        this.is_notes = is_notes;
    }

    public String getNl_date() {
        return nl_date;
    }

    public void setNl_date(String nl_date) {
        this.nl_date = nl_date;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public void setCreate_by_role(String create_by_role) {
        this.create_by_role = create_by_role;
    }

    public Salary getSet_tpl() {
        return set_tpl;
    }

    public void setSet_tpl(Salary set_tpl) {
        this.set_tpl = set_tpl;
    }

    public String getRecord_id() {
        return record_id;
    }

    public void setRecord_id(String record_id) {
        this.record_id = record_id;
    }

    public String getWuid() {
        return wuid;
    }

    public void setWuid(String wuid) {
        this.wuid = wuid;
    }

    public String getFuid() {
        return fuid;
    }

    public void setFuid(String fuid) {
        this.fuid = fuid;
    }

    public String getAgency_uid() {
        return agency_uid;
    }

    public void setAgency_uid(String agency_uid) {
        this.agency_uid = agency_uid;
    }

    public String getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(String update_time) {
        this.update_time = update_time;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getDate_turn() {
        return date_turn;
    }

    public void setDate_turn(String date_turn) {
        this.date_turn = date_turn;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(int accounts_type) {
        this.accounts_type = accounts_type;
    }

    public String getUnits() {
        return units;
    }

    public void setUnits(String units) {
        this.units = units;
    }

    public String getSub_proname() {
        return sub_proname;
    }

    public void setSub_proname(String sub_proname) {
        this.sub_proname = sub_proname;
    }

    public String getWorking_hours() {
        return working_hours;
    }

    public void setWorking_hours(String working_hours) {
        this.working_hours = working_hours;
    }

    public String getManhour() {
        return manhour;
    }

    public void setManhour(String manhour) {
        this.manhour = manhour;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getOvertime_hours() {
        return overtime_hours;
    }

    public void setOvertime_hours(String overtime_hours) {
        this.overtime_hours = overtime_hours;
    }

    public String getOvertime() {
        return overtime;
    }

    public void setOvertime(String overtime) {
        this.overtime = overtime;
    }

    public String getAmounts() {
        return amounts;
    }

    public void setAmounts(String amounts) {
        this.amounts = amounts;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getProname() {
        return proname;
    }

    public void setProname(String proname) {
        this.proname = proname;
    }

    public String getUnitprice() {
        return unitprice;
    }

    public void setUnitprice(String unitprice) {
        this.unitprice = unitprice;
    }

    public String getQuantities() {
        return quantities;
    }

    public void setQuantities(String quantities) {
        this.quantities = quantities;
    }

    public int getIs_diff() {
        return is_diff;
    }

    public void setIs_diff(int is_diff) {
        this.is_diff = is_diff;
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

    public String getPay_amount() {
        return pay_amount;
    }

    public void setPay_amount(String pay_amount) {
        this.pay_amount = pay_amount;
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

    public String getWorker_name() {
        return worker_name;
    }

    public void setWorker_name(String worker_name) {
        this.worker_name = worker_name;
    }

    public String getForeman_name() {
        return foreman_name;
    }

    public void setForeman_name(String foreman_name) {
        this.foreman_name = foreman_name;
    }

    public String getBe_booked_user_name() {
        return be_booked_user_name;
    }

    public void setBe_booked_user_name(String be_booked_user_name) {
        this.be_booked_user_name = be_booked_user_name;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public boolean isExist() {
        return isExist;
    }

    public void setExist(boolean exist) {
        isExist = exist;
    }

    public boolean isShowCb() {
        return isShowCb;
    }

    public void setShowCb(boolean showCb) {
        isShowCb = showCb;
    }

    public boolean isShowAnim() {
        return isShowAnim;
    }

    public void setShowAnim(boolean showAnim) {
        isShowAnim = showAnim;
    }

    public int getAmounts_diff() {
        return amounts_diff;
    }

    public void setAmounts_diff(int amounts_diff) {
        this.amounts_diff = amounts_diff;
    }

    public String getCreate_by_role() {
        return create_by_role;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public int getRecord_type() {
        return record_type;
    }

    public void setRecord_type(int record_type) {
        this.record_type = record_type;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public Salary getMy_tpl() {
        return my_tpl;
    }

    public void setMy_tpl(Salary my_tpl) {
        this.my_tpl = my_tpl;
    }

    public Salary getOth_tpl() {
        return oth_tpl;
    }

    public void setOth_tpl(Salary oth_tpl) {
        this.oth_tpl = oth_tpl;
    }

    public int getContractor_type() {
        return contractor_type;
    }

    public void setContractor_type(int contractor_type) {
        this.contractor_type = contractor_type;
    }
}
