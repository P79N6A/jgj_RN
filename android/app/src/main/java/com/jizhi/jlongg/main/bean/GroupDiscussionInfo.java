package com.jizhi.jlongg.main.bean;


import org.litepal.annotation.Column;
import org.litepal.crud.LitePalSupport;

import java.io.Serializable;
import java.util.List;

/**
 * 功能: 班组讨论消息
 * 作者：xuj
 * 时间: 2016-8-30 10:49
 */
public class GroupDiscussionInfo extends LitePalSupport implements Serializable {
    /**
     * 班组id
     */
    public String group_id;
    /**
     * 班组名
     */
    public String group_name;
    /**
     * 城市名称
     */
    public String city_name;
    /**
     * 组类型（group 班组 team讨论组）
     */
    public String class_type;
    /**
     * 项目全称
     */
    public String all_pro_name;
    /**
     * 项目ID
     */
    public String pro_id;
    /**
     * 项目名
     */
    public String pro_name;
    /**
     * 讨论组头像
     */
    public List<String> members_head_pic;
    /**
     * 创建者名字
     */
    public String creater_name;
    /**
     * 发送的消息
     */
    public String msg_text;
    /**
     * 消息发送人id,如果是自己发的需要加上--> 我：
     */
    public String msg_sender;
    /**
     * 消息发送人名称,如果是自己发的需要加上--> 我：
     */
    public String real_name;
    /**
     * 班组成员数量
     */
    public String members_num;
    /**
     * 是否是数据来源人
     */
    public int is_source_member;
    /**
     * @我的消息
     */
    public String at_message;
    /**
     * 是否免打扰 1.免打扰
     */
    public int is_no_disturbed;
    /**
     * 是否置顶
     */
    public int is_sticked;
    /**
     * 扫描时的邀请人Id
     */
    public String inviter_uid;
    /**
     * 消息发送时间
     */
    public long send_time;
    /**
     * 1表示已经关闭，0没有关闭
     */
    public int is_closed;
    /**
     * 当为 0 时 跳转到添加朋友的页面
     */
    public int is_chat;
    /**
     * 关闭时间
     */
    public String close_time;
    /**
     * 项目是否被选中 1.选中 0表示未选中
     */
    public int is_selected;
    /**
     * 是否是记录员
     */
    public int is_report;
    /**
     * 数据来源人 1：没有  0：有
     */
    public int is_not_source;
    /**
     * 1 表示管理员、0标识普通成员
     */
    public int can_at_all;
    /**
     * 1 表示已被标记删除聊天
     */
    public int is_delete;
    /**
     * 是否已存在
     */
    public int is_exist;
    /**
     * 最大已读id
     */
    public long max_readed_msg_id;
    /**
     * 最大已接受id
     */
    public long max_asked_msg_id;


    public int id;
    /**
     * 未发送的消息
     */
    public String unsend_msg;
    @Column(ignore = true)
    public String cat_id;
    @Column(ignore = true)
    public String cat_name;
    /**
     * 是否设置了我在本组的名称
     */
    @Column(ignore = true)
    public int is_nickname;
    /**
     * 找工作内容
     */
    @Column(ignore = true)
    public ProjectBase prodetailactive;
    /**
     * 找帮手内容
     */
    @Column(ignore = true)
    public FindHelper searchuser;
    /**
     * 是否是找工作
     */
    @Column(ignore = true)
    public int is_find_job;
    /**
     * 1:高级版 0：普通版
     */
    public int is_senior;
    /**
     * 1.项目已过期  0.未过期
     */
    public int is_senior_expire;
    /**
     * 已购买的人数
     */
    public int buyer_person;
    /**
     * 已使用的云盘空间 (单位为GB)
     */
    public double used_space;
    /**
     * 购买的云盘空间
     */
    public long cloud_space;
    /**
     * 1是默认项目
     */
    public int is_default;
    /**
     * 1.已经试用过  0.未试用
     */
    public int is_buyed;
    /**
     * 云盘空间总大小
     */
    public double cloud_disk;
    /**
     * 我在当前组的名字
     */
    public String cur_name;
    /**
     * 代班长信息
     */
    public AgencyGroupUser agency_group_user;
    /**
     * 代班长信息 储存在数据库的信息
     */
    public String agency_group_user_json;
    /**
     * 是否代班的标识
     */
    public int is_angcy;
    /**
     * 项目组创建者id
     */
    private String creater_uid;
    /**
     * 成员头像我们这里用数组来存
     */
    private String members_head_pic_json;
    /**
     * 未读消息数量
     */
    public int unread_msg_count;
    /**
     * 标识当前用户的uid
     * 主要是当切换账户的时候需要使用到根据不同的uid取不同的东西
     */
    private String message_uid;
    /**
     * 项目组、班组、群聊创建时间
     */
    private long create_time;
    /**
     * 标题,招聘小助手和工作消息会使用到
     */
    private String title;
    /**
     * 聊聊列表根据这个字段去排序
     */
    private long sort_time;
    /**
     * 来自哪里的添加
     * 1表示从快速加群-->工种群
     * 2表示从快速加群-->地区群
     */
    private int add_from;
    /**
     * 防骗信息的消息提示时间
     * 同一个群一天一次
     */
    private String hint_msg_date;
    /**
     *
     */
    private String bill_id;

