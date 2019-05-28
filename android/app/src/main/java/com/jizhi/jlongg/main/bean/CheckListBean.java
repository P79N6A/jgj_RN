package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * CName:检查列表2.3.4
 * User: hcs
 * Date: 2017-11-24
 * Time: 11:22
 */

public class CheckListBean implements Serializable {
    private int id; //计划id
    private String plan_name;//计划名称
    private String group_id;//组id
    private String class_type;//组类型
    private String execute_time; //执行时间
    private String create_time;//创建时间
    private String uid;//创建者uid
    private String oper_type;//用户创建
    private String is_active;
    private String plan_id;
    private String pro_num;//检查项数
    private String execute_name;//执行人
    private String pass_percent; //完成率
    private String execute_percent;// 执行率
    private int is_operate;////可以操作权限
    private String pro_id; //检查项id
    private String pro_name;//检查项名
    private String real_name;//检查人名字
    private String update_time;//操作时间
    private String telephone;//手机号
    private String location_text;//地址
    private int status;//状态  //0：未检查 1：待整改 2：不用检查 3：完成
    private List<CheckListBean> pro_list;//检查项内容
    private String oper_uid;
    private List<CheckPlanListBean> content_list;
    private UserInfo user_info;
    private List<GroupMemberInfo> member_list;//执行人

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public List<CheckPlanListBean> getContent_list() {
        return content_list;
    }

    public void setContent_list(List<CheckPlanListBean> content_list) {
        this.content_list = content_list;
    }

    public int getIs_operate() {
        return is_operate;
    }

    public void setIs_operate(int is_operate) {
        this.is_operate = is_operate;
    }

    public String getLocation_text() {
        return location_text;
    }

    public void setLocation_text(String location_text) {
        this.location_text = location_text;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPlan_name() {
        return plan_name;
    }

    public void setPlan_name(String plan_name) {
        this.plan_name = plan_name;
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

    public String getExecute_time() {
        return execute_time;
    }

    public void setExecute_time(String execute_time) {
        this.execute_time = execute_time;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getOper_type() {
        return oper_type;
    }

    public void setOper_type(String oper_type) {
        this.oper_type = oper_type;
    }

    public String getIs_active() {
        return is_active;
    }

    public void setIs_active(String is_active) {
        this.is_active = is_active;
    }

    public String getPlan_id() {
        return plan_id;
    }

    public void setPlan_id(String plan_id) {
        this.plan_id = plan_id;
    }

    public String getPro_num() {
        return pro_num;
    }

    public void setPro_num(String pro_num) {
        this.pro_num = pro_num;
    }

    public String getExecute_name() {
        return execute_name;
    }

    public void setExecute_name(String execute_name) {
        this.execute_name = execute_name;
    }

    public String getPass_percent() {
        return pass_percent;
    }

    public void setPass_percent(String pass_percent) {
        this.pass_percent = pass_percent;
    }

    public String getExecute_percent() {
        return execute_percent;
    }

    public void setExecute_percent(String execute_percent) {
        this.execute_percent = execute_percent;
    }

    public String getPro_id() {
        return pro_id;
    }

    public void setPro_id(String pro_id) {
        this.pro_id = pro_id;
    }

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }

    public String getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(String update_time) {
        this.update_time = update_time;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getOper_uid() {
        return oper_uid;
    }

    public void setOper_uid(String oper_uid) {
        this.oper_uid = oper_uid;
    }

    public List<CheckListBean> getPro_list() {
        return pro_list;
    }

    public void setPro_list(List<CheckListBean> pro_list) {
        this.pro_list = pro_list;
    }

    public List<GroupMemberInfo> getMember_list() {
        return member_list;
    }

    public void setMember_list(List<GroupMemberInfo> member_list) {
        this.member_list = member_list;
    }
}
