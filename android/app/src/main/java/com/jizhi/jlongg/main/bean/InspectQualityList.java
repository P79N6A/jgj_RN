package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * Created by Administrator on 2017/7/14 0014.
 */

public class InspectQualityList {
    private String parent_id;//父id
    private String uid;//创建者
    private String group_id;//组id
    private String class_type;//组类型
    private String type;//类型
    private String text;//名称
    private String create_time;//创建时间
    private String is_sort;//排序
    private String is_active;//有效性
    private String insp_id;//检查项Id
    private int child_num;//子项目数
    private String real_name;//
    private String allnum;
    private List<InspectQualityList> allrow;
    private boolean isCheck;

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }

    public boolean isCheck() {
        return isCheck;
    }

    public void setCheck(boolean check) {
        isCheck = check;
    }

    public String getParent_id() {
        return parent_id;
    }

    public void setParent_id(String parent_id) {
        this.parent_id = parent_id;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public String getIs_sort() {
        return is_sort;
    }

    public void setIs_sort(String is_sort) {
        this.is_sort = is_sort;
    }

    public String getIs_active() {
        return is_active;
    }

    public void setIs_active(String is_active) {
        this.is_active = is_active;
    }

    public String getInsp_id() {
        return insp_id;
    }

    public void setInsp_id(String insp_id) {
        this.insp_id = insp_id;
    }

    public int getChild_num() {
        return child_num;
    }

    public void setChild_num(int child_num) {
        this.child_num = child_num;
    }

    public String getAllnum() {
        return allnum;
    }

    public void setAllnum(String allnum) {
        this.allnum = allnum;
    }

    public List<InspectQualityList> getAllrow() {
        return allrow;
    }

    public void setAllrow(List<InspectQualityList> allrow) {
        this.allrow = allrow;
    }
}
