package com.jizhi.jlongg.main.bean;

import java.util.ArrayList;

/**
 * 功能:检查项
 * 时间:2017年11月16日15:43:05
 * 作者:Xuj
 */
public class CheckList extends BaseCheckInfo {
    /**
     * 检查项名称
     */
    private String pro_name;
    /**
     * 位置
     */
    private String location_text;
    /**
     * 检查项id
     */
    private int pro_id;
    /**
     * 检查内容
     */
    private ArrayList<CheckContent> content_list;

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public String getLocation_text() {
        return location_text;
    }

    public void setLocation_text(String location_text) {
        this.location_text = location_text;
    }

    public ArrayList<CheckContent> getContent_list() {
        return content_list;
    }

    public void setContent_list(ArrayList<CheckContent> content_list) {
        this.content_list = content_list;
    }

    public int getPro_id() {
        return pro_id;
    }

    public void setPro_id(int pro_id) {
        this.pro_id = pro_id;
    }
}
