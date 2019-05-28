package com.jizhi.jlongg.main.bean;

import com.google.gson.annotations.Expose;

import org.litepal.annotation.Column;

import java.io.Serializable;

/**
 * 功能:班组成员 信息
 * 作者：Xuj
 * 时间: 2016-8-29 17:23
 */
public class GroupMemberInfo extends UserInfo implements Serializable {


    /* 是否是激活平台用户 */
    private int is_active;
    /* 	是否是创建者  创建者为1  非创建者为0 */
    private int is_creater;
    /*  是否是管理员  管理者为1  非管理者为0 */
    private int is_admin;
    /*  是否是代班长  代班长为1  非代班长为0 */
    private int is_agency;
    /*  是否是记录员  记录员为1  非记录员为0 */
    private int is_report;
    /* 是否是数据来源人 */
    private int is_source_member;
    /* 数据来源人是否同步 */
    private int synced;
    /* 数据源id */
    @Column(ignore = true)
    private String sourceId;
    /* 是否要求同步项目 0:不要求同步项目 */
    @Expose
    private int is_demand;
    /* 是否来自通知 */
    private boolean isFromSource;
    /* 是否选中了 */
    private boolean isSelected;
    /* 当前是否可点 */
    private boolean isClickable = true;
    /* 是否已显示Anim */
    private boolean isShowAnim = true;
    /* 班组成员数量 */
    /* 组名称 */
    private String group_name;
    /* 是否有真实姓名 */
    private int is_real_name;
    /* 0表示对方的对账功能未关闭；1:已关闭 */
    private int confirm_off;
    /* 已注册未开启 */
    private String confirm_off_desc;
    /* 1:表示不存在电话 */
    private int is_not_telph;
    /*4.0.2好友来源*/
    private String add_from;

    public String getAdd_from() {
        return add_from;
    }

    public void setAdd_from(String add_from) {
        this.add_from = add_from;
    }

    public int getIs_active() {
        return is_active;
    }

    public void setIs_active(int is_active) {
        this.is_active = is_active;
    }

    public int getIs_creater() {
        return is_creater;
    }

    public void setIs_creater(int is_creater) {
        this.is_creater = is_creater;
    }


    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public boolean isClickable() {
        return isClickable;
    }

    public void setClickable(boolean clickable) {
        isClickable = clickable;
    }

    public GroupMemberInfo() {

    }

    public GroupMemberInfo(String real_name) {
        setReal_name(real_name);
    }

    public GroupMemberInfo(String realName, String telphone) {
        setReal_name(realName);
        setTelephone(telphone);
    }

    public GroupMemberInfo(String realName, String telphone, String head_pic) {
        setReal_name(realName);
        setTelephone(telphone);
        setHead_pic(head_pic);
    }

    public GroupMemberInfo(String realName, String telphone, boolean isSelected) {
        setReal_name(realName);
        setTelephone(telphone);
        setSelected(isSelected);
    }


    public int getSynced() {
        return synced;
    }

    public void setSynced(int synced) {
        this.synced = synced;
    }

    public String getSourceId() {
        return sourceId;
    }

    public void setSourceId(String sourceId) {
        this.sourceId = sourceId;
    }

    public int getIs_demand() {
        return is_demand;
    }

    public void setIs_demand(int is_demand) {
        this.is_demand = is_demand;
    }


    public boolean isFromSource() {
        return isFromSource;
    }

    public void setFromSource(boolean fromSource) {
        isFromSource = fromSource;
    }

    public int getIs_admin() {
        return is_admin;
    }

    public void setIs_admin(int is_admin) {
        this.is_admin = is_admin;
    }

    public int getIs_source_member() {
        return is_source_member;
    }

    public void setIs_source_member(int is_source_member) {
        this.is_source_member = is_source_member;
    }

    public boolean isShowAnim() {
        return isShowAnim;
    }

    public void setShowAnim(boolean showAnim) {
        isShowAnim = showAnim;
    }


    public String getGroup_name() {
        return group_name;
    }

    public void setGroup_name(String group_name) {
        this.group_name = group_name;
    }

    public int getIs_real_name() {
        return is_real_name;
    }

    public void setIs_real_name(int is_real_name) {
        this.is_real_name = is_real_name;
    }

    public int getIs_report() {
        return is_report;
    }

    public void setIs_report(int is_report) {
        this.is_report = is_report;
    }

//    public String getFull_name() {
//        return full_name;
//    }
//
//    public void setFull_name(String full_name) {
//        this.full_name = full_name;
//    }

    public int getIs_agency() {
        return is_agency;
    }

    public void setIs_agency(int is_agency) {
        this.is_agency = is_agency;
    }

    public int getConfirm_off() {
        return confirm_off;
    }

    public void setConfirm_off(int confirm_off) {
        this.confirm_off = confirm_off;
    }

    public String getConfirm_off_desc() {
        return confirm_off_desc;
    }

    public void setConfirm_off_desc(String confirm_off_desc) {
        this.confirm_off_desc = confirm_off_desc;
    }

    public int getIs_not_telph() {
        return is_not_telph;
    }

    public void setIs_not_telph(int is_not_telph) {
        this.is_not_telph = is_not_telph;
    }
}