    /**
     * 草稿文本
     */
    private String draft_text;
    /**
     * 认证状态3。认证
     */
    @Column(ignore = true)
    private String verified;
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
     * 未读工作消息数
     */
    private int work_message_num;
    /**
     * 其他项目的小红点
     */
    private int other_group_unread_msg_count;
    /**
     * 出勤公示小红点
     */
    private int unread_billRecord_count;
    //简历跳转的聊天
    private int is_resume;
    public int getIs_resume() {
        return is_resume;
    }

    public void setIs_resume(int is_resume) {
        this.is_resume = is_resume;
    }

    public String getVerified() {
        return verified;
    }

    public void setVerified(String verified) {
        this.verified = verified;
    }

    public ProjectBase getProdetailactive() {
        return prodetailactive;
    }

    public void setProdetailactive(ProjectBase prodetailactive) {
        this.prodetailactive = prodetailactive;
    }

    public FindHelper getSearchuser() {
        return searchuser;
    }

    public void setSearchuser(FindHelper searchuser) {
        this.searchuser = searchuser;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }


    public String getGroup_name() {
        return group_name;
    }

    public void setGroup_name(String group_name) {
        this.group_name = group_name;
    }

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getAll_pro_name() {
        return all_pro_name;
    }

    public void setAll_pro_name(String all_pro_name) {
        this.all_pro_name = all_pro_name;
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


    public int getUnread_msg_count() {
        return unread_msg_count;
    }

    public void setUnread_msg_count(int unread_msg_count) {
        this.unread_msg_count = unread_msg_count;
    }


    public List<String> getMembers_head_pic() {
        return members_head_pic;
    }

    public void setMembers_head_pic(List<String> members_head_pic) {
        this.members_head_pic = members_head_pic;
    }

    public String getCreater_name() {
        return creater_name;
    }

    public void setCreater_name(String creater_name) {
        this.creater_name = creater_name;
    }

    public String getMsg_text() {
        return msg_text;
    }

    public void setMsg_text(String msg_text) {
        this.msg_text = msg_text;
    }

    public String getMembers_num() {
        return members_num;
    }

    public void setMembers_num(String members_num) {
        this.members_num = members_num;
    }

    public int getIs_source_member() {
        return is_source_member;
    }

    public void setIs_source_member(int is_source_member) {
        this.is_source_member = is_source_member;
    }

    public String getAt_message() {
        return at_message;
    }

    public void setAt_message(String at_message) {
        this.at_message = at_message;
    }

    public int getIs_no_disturbed() {
        return is_no_disturbed;
    }

    public void setIs_no_disturbed(int is_no_disturbed) {
        this.is_no_disturbed = is_no_disturbed;
    }

    public int getIs_sticked() {
        return is_sticked;
    }

    public void setIs_sticked(int is_sticked) {
        this.is_sticked = is_sticked;
    }

    public String getInviter_uid() {
        return inviter_uid;
    }

    public void setInviter_uid(String inviter_uid) {
        this.inviter_uid = inviter_uid;
    }

    public long getSend_time() {
        return send_time;
    }

    public void setSend_time(long send_time) {
        this.send_time = send_time;
    }

    public int getIs_closed() {
        return is_closed;
    }

    public void setIs_closed(int is_closed) {
        this.is_closed = is_closed;
    }

    public int getIs_chat() {
        return is_chat;
    }

    public void setIs_chat(int is_chat) {
        this.is_chat = is_chat;
    }

    public String getClose_time() {
        return close_time;
    }

    public void setClose_time(String close_time) {
        this.close_time = close_time;
    }

    public int getIs_selected() {
        return is_selected;
    }

    public void setIs_selected(int is_selected) {
        this.is_selected = is_selected;
    }

    public int getIs_report() {
        return is_report;
    }

    public void setIs_report(int is_report) {
        this.is_report = is_report;
    }

    public int getIs_not_source() {
        return is_not_source;
    }

    public void setIs_not_source(int is_not_source) {
        this.is_not_source = is_not_source;
    }

    public int getCan_at_all() {
        return can_at_all;
    }

    public void setCan_at_all(int can_at_all) {
        this.can_at_all = can_at_all;
    }

    public String getCat_id() {
        return cat_id;
    }

    public void setCat_id(String cat_id) {
        this.cat_id = cat_id;
    }

    public String getCat_name() {
        return cat_name;
    }

    public void setCat_name(String cat_name) {
        this.cat_name = cat_name;
    }

    public int getIs_senior() {
        return is_senior;
    }

    public void setIs_senior(int is_senior) {
        this.is_senior = is_senior;
    }

    public int getIs_senior_expire() {
        return is_senior_expire;
    }

    public void setIs_senior_expire(int is_senior_expire) {
        this.is_senior_expire = is_senior_expire;
    }

    public int getBuyer_person() {
        return buyer_person;
    }

    public void setBuyer_person(int buyer_person) {
        this.buyer_person = buyer_person;
    }

    public double getUsed_space() {
        return used_space;
    }

    public void setUsed_space(double used_space) {
        this.used_space = used_space;
    }

    public long getCloud_space() {
        return cloud_space;
    }

    public void setCloud_space(long cloud_space) {
        this.cloud_space = cloud_space;
    }

    public int getIs_default() {
        return is_default;
    }

    public void setIs_default(int is_default) {
        this.is_default = is_default;
    }

    public int getIs_buyed() {
        return is_buyed;
    }

    public void setIs_buyed(int is_buyed) {
        this.is_buyed = is_buyed;
    }

    public double getCloud_disk() {
        return cloud_disk;
    }

    public void setCloud_disk(double cloud_disk) {
        this.cloud_disk = cloud_disk;
    }

    public String getCur_name() {
        return cur_name;
    }

    public void setCur_name(String cur_name) {
        this.cur_name = cur_name;
    }

    public AgencyGroupUser getAgency_group_user() {
        return agency_group_user;
    }

    public void setAgency_group_user(AgencyGroupUser agency_group_user) {
        this.agency_group_user = agency_group_user;
    }

    public int getIs_angcy() {
        return is_angcy;
    }

    public void setIs_angcy(int is_angcy) {
        this.is_angcy = is_angcy;
    }


    public String getMembers_head_pic_json() {
        return members_head_pic_json;
    }

    public void setMembers_head_pic_json(String members_head_pic_json) {
        this.members_head_pic_json = members_head_pic_json;
    }


    public String getMessage_uid() {
        return message_uid;
    }

    public void setMessage_uid(String message_uid) {
        this.message_uid = message_uid;
    }

    public String getCreater_uid() {
        return creater_uid;
    }

    public void setCreater_uid(String creater_uid) {
        this.creater_uid = creater_uid;
    }

    public int getIs_delete() {
        return is_delete;
    }

    public void setIs_delete(int is_delete) {
        this.is_delete = is_delete;
    }

    @Override
    public String toString() {
        return "GroupDiscussionInfo{" +
                "group_id='" + group_id + '\'' +
                ", group_name='" + group_name + '\'' +
                ", class_type='" + class_type + '\'' +
                ", is_no_disturbed=" + is_no_disturbed +
                ", is_sticked=" + is_sticked +
                '}';
    }

    public String getCity_name() {
        return city_name;
    }

    public void setCity_name(String city_name) {
        this.city_name = city_name;
    }

    public long getCreate_time() {
        return create_time;
    }

    public void setCreate_time(long create_time) {
        this.create_time = create_time;
    }

    public String getAgency_group_user_json() {
        return agency_group_user_json;
    }

    public void setAgency_group_user_json(String agency_group_user_json) {
        this.agency_group_user_json = agency_group_user_json;
    }

    public String getMsg_sender() {
        return msg_sender;
    }

    public void setMsg_sender(String msg_sender) {
        this.msg_sender = msg_sender;
    }

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public long getSort_time() {
        return sort_time;
    }

    public void setSort_time(long sort_time) {
        this.sort_time = sort_time;
    }


    public String getUnsend_msg() {
        return unsend_msg;
    }

    public void setUnsend_msg(String unsend_msg) {
        this.unsend_msg = unsend_msg;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public long getMax_readed_msg_id() {
        return max_readed_msg_id;
    }

    public void setMax_readed_msg_id(long max_readed_msg_id) {
        this.max_readed_msg_id = max_readed_msg_id;
    }

    public long getMax_asked_msg_id() {
        return max_asked_msg_id;
    }

    public void setMax_asked_msg_id(long max_asked_msg_id) {
        this.max_asked_msg_id = max_asked_msg_id;
    }

    public int getIs_exist() {
        return is_exist;
    }

    public void setIs_exist(int is_exist) {
        this.is_exist = is_exist;
    }

    public int getAdd_from() {
        return add_from;
    }

    public void setAdd_from(int add_from) {
        this.add_from = add_from;
    }

    public String getHint_msg_date() {
        return hint_msg_date;
    }

    public void setHint_msg_date(String hint_msg_date) {
        this.hint_msg_date = hint_msg_date;
    }

    public String getDraft_text() {
        return draft_text;
    }

    public void setDraft_text(String draft_text) {
        this.draft_text = draft_text;
    }

    public String getBill_id() {
        return bill_id;
    }

    public void setBill_id(String bill_id) {
        this.bill_id = bill_id;
    }

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

    public int getIs_find_job() {
        return is_find_job;
    }

    public void setIs_find_job(int is_find_job) {
        this.is_find_job = is_find_job;
    }
}
