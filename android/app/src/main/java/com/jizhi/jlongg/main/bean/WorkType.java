package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 功能:工种类型
 * 时间:2016-4-14 11:11
 * 作者: xuj
 */
public class WorkType implements Serializable {
    /**
     * 编号
     */
    private int type_id;
    /**
     * 工种名称
     */
    private String type_name;
    /**
     * 工种描述
     */
    private String txt;

    private int code;

    private boolean isSelected;
    private int worklevel = 32;// 熟练度
    private String worktype;// 工作类型
    private String workName;
    private String balanceway = "天";// 平方立方米 吨
    private String money = "";
    // 计价方式 1点工 2包工
    private int cooperate_range = 1;
    private String person_count;
    private String pwdid;
    private List<Person> others;

    public WorkType(String workName) {
        this.workName = workName;
    }

    public WorkType() {
    }

    public WorkType(String id, String name, boolean isSelected) {
        this.worktype = id;
        this.workName = name;
        this.isSelected = isSelected;
    }

    public WorkType(String name, boolean isSelected) {
        this.type_name = name;
        this.isSelected = isSelected;
    }

    public WorkType(String worktypeId, String workName) {
        this.worktype = worktypeId;
        this.workName = workName;
    }

    public WorkType(boolean isSelected, String name) {
        this.workName = name;
        this.isSelected = isSelected;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }


    public boolean isSelected() {
        return isSelected;
    }

    public void setIsSelected(boolean isSelected) {
        this.isSelected = isSelected;
    }

    public int getWorklevel() {
        return worklevel;
    }

    public void setWorklevel(int worklevel) {
        this.worklevel = worklevel;
    }

    public String getWorktype() {
        return worktype;
    }

    public void setWorktype(String worktype) {
        this.worktype = worktype;
    }

    public String getWorkName() {
        return workName;
    }

    public void setWorkName(String workName) {
        this.workName = workName;
    }

    public String getBalanceway() {
        return balanceway;
    }

    public void setBalanceway(String balanceway) {
        this.balanceway = balanceway;
    }

    public String getMoney() {
        return money;
    }

    public void setMoney(String money) {
        this.money = money;
    }

    public int getCooperate_range() {
        return cooperate_range;
    }

    public void setCooperate_range(int cooperate_range) {
        this.cooperate_range = cooperate_range;
    }

    public String getPerson_count() {
        return person_count;
    }

    public void setPerson_count(String person_count) {
        this.person_count = person_count;
    }

    public String getPwdid() {
        return pwdid;
    }

    public void setPwdid(String pwdid) {
        this.pwdid = pwdid;
    }

    public List<Person> getOthers() {
        return others;
    }

    public void setOthers(List<Person> others) {
        this.others = others;
    }

    public int getType_id() {
        return type_id;
    }

    public void setType_id(int type_id) {
        this.type_id = type_id;
    }

    public String getType_name() {
        return type_name;
    }

    public void setType_name(String type_name) {
        this.type_name = type_name;
    }

    public String getTxt() {
        return txt;
    }

    public void setTxt(String txt) {
        this.txt = txt;
    }
}
