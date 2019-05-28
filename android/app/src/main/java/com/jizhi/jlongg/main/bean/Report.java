package com.jizhi.jlongg.main.bean;

import java.util.List;

public class Report {
    /**
     * 举报码
     */
    private String code;
    /**
     * 举报标题
     */
    private String name;
    /**
     * 举报描述
     */
    private String desc;
    /**
     * 是否选中
     */
    private boolean isSeleted;

    private List<Report> sub_list;

    public List<Report> getSub_list() {
        return sub_list;
    }

    public void setSub_list(List<Report> sub_list) {
        this.sub_list = sub_list;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }


    public Report(String name, String desc) {
        this.desc = desc;
        this.name = name;
    }

    public Report(String name) {
        this.name = name;
    }

    public boolean isSeleted() {
        return isSeleted;
    }

    public void setIsSeleted(boolean isSeleted) {
        this.isSeleted = isSeleted;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }
}
