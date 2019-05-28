package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * CName:检查列表二级
 * User: hcs
 * Date: 2017-11-24
 * Time: 11:22
 */

public class CheckPlanListBean implements Serializable {
    private String content_name; //检查内容名称
    private String content_id;//检查内容id
    private int status;//检查状态
    private String id;//检查点状态id
    private String plan_id;//检查计划id
    private String plan_name;//检查计划名称
    private String dot_name;//检查名称
    private String execute_time;//执行时间
    private String pro_name;//检查项名称
    private String pro_id;//检查项目id
    private String dot_id;//检查点id
    private String uid;//执行用户
    private UserInfo user_info;////执行用户
    private String comment;//回复内容
    private List<String> imgs;
    private String create_time;//回复内容
    private String update_time;//回复内容
    private String is_active;//回复内容
    private String msg_type;//消息类型
    private int msg_id;//消息id
    private String dot_status_id;///检查点状态id
    private List<CheckPlanListBean> dot_status_list;//第三层
    private List<CheckPlanListBean> dot_list;//第2层
    private boolean child_isExpanded;//第二层是否展开;
    private int is_operate;//1有权限操作
    private List<CheckPlanListBean> log_list;
    private ArrayList<GroupMemberInfo> member_list; //执行成员
    private ArrayList<CheckList> pro_list;


    public int getIs_operate() {
        return is_operate;
    }

    public void setIs_operate(int is_operate) {
        this.is_operate = is_operate;
    }

    public boolean isChild_isExpanded() {
        return child_isExpanded;
    }

    public void setChild_isExpanded(boolean child_isExpanded) {
        this.child_isExpanded = child_isExpanded;
    }

    public String getDot_name() {
        return dot_name;
    }

    public void setDot_name(String dot_name) {
        this.dot_name = dot_name;
    }

    public List<CheckPlanListBean> getDot_list() {
        return dot_list;
    }

    public void setDot_list(List<CheckPlanListBean> dot_list) {
        this.dot_list = dot_list;
    }

    public String getContent_name() {
        return content_name;
    }

    public void setContent_name(String content_name) {
        this.content_name = content_name;
    }

    public String getContent_id() {
        return content_id;
    }

    public void setContent_id(String content_id) {
        this.content_id = content_id;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPlan_id() {
        return plan_id;
    }

    public void setPlan_id(String plan_id) {
        this.plan_id = plan_id;
    }

    public String getPro_id() {
        return pro_id;
    }

    public void setPro_id(String pro_id) {
        this.pro_id = pro_id;
    }

    public String getDot_id() {
        return dot_id;
    }

    public void setDot_id(String dot_id) {
        this.dot_id = dot_id;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public List<String> getImgs() {
        return imgs;
    }

    public void setImgs(List<String> imgs) {
        this.imgs = imgs;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public String getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(String update_time) {
        this.update_time = update_time;
    }

    public String getIs_active() {
        return is_active;
    }

    public void setIs_active(String is_active) {
        this.is_active = is_active;
    }

    public String getMsg_type() {
        return msg_type;
    }

    public void setMsg_type(String msg_type) {
        this.msg_type = msg_type;
    }

    public int getMsg_id() {
        return msg_id;
    }

    public void setMsg_id(int msg_id) {
        this.msg_id = msg_id;
    }

    public String getDot_status_id() {
        return dot_status_id;
    }

    public void setDot_status_id(String dot_status_id) {
        this.dot_status_id = dot_status_id;
    }

    public List<CheckPlanListBean> getDot_status_list() {
        return dot_status_list;
    }

    public void setDot_status_list(List<CheckPlanListBean> dot_status_list) {
        this.dot_status_list = dot_status_list;
    }

    public List<CheckPlanListBean> getLog_list() {
        return log_list;
    }

    public void setLog_list(List<CheckPlanListBean> log_list) {
        this.log_list = log_list;
    }

    public String getPlan_name() {
        return plan_name;
    }

    public void setPlan_name(String plan_name) {
        this.plan_name = plan_name;
    }

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public String getExecute_time() {
        return execute_time;
    }

    public void setExecute_time(String execute_time) {
        this.execute_time = execute_time;
    }

    public ArrayList<GroupMemberInfo> getMember_list() {
        return member_list;
    }

    public void setMember_list(ArrayList<GroupMemberInfo> member_list) {
        this.member_list = member_list;
    }

    public ArrayList<CheckList> getPro_list() {
        return pro_list;
    }

    public void setPro_list(ArrayList<CheckList> pro_list) {
        this.pro_list = pro_list;
    }
}
