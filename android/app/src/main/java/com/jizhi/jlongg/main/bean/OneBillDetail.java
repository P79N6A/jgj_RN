package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 编辑发布记账页面
 * Created by Administrator on 2016/2/26.
 */
public class OneBillDetail implements Serializable {
    //-------------------------共同拥有的-----------------------------------------//
    //记账人的角色（1：工人；0：工头）
    private int role;
    //记账对象名称
    private String name;
    //记账对象id
    private int uid;
    //项目名称
    private String proname;
    //项目id
    private int pid;
    //金额
    private double salary;
    //文字备份
    private String notes_txt;
    //图片备份
    private String[] notes_img;
    //语音备份
    private String notes_voice;
    //时间
    private String date;
    //语音长度
    private int voice_length;
    //--------------------------点工特别拥有的-------------------------------------------//
    //上班时间
    private float manhour;
    //加班时间
    private float overtime;
    //设置模板
    private Salary set_tpl;

    //--------------------------包工特别拥有的-------------------------------------------//
    //开始时间
    private String start_time;
    //结束时间
    private String end_time;
    //分项项目名称
    private String sub_proname;
    //单价
    private double unitprice;
    //数量
    private double quantities;
    //--------------------------借支特别拥有的-------------------------------------------//
    //1代表已经删除了该笔账
    private String del_diff_tag;
    //包工单位
    private String units;
    /**
     * 是否有差账 0、没有差帐  2、等待自己确认  3、等待对方修改
     */
    private int modify_marking;

    public int getModify_marking() {
        return modify_marking;
    }

    public void setModify_marking(int modify_marking) {
        this.modify_marking = modify_marking;
    }

    public String getUnits() {
        return units;
    }

    public void setUnits(String units) {
        this.units = units;
    }

    public String getDel_diff_tag() {
        return del_diff_tag;
    }

    public void setDel_diff_tag(String del_diff_tag) {
        this.del_diff_tag = del_diff_tag;
    }

    public int getVoice_length() {
        return voice_length;
    }

    public void setVoice_length(int voice_length) {
        this.voice_length = voice_length;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
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

    public void setUid(int uid) {
        this.uid = uid;
    }

    public String getProname() {
        return proname;
    }

    public void setProname(String proname) {
        this.proname = proname;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    public String getNotes_txt() {
        return notes_txt;
    }

    public void setNotes_txt(String notes_txt) {
        this.notes_txt = notes_txt;
    }

    public String[] getNotes_img() {
        return notes_img;
    }

    public void setNotes_img(String[] notes_img) {
        this.notes_img = notes_img;
    }

    public String getNotes_voice() {
        return notes_voice;
    }

    public void setNotes_voice(String notes_voice) {
        this.notes_voice = notes_voice;
    }

    public float getManhour() {
        return manhour;
    }

    public void setManhour(float manhour) {
        this.manhour = manhour;
    }

    public float getOvertime() {
        return overtime;
    }

    public void setOvertime(float overtime) {
        this.overtime = overtime;
    }

    public void setManhour(int manhour) {
        this.manhour = manhour;
    }


    public void setOvertime(int overtime) {
        this.overtime = overtime;
    }

    public String getStart_time() {
        return start_time;
    }

    public void setStart_time(String start_time) {
        this.start_time = start_time;
    }

    public String getEnd_time() {
        return end_time;
    }

    public void setEnd_time(String end_time) {
        this.end_time = end_time;
    }

    public double getUnitprice() {
        return unitprice;
    }

    public void setUnitprice(double unitprice) {
        this.unitprice = unitprice;
    }

    public double getQuantities() {
        return quantities;
    }

    public void setQuantities(double quantities) {
        this.quantities = quantities;
    }

    public Salary getSet_tpl() {
        return set_tpl;
    }

    public void setSet_tpl(Salary set_tpl) {
        this.set_tpl = set_tpl;
    }

    public String getSub_proname() {
        return sub_proname;
    }

    public void setSub_proname(String sub_proname) {
        this.sub_proname = sub_proname;
    }
}
