package com.jizhi.jlongg.main.bean;

import com.jizhi.jlongg.main.activity.WebSocketBaseParameter;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能: 班组管理
 * 作者：Xuj
 * 时间: 2016年9月1日 15:08:28
 */
public class GroupManager extends WebSocketBaseParameter {
    /**
     *
     */
    private ArrayList<GroupDiscussionInfo> local_list;
    /**
     *
     */
    private ArrayList<GroupDiscussionInfo> work_list;
    /**
     * 班组成员
     */
    private List<GroupMemberInfo> member_list;
    /**
     * 汇报对象
     */
    private List<GroupMemberInfo> report_user_list;
    /**
     * 班组信息
     */
    private GroupDiscussionInfo group_info;
    /**
     * 我在本组的名称
     */
    private String nickname;
    /**
     * 成员数量
     */
    private int members_num;
    /**
     * 最大人数
     */
    private int max_person;
    /**
     * 消息是否置顶
     */
    private int is_sticked;
    /**
     * 消息免打扰
     */
    private int is_no_disturbed;
    /**
     * 1.管理员 0.非管理员
     */
    private int is_admin;
    /**
     * 头像地址
     */
    private List<String> members_head_pic;
    /**
     * 产品信息
     */
    private List<ProductTips> current_server;
    /**
     * 管理员数量
     */
    private int admins_num;
    /**
     * 设置代班长信息
     */
    private AgencyGroupUser agency_group_user;


    public List<GroupMemberInfo> getMember_list() {
        return member_list;
    }

    public void setMember_list(List<GroupMemberInfo> member_list) {
        this.member_list = member_list;
    }

    public List<GroupMemberInfo> getReport_user_list() {
        return report_user_list;
    }

    public void setReport_user_list(List<GroupMemberInfo> report_user_list) {
        this.report_user_list = report_user_list;
    }

    public GroupDiscussionInfo getGroup_info() {
        return group_info;
    }

    public void setGroup_info(GroupDiscussionInfo group_info) {
        this.group_info = group_info;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public int getMembers_num() {
        return members_num;
    }

    public void setMembers_num(int members_num) {
        this.members_num = members_num;
    }

    public int getMax_person() {
        return max_person;
    }

    public void setMax_person(int max_person) {
        this.max_person = max_person;
    }

    public int getIs_sticked() {
        return is_sticked;
    }

    public void setIs_sticked(int is_sticked) {
        this.is_sticked = is_sticked;
    }

    public int getIs_no_disturbed() {
        return is_no_disturbed;
    }

    public void setIs_no_disturbed(int is_no_disturbed) {
        this.is_no_disturbed = is_no_disturbed;
    }

    public int getIs_admin() {
        return is_admin;
    }

    public void setIs_admin(int is_admin) {
        this.is_admin = is_admin;
    }

    public List<String> getMembers_head_pic() {
        return members_head_pic;
    }

    public void setMembers_head_pic(List<String> members_head_pic) {
        this.members_head_pic = members_head_pic;
    }

    public List<ProductTips> getCurrent_server() {
        return current_server;
    }

    public void setCurrent_server(List<ProductTips> current_server) {
        this.current_server = current_server;
    }

    public int getAdmins_num() {
        return admins_num;
    }

    public void setAdmins_num(int admins_num) {
        this.admins_num = admins_num;
    }

    public AgencyGroupUser getAgency_group_user() {
        return agency_group_user;
    }

    public void setAgency_group_user(AgencyGroupUser agency_group_user) {
        this.agency_group_user = agency_group_user;
    }

    public ArrayList<GroupDiscussionInfo> getLocal_list() {
        return local_list;
    }

    public void setLocal_list(ArrayList<GroupDiscussionInfo> local_list) {
        this.local_list = local_list;
    }

    public ArrayList<GroupDiscussionInfo> getWork_list() {
        return work_list;
    }

    public void setWork_list(ArrayList<GroupDiscussionInfo> work_list) {
        this.work_list = work_list;
    }
}
