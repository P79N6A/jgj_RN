package com.jizhi.jlongg.main.bean;

import org.litepal.crud.LitePalSupport;

import java.io.Serializable;

public class ChatMainInfo extends LitePalSupport implements Serializable {
    /**
     * id
     */
    private int id;
    /**
     * 未读质量数
     */
    private int unread_quality_count;
    /**
     * 未读安全数
     */
    private int unread_safe_count;
    /**
     * 未读检查数
     */
    private int unread_inspect_count;
    /**
     * 未读任务数
     */
    private int unread_task_count;
    /**
     * 未读通知数
     */
    private int unread_notice_count;
    /**
     * 未读签到数
     */
    private int unread_sign_count;
    /**
     * 未读会议数
     */
    private int unread_meeting_count;
    /**
     * 未读审批数数
     */
    private int unread_approval_count;
    /**
     * 未读日志数
     */
    private int unread_log_count;
    /**
     * 未读晴雨表数
     */
    private int unread_weath_count;
    /**
     * 出勤公示小红点
     */
    private int unread_billRecord_count;
    /**
     * 未读工作回复消息数
     */
    private int work_message_num;
    /**
     * 其他项目的小红点
     */
    private int other_group_unread_msg_count;
    /**
     * 项目组信息
     */
    private GroupDiscussionInfo group_info;
    /**
     * 将项目组信息以Json数组的方式存储
     */
    private String group_info_json;
    /**
     * 当前所属id
     * 根据这个id查询 不同人登录的账户
     */
    private String message_uid;


    public int getUnread_quality_count() {
        return unread_quality_count;
    }

    public void setUnread_quality_count(int unread_quality_count) {
        this.unread_quality_count = unread_quality_count;
    }

    public int getUnread_safe_count() {
        return unread_safe_count;
    }

    public void setUnread_safe_count(int unread_safe_count) {
        this.unread_safe_count = unread_safe_count;
    }

    public int getUnread_inspect_count() {
        return unread_inspect_count;
    }

    public void setUnread_inspect_count(int unread_inspect_count) {
        this.unread_inspect_count = unread_inspect_count;
    }

    public int getUnread_task_count() {
        return unread_task_count;
    }

    public void setUnread_task_count(int unread_task_count) {
        this.unread_task_count = unread_task_count;
    }

    public int getUnread_notice_count() {
        return unread_notice_count;
    }

    public void setUnread_notice_count(int unread_notice_count) {
        this.unread_notice_count = unread_notice_count;
    }

    public int getUnread_sign_count() {
        return unread_sign_count;
    }

    public void setUnread_sign_count(int unread_sign_count) {
        this.unread_sign_count = unread_sign_count;
    }

    public int getUnread_meeting_count() {
        return unread_meeting_count;
    }

    public void setUnread_meeting_count(int unread_meeting_count) {
        this.unread_meeting_count = unread_meeting_count;
    }

    public int getUnread_approval_count() {
        return unread_approval_count;
    }

    public void setUnread_approval_count(int unread_approval_count) {
        this.unread_approval_count = unread_approval_count;
    }

    public int getUnread_log_count() {
        return unread_log_count;
    }

    public void setUnread_log_count(int unread_log_count) {
        this.unread_log_count = unread_log_count;
    }


    public int getUnread_weath_count() {
        return unread_weath_count;
    }

    public void setUnread_weath_count(int unread_weath_count) {
        this.unread_weath_count = unread_weath_count;
    }


    public int getWork_message_num() {
        return work_message_num;
    }

    public void setWork_message_num(int work_message_num) {
        this.work_message_num = work_message_num;
    }

    public GroupDiscussionInfo getGroup_info() {
        return group_info;
    }

    public void setGroup_info(GroupDiscussionInfo group_info) {
        this.group_info = group_info;
    }

    public String getGroup_info_json() {
        return group_info_json;
    }

    public void setGroup_info_json(String group_info_json) {
        this.group_info_json = group_info_json;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "ChatMainInfo{" +
                "id=" + id +
                ", unread_quality_count=" + unread_quality_count +
                ", unread_safe_count=" + unread_safe_count +
                ", unread_inspect_count=" + unread_inspect_count +
                ", unread_task_count=" + unread_task_count +
                ", unread_notice_count=" + unread_notice_count +
                ", unread_sign_count=" + unread_sign_count +
                ", unread_meeting_count=" + unread_meeting_count +
                ", unread_approval_count=" + unread_approval_count +
                ", unread_log_count=" + unread_log_count +
                ", unread_weath_count=" + unread_weath_count +
                ", work_message_num=" + work_message_num +
                ", group_info=" + group_info +
                ", group_info_json='" + group_info_json + '\'' +
                '}';
    }


    public String getMessage_uid() {
        return message_uid;
    }

    public void setMessage_uid(String message_uid) {
        this.message_uid = message_uid;
    }


    public int getOther_group_unread_msg_count() {
        return other_group_unread_msg_count;
    }

    public void setOther_group_unread_msg_count(int other_group_unread_msg_count) {
        this.other_group_unread_msg_count = other_group_unread_msg_count;
    }

    public int getUnread_billRecord_count() {
        return unread_billRecord_count;
    }

    public void setUnread_billRecord_count(int unread_billRecord_count) {
        this.unread_billRecord_count = unread_billRecord_count;
    }
}
