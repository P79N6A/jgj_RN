package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 功能:记工详情
 * 时间:2017-9-27 10:23
 * 作者:hcs
 */

public class WorkDetail extends WorkBaseInfo implements Serializable {
    private Double unbalance_amount;//未结算金额
    private Double subsidy_amount;//补贴金额1
    private Double reward_amount;//奖金金额1
    private Double penalty_amount;//罚款金额1
    private Double deduct_amount;//抹零金额
    private Double pay_amount;//本次实收金额1
    private Double balance_amount;//未结工资
    private int un_salary_tpl;//未结数量
    private String record_id;//未结数量


    private String id;//记账id
    private String foreman_name;//工头名称
    private String worker_name;//工人名称
    private String accounts_type;//记工类别
    private String date;//记账日期
    private String proname;//项目名称
    private String uid;//被记账人uid
    private String notes_txt;//文字备注
    private String units;//单位
    private String sub_proname;
    private String unitprice;//单价
    private String quantities;//工程量
    private List<String> notes_img;//图片备注
    private Salary set_tpl; //模板信息
    private float set_my_amounts_tpl; //自己设置的工资金额
    private int is_del;//是否删除了记账
    private int amounts_diff; //1表示有1差帐
    private int pid;//项目id
    private int is_rest; //1表示休息
    private String p_s_time;//开工时间
    private String p_e_time;//完工时间
    private String company;
    private int contractor_type;//1.承包 2。分包
    private String wuid;
    private String fuid;
    private AgencyGroupUser recorder_info;


    public WorkDetail(String foreman_name, String worker_name, String accounts_type, String amounts, String proname, int is_del) {
        this.foreman_name = foreman_name;
        this.worker_name = worker_name;
        this.accounts_type = accounts_type;
        this.amounts = amounts;
        this.proname = proname;
        this.is_del = is_del;
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

    public WorkDetail() {
    }

    public String getRecord_id() {
        return record_id;
    }

    public void setRecord_id(String record_id) {
        this.record_id = record_id;
    }

    public Double getUnbalance_amount() {
        return unbalance_amount;
    }

    public void setUnbalance_amount(Double unbalance_amount) {
        this.unbalance_amount = unbalance_amount;
    }

    public Double getSubsidy_amount() {
        return subsidy_amount;
    }

    public void setSubsidy_amount(Double subsidy_amount) {
        this.subsidy_amount = subsidy_amount;
    }

    public Double getReward_amount() {
        return reward_amount;
    }

    public void setReward_amount(Double reward_amount) {
        this.reward_amount = reward_amount;
    }

    public Double getPenalty_amount() {
        return penalty_amount;
    }

    public void setPenalty_amount(Double penalty_amount) {
        this.penalty_amount = penalty_amount;
    }

    public Double getDeduct_amount() {
        return deduct_amount;
    }

    public void setDeduct_amount(Double deduct_amount) {
        this.deduct_amount = deduct_amount;
    }

    public Double getPay_amount() {
        return pay_amount;
    }

    public void setPay_amount(Double pay_amount) {
        this.pay_amount = pay_amount;
    }

    public Double getBalance_amount() {
        return balance_amount;
    }

    public void setBalance_amount(Double balance_amount) {
        this.balance_amount = balance_amount;
    }

    public int getUn_salary_tpl() {
        return un_salary_tpl;
    }

    public void setUn_salary_tpl(int un_salary_tpl) {
        this.un_salary_tpl = un_salary_tpl;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getForeman_name() {
        return foreman_name;
    }

    public void setForeman_name(String foreman_name) {
        this.foreman_name = foreman_name;
    }

    public String getWorker_name() {
        return worker_name;
    }

    public void setWorker_name(String worker_name) {
        this.worker_name = worker_name;
    }

    public String getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(String accounts_type) {
        this.accounts_type = accounts_type;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getProname() {
        return proname;
    }

    public void setProname(String proname) {
        this.proname = proname;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getNotes_txt() {
        return notes_txt;
    }

    public void setNotes_txt(String notes_txt) {
        this.notes_txt = notes_txt;
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

    public List<String> getNotes_img() {
        return notes_img;
    }

    public void setNotes_img(List<String> notes_img) {
        this.notes_img = notes_img;
    }

    public Salary getSet_tpl() {
        return set_tpl;
    }

    public void setSet_tpl(Salary set_tpl) {
        this.set_tpl = set_tpl;
    }

    public int getIs_del() {
        return is_del;
    }

    public void setIs_del(int is_del) {
        this.is_del = is_del;
    }

    public int getAmounts_diff() {
        return amounts_diff;
    }

    public void setAmounts_diff(int amounts_diff) {
        this.amounts_diff = amounts_diff;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public int getIs_rest() {
        return is_rest;
    }

    public void setIs_rest(int is_rest) {
        this.is_rest = is_rest;
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


    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public AgencyGroupUser getRecorder_info() {
        return recorder_info;
    }

    public void setRecorder_info(AgencyGroupUser recorder_info) {
        this.recorder_info = recorder_info;
    }

    public int getContractor_type() {
        return contractor_type;
    }

    public void setContractor_type(int contractor_type) {
        this.contractor_type = contractor_type;
    }

    public float getSet_my_amounts_tpl() {
        return set_my_amounts_tpl;
    }

    public void setSet_my_amounts_tpl(float set_my_amounts_tpl) {
        this.set_my_amounts_tpl = set_my_amounts_tpl;
    }
}
