package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * CName:记工变更对象
 * User: hcs
 * Date: 2018-8-3
 * Time: 14:48
 */
public class AccountModifyBean implements Serializable {
    private int id;// 变更记录ID 
    private String uid;//操作人ID 
    private int role;// 2为班长3为带班长 
    private String group_id;// 班组ID 
    private String record_id;//记账ID 
    private int record_type;//记账变更类型:1新增2修改3删除 
    private String record_time;// 变更时间
    private String create_time;// 记账时间
    private int is_active;// 是否展示 
    private String nl_date;// 操作农历日期 
    private String last_operate_msg;//删除时有:上一次操作人信息
    private AccountWorkRember record_info;//记账详情
    //新增记账信息
    private List<AddInfoBean> add_info;
    private UserInfo user_info;
    private int type;
    private String worker_name;//工人名称
    private String foreman_name;//工头名称

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getRecord_id() {
        return record_id;
    }

    public void setRecord_id(String record_id) {
        this.record_id = record_id;
    }

    public int getRecord_type() {
        return record_type;
    }

    public void setRecord_type(int record_type) {
        this.record_type = record_type;
    }

    public String getRecord_time() {
        return record_time;
    }

    public void setRecord_time(String record_time) {
        this.record_time = record_time;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public int getIs_active() {
        return is_active;
    }

    public void setIs_active(int is_active) {
        this.is_active = is_active;
    }

    public String getNl_date() {
        return nl_date;
    }

    public void setNl_date(String nl_date) {
        this.nl_date = nl_date;
    }

    public String getLast_operate_msg() {
        return last_operate_msg;
    }

    public void setLast_operate_msg(String last_operate_msg) {
        this.last_operate_msg = last_operate_msg;
    }

    public AccountWorkRember getRecord_info() {
        return record_info;
    }

    public void setRecord_info(AccountWorkRember record_info) {
        this.record_info = record_info;
    }

    public List<AddInfoBean> getAdd_info() {
        return add_info;
    }

    public void setAdd_info(List<AddInfoBean> add_info) {
        this.add_info = add_info;
    }

    public String getWorker_name() {
        return worker_name;
    }

    public void setWorker_name(String worker_name) {
        this.worker_name = worker_name;
    }

    public String getForeman_name() {
        return foreman_name;
    }

    public void setForeman_name(String foreman_name) {
        this.foreman_name = foreman_name;
    }
}
