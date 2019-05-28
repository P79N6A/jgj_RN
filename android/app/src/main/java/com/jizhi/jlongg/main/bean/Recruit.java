package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * CName:招工信息
 * User: xuj
 * Date: 2018年6月19日
 * Time: 10:48:17
 */
public class Recruit {

    private List<Recruit> data_list;
    /**
     * 项目描述
     */
    private String pro_description;
    /**
     * 福利
     */
    private List<String> welfare;
    /**
     * 项目标题
     */
    private String pro_title;
    /**
     * 发布时间描述
     */
    private String create_time_txt;
    /**
     *
     */
    private List<RecruitDetail> classes;
    /**
     * 项目经纬度
     */
    private double[] pro_location;


    public String getPro_description() {
        return pro_description;
    }

    public void setPro_description(String pro_description) {
        this.pro_description = pro_description;
    }


    public String getPro_title() {
        return pro_title;
    }

    public void setPro_title(String pro_title) {
        this.pro_title = pro_title;
    }

    public String getCreate_time_txt() {
        return create_time_txt;
    }

    public void setCreate_time_txt(String create_time_txt) {
        this.create_time_txt = create_time_txt;
    }


    public List<Recruit> getData_list() {
        return data_list;
    }

    public void setData_list(List<Recruit> data_list) {
        this.data_list = data_list;
    }

    public List<RecruitDetail> getClasses() {
        return classes;
    }

    public void setClasses(List<RecruitDetail> classes) {
        this.classes = classes;
    }

    public double[] getPro_location() {
        return pro_location;
    }

    public void setPro_location(double[] pro_location) {
        this.pro_location = pro_location;
    }

    public List<String> getWelfare() {
        return welfare;
    }

    public void setWelfare(List<String> welfare) {
        this.welfare = welfare;
    }
}
