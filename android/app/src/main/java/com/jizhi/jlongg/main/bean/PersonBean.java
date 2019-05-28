package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

public class PersonBean implements Serializable {
    /**
     * 是否是创建者
     */
    private boolean isCreator;
    /**
     * uid
     */
    private int uid;
    /**
     * 名字
     */
    private String name;
    /**
     * 电话号码
     */
    private String telph;
    /**
     * 是否显示和他对账的按钮
     */
    private int is_check_accounts;
    /**
     * 是否有电话号码
     */
    private int is_not_telph;
    /**
     * 电话号码
     */
    private String telephone;
    /**
     * 显示数据拼音的首字母
     */
    private String sortLetters;
    /**
     * 字母全拼
     * 比如name是徐杰 则是 xj
     */
    private String pinYin;
    /**
     * 点工薪资模板
     */
    private Salary tpl;
    /**
     * 包工记工天薪资模板
     */
    private Salary unit_quan_tpl;
    /**
     * 是否选中了
     */
    private boolean isChecked;
    /**
     * 好友头像
     */
    private String head_pic;
    /**
     * 项目名称
     */
    private String proname;



    private String real_name;

    private int is_active;

    private String target_uid;
    /**
     * 1表示可以评价
     */
    private int is_comment;

    private Double balance_amount;//未结工资
    private int un_salary_tpl;//未结数量

    public int getIs_active() {
        return is_active;
    }

    public void setIs_active(int is_active) {
        this.is_active = is_active;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getUid() {
        return uid;
    }

    public boolean isChecked() {
        return isChecked;
    }

    public void setIsChecked(boolean isChecked) {
        this.isChecked = isChecked;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }


    public String getSortLetters() {
        return sortLetters;
    }

    public void setSortLetters(String sortLetters) {
        this.sortLetters = sortLetters;
    }

    public String getTelph() {
        return telph;
    }

    public void setTelph(String telph) {
        this.telph = telph;
    }

    public Salary getTpl() {
        return tpl;
    }

    public void setTpl(Salary tpl) {
        this.tpl = tpl;
    }

    public PersonBean(String name, String telph) {
        this.name = name;
        this.telph = telph;
    }

    public PersonBean() {
    }

    public String getHead_pic() {
        return head_pic;
    }

    public void setHead_pic(String head_pic) {
        this.head_pic = head_pic;
    }

    public boolean isCreator() {
        return isCreator;
    }

    public void setCreator(boolean creator) {
        isCreator = creator;
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


    public String getProname() {
        return proname;
    }

    public void setProname(String proname) {
        this.proname = proname;
    }

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }


    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getTarget_uid() {
        return target_uid;
    }

    public void setTarget_uid(String target_uid) {
        this.target_uid = target_uid;
    }

    public Salary getUnit_quan_tpl() {
        return unit_quan_tpl;
    }

    public void setUnit_quan_tpl(Salary unit_quan_tpl) {
        this.unit_quan_tpl = unit_quan_tpl;
    }

    public int getIs_check_accounts() {
        return is_check_accounts;
    }

    public void setIs_check_accounts(int is_check_accounts) {
        this.is_check_accounts = is_check_accounts;
    }

    public int getIs_not_telph() {
        return is_not_telph;
    }

    public void setIs_not_telph(int is_not_telph) {
        this.is_not_telph = is_not_telph;
    }

    public int getIs_comment() {
        return is_comment;
    }

    public void setIs_comment(int is_comment) {
        this.is_comment = is_comment;
    }

    public String getPinYin() {
        return pinYin;
    }

    public void setPinYin(String pinYin) {
        this.pinYin = pinYin;
    }
}
