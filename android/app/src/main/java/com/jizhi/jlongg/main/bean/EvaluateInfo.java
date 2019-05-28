package com.jizhi.jlongg.main.bean;


import java.util.ArrayList;

/**
 * 评价信息
 *
 * @author xuj
 * @version 1.0
 * @time 2018年4月24日10:09:25
 */
public class EvaluateInfo {
    /**
     * 想再次合作的概率,客户端换算成百分比
     */
    private float want_cooperation_rate;
    /**
     * 评价人数
     */
    private int evaluate_pnum;
    /**
     * 重新想雇佣他的人数
     */
    private int want_pnum;
    /**
     * 工作态度或没有拖欠工资星星数
     */
    private int attitude_or_arrears;
    /**
     * 专业技能或者辱骂工人星星数
     */
    private int professional_or_abuse;
    /**
     * 靠谱程度星星数
     */
    private int reliance_degree;
    /**
     * 记账信息
     */
    private EvaluateBillInfo bill_info;
    /**
     * 标签
     */
    private ArrayList<EvaluateTag> tag_list;
    /**
     * 合作过的项目数
     */
    private int cooperation_pro_num;
    /**
     * 总的工作时间（小时）
     */
    private float total_work_hours;
    /**
     * 评价数量
     */
    private int evaluate_num;
    /**
     * 不能评价时的提示信息
     */
    private String can_not_msg;
    /**
     * 备注信息
     */
    private String notes_txt;
    /**
     * 备注图片
     */
    private ArrayList<String> notes_img;

    public float getWant_cooperation_rate() {
        return want_cooperation_rate;
    }

    public void setWant_cooperation_rate(float want_cooperation_rate) {
        this.want_cooperation_rate = want_cooperation_rate;
    }

    public int getAttitude_or_arrears() {
        return attitude_or_arrears;
    }

    public void setAttitude_or_arrears(int attitude_or_arrears) {
        this.attitude_or_arrears = attitude_or_arrears;
    }

    public int getProfessional_or_abuse() {
        return professional_or_abuse;
    }

    public void setProfessional_or_abuse(int professional_or_abuse) {
        this.professional_or_abuse = professional_or_abuse;
    }

    public int getReliance_degree() {
        return reliance_degree;
    }

    public void setReliance_degree(int reliance_degree) {
        this.reliance_degree = reliance_degree;
    }


    public EvaluateBillInfo getBill_info() {
        return bill_info;
    }

    public void setBill_info(EvaluateBillInfo bill_info) {
        this.bill_info = bill_info;
    }

    public ArrayList<EvaluateTag> getTag_list() {
        return tag_list;
    }

    public void setTag_list(ArrayList<EvaluateTag> tag_list) {
        this.tag_list = tag_list;
    }

    public int getCooperation_pro_num() {
        return cooperation_pro_num;
    }

    public void setCooperation_pro_num(int cooperation_pro_num) {
        this.cooperation_pro_num = cooperation_pro_num;
    }

    public float getTotal_work_hours() {
        return total_work_hours;
    }

    public void setTotal_work_hours(float total_work_hours) {
        this.total_work_hours = total_work_hours;
    }

    public int getEvaluate_num() {
        return evaluate_num;
    }

    public void setEvaluate_num(int evaluate_num) {
        this.evaluate_num = evaluate_num;
    }

    public String getCan_not_msg() {
        return can_not_msg;
    }

    public void setCan_not_msg(String can_not_msg) {
        this.can_not_msg = can_not_msg;
    }

    public int getEvaluate_pnum() {
        return evaluate_pnum;
    }

    public void setEvaluate_pnum(int evaluate_pnum) {
        this.evaluate_pnum = evaluate_pnum;
    }

    public int getWant_pnum() {
        return want_pnum;
    }

    public void setWant_pnum(int want_pnum) {
        this.want_pnum = want_pnum;
    }

    public String getNotes_txt() {
        return notes_txt;
    }

    public void setNotes_txt(String notes_txt) {
        this.notes_txt = notes_txt;
    }

    public ArrayList<String> getNotes_img() {
        return notes_img;
    }

    public void setNotes_img(ArrayList<String> notes_img) {
        this.notes_img = notes_img;
    }
}
