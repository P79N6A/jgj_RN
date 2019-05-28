package com.jizhi.jlongg.main.bean;

public class IsSupplement {

    /**
     * 是否补充姓名
     */
    private int realname;
    /**
     * 是否补充年龄
     */
    private int age;
    /**
     * 是否补充性别
     */
    private int gender;
    /**
     * 是否补充家乡
     */
    private int hometown;
    /**
     * 是否补充当前城市
     */
    private int currentaddr;
    /**
     * 是否补充工龄
     */
    private int workyear;
    /**
     * 是否补充期望工作地
     */
    private int expectaddr;
    /**
     * 是否补充工人规模
     */
    private int person_count;
    /**
     * 是否补充工头工种信息
     */
    private int f_worktype;
    /**
     * 是否补充工友工种信息
     */
    private int w_worktype;


    private int head_pic;


    public int getRealname() {
        return realname;
    }

    public void setRealname(int realname) {
        this.realname = realname;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public int getGender() {
        return gender;
    }

    public void setGender(int gender) {
        this.gender = gender;
    }

    public int getHometown() {
        return hometown;
    }

    public void setHometown(int hometown) {
        this.hometown = hometown;
    }

    public int getCurrentaddr() {
        return currentaddr;
    }

    public void setCurrentaddr(int currentaddr) {
        this.currentaddr = currentaddr;
    }

    public int getWorkyear() {
        return workyear;
    }

    public void setWorkyear(int workyear) {
        this.workyear = workyear;
    }

    public int getExpectaddr() {
        return expectaddr;
    }

    public void setExpectaddr(int expectaddr) {
        this.expectaddr = expectaddr;
    }

    public int getPerson_count() {
        return person_count;
    }

    public void setPerson_count(int person_count) {
        this.person_count = person_count;
    }

    public int getF_worktype() {
        return f_worktype;
    }

    public void setF_worktype(int f_worktype) {
        this.f_worktype = f_worktype;
    }

    public int getW_worktype() {
        return w_worktype;
    }

    public void setW_worktype(int w_worktype) {
        this.w_worktype = w_worktype;
    }

    /***
     * 家乡资料补充过
     */
    private int hometown_info;
    /***
     * 工作期望地补充过
     */
    private int expectaddr_info;


    public int getHometown_info() {
        return hometown_info;
    }

    public void setHometown_info(int hometown_info) {
        this.hometown_info = hometown_info;
    }

    public int getExpectaddr_info() {
        return expectaddr_info;
    }

    public void setExpectaddr_info(int expectaddr_info) {
        this.expectaddr_info = expectaddr_info;
    }



    public int getHead_pic() {
        return head_pic;
    }

    public void setHead_pic(int head_pic) {
        this.head_pic = head_pic;
    }
}
