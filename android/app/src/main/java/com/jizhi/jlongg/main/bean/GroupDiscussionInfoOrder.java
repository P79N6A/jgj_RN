package com.jizhi.jlongg.main.bean;


import org.litepal.annotation.Column;

import java.io.Serializable;
import java.util.List;

/**
 * 功能: 班组讨论消息
 * 作者：xuj
 * 时间: 2016-8-30 10:49
 */
public class GroupDiscussionInfoOrder  implements Serializable {
    /**
     * 班组id
     */
    public String group_id;
    /**
     * 项目组id
     */
    public String team_id;
    /**
     * 班组名
     */
    public String group_name;
    /**
     * 城市名称
     */
    public String city_name;
    /**
     * 项目组名称
     */
    public String team_name;
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
     * work 工作消息
     * activity 活动消息
     * recruit 招聘消息
     */
    public String sys_msg_type;
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

    @Column(ignore = true)
    public String cat_id;
    @Column(ignore = true)
    public String cat_name;
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
    public int id;
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
     * 最大已读msg_id
     */
    private long max_readed_msg_id;
    /**
     * 最大已接收msg_id
     */
    private long max_asked_msg_id;
    /**
     * 未读消息数量
     */
    public int unread_msg_count;
    /**
     * 标识当前用户的uid
     * 主要是当切换账户的时候需要使用到根据不同的uid取不同的东西
     */
    private String message_uid;


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

    public String getTeam_id() {
        return team_id;
    }

    public void setTeam_id(String team_id) {
        this.team_id = team_id;
    }

    public String getGroup_name() {
        return group_name;
    }

    public void setGroup_name(String group_name) {
        this.group_name = group_name;
    }

    public String getTeam_name() {
        return team_name;
    }

    public void setTeam_name(String team_name) {
        this.team_name = team_name;
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

    public String getSys_msg_type() {
        return sys_msg_type;
    }

    public void setSys_msg_type(String sys_msg_type) {
        this.sys_msg_type = sys_msg_type;
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

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

}
