package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * 任务实体bean
 */

public class TaskBean {
    private String real_name;
    private String head_pic;
    private String create_time;
    private String task_finish_time;
    private String task_content;
    private List<String> task_imgs;
    private String team_or_group_name;
    private int task_level;  //任务等级  1：一般；2：紧急；3：非常紧急
    private String uid;
    private List<GroupMemberInfo> members;
    private List<GroupMemberInfo> unrelay_members;
    private ReadInfos pub_man;
    private int task_status;//是否已完成 1已完成
    private int is_can_deal;//能否处理 1：能；0：不能

    public int getTask_status() {
        return task_status;
    }

    public void setTask_status(int task_status) {
        this.task_status = task_status;
    }

    public int getIs_can_deal() {
        return is_can_deal;
    }

    public void setIs_can_deal(int is_can_deal) {
        this.is_can_deal = is_can_deal;
    }

    public ReadInfos getPub_man() {
        return pub_man;
    }

    public void setPub_man(ReadInfos pub_man) {
        this.pub_man = pub_man;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }

    public String getHead_pic() {
        return head_pic;
    }

    public void setHead_pic(String head_pic) {
        this.head_pic = head_pic;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public String getTask_finish_time() {
        return task_finish_time;
    }

    public void setTask_finish_time(String task_finish_time) {
        this.task_finish_time = task_finish_time;
    }

    public String getTask_content() {
        return task_content;
    }

    public void setTask_content(String task_content) {
        this.task_content = task_content;
    }

    public List<String> getTask_imgs() {
        return task_imgs;
    }

    public void setTask_imgs(List<String> task_imgs) {
        this.task_imgs = task_imgs;
    }

    public String getTeam_or_group_name() {
        return team_or_group_name;
    }

    public void setTeam_or_group_name(String team_or_group_name) {
        this.team_or_group_name = team_or_group_name;
    }

    public int getTask_level() {
        return task_level;
    }

    public void setTask_level(int task_level) {
        this.task_level = task_level;
    }

    public List<GroupMemberInfo> getMembers() {
        return members;
    }

    public void setMembers(List<GroupMemberInfo> members) {
        this.members = members;
    }

    public List<GroupMemberInfo> getUnrelay_members() {
        return unrelay_members;
    }

    public void setUnrelay_members(List<GroupMemberInfo> unrelay_members) {
        this.unrelay_members = unrelay_members;
    }
}
