package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 功能:找项目、找工作
 * 时间:2016-7-27 11:33
 * 作者: xuj
 */
public class FindProjectBean implements Serializable {
    /**
     * 项目标题
     */
    private String pro_title;
    /**
     * 好友数量
     */
    private int sharefriendnum;
    /**
     * 项目id
     */
    private int pid;
    /**
     * 是否需要垫资
     */
    private int prepay;
    /**
     * 工种信息
     */
    private List<WorkInfomation> classes;
    /**
     * 地址坐标
     * 1.纬度
     * 2.经度
     */
    private double[] pro_location;
    /**
     * 项目创建描述
     * 如1天前发布
     */
    private String create_time_txt;

    public String getPro_title() {
        return pro_title;
    }

    public void setPro_title(String pro_title) {
        this.pro_title = pro_title;
    }

    public int getSharefriendnum() {
        return sharefriendnum;
    }

    public void setSharefriendnum(int sharefriendnum) {
        this.sharefriendnum = sharefriendnum;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public int getPrepay() {
        return prepay;
    }

    public void setPrepay(int prepay) {
        this.prepay = prepay;
    }


    public double[] getPro_location() {
        return pro_location;
    }

    public void setPro_location(double[] pro_location) {
        this.pro_location = pro_location;
    }

    public String getCreate_time_txt() {
        return create_time_txt;
    }

    public void setCreate_time_txt(String create_time_txt) {
        this.create_time_txt = create_time_txt;
    }

    public List<WorkInfomation> getClasses() {
        return classes;
    }

    public void setClasses(List<WorkInfomation> classes) {
        this.classes = classes;
    }
}
