package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

public class ReplyInfo implements Serializable {
    private String id;
    private String uid;
    private String log_id;
    private String msg_id;
    private String msg_type;
    private String class_type;
    private String group_id;
    private String reply_text;
    private List<ReplyInfo> replyList;
    private List<ReadInfos> members;
    private List<ReadInfos> unrelay_members;
    private UserInfo user_info;
    private List<String> msg_src;//图片
    private String reply_status_text;
    private String reply_status;
    private String reply_type;
    private String text;
    private String insp_id;
    private String quality_id;
    private int statu;
    private String is_active;
    private String statu_name;
    private String cat_name;
    private List<ReplyInfo> list;
    private String reply_id;
    private int is_system_reply;//1：系统回复 2： 普通回复
    private List<String> reply_msg;////回复图片
    private String msg_text;
    private String pub_name;//消息发布者
    private String create_time;//创建时间
    private String readed_percent;//已读未读
    private int is_readed;//该条消息是否已读
    private int operate_delete;//是否可以删除
    private int is_delete;//是否已经删除

    public int getOperate_delete() {
        return operate_delete;
    }

    public void setOperate_delete(int operate_delete) {
        this.operate_delete = operate_delete;
    }

    public String getReaded_percent() {
        return readed_percent;
    }

    public void setReaded_percent(String readed_percent) {
        this.readed_percent = readed_percent;
    }

    public String getReply_id() {
        return reply_id;
    }

    public void setReply_id(String reply_id) {
        this.reply_id = reply_id;
    }

    public String getLog_id() {
        return log_id;
    }

    public void setLog_id(String log_id) {
        this.log_id = log_id;
    }

    public String getCat_name() {
        return cat_name;
    }

    public void setCat_name(String cat_name) {
        this.cat_name = cat_name;
    }

    public List<ReplyInfo> getList() {
        return list;
    }

    public void setList(List<ReplyInfo> list) {
        this.list = list;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getInsp_id() {
        return insp_id;
    }

    public void setInsp_id(String insp_id) {
        this.insp_id = insp_id;
    }

    public String getQuality_id() {
        return quality_id;
    }

    public void setQuality_id(String quality_id) {
        this.quality_id = quality_id;
    }

    public int getStatu() {
        return statu;
    }

    public void setStatu(int statu) {
        this.statu = statu;
    }

    public String getIs_active() {
        return is_active;
    }

    public void setIs_active(String is_active) {
        this.is_active = is_active;
    }

    public String getStatu_name() {
        return statu_name;
    }

    public void setStatu_name(String statu_name) {
        this.statu_name = statu_name;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getMsg_type() {
        return msg_type;
    }

    public void setMsg_type(String msg_type) {
        this.msg_type = msg_type;
    }

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getReply_status() {
        return reply_status;
    }

    public void setReply_status(String reply_status) {
        this.reply_status = reply_status;
    }

    public String getReply_type() {
        return reply_type;
    }

    public void setReply_type(String reply_type) {
        this.reply_type = reply_type;
    }

    public String getReply_status_text() {
        return reply_status_text;
    }

    public void setReply_status_text(String reply_status_text) {
        this.reply_status_text = reply_status_text;
    }

    public List<String> getMsg_src() {
        return msg_src;
    }

    public void setMsg_src(List<String> msg_src) {
        this.msg_src = msg_src;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public List<ReadInfos> getUnrelay_members() {
        return unrelay_members;
    }

    public void setUnrelay_members(List<ReadInfos> unrelay_members) {
        this.unrelay_members = unrelay_members;
    }

    public List<ReadInfos> getMembers() {
        return members;
    }

    public void setMembers(List<ReadInfos> members) {
        this.members = members;
    }

    private int is_replyed;

    public int getIs_replyed() {
        return is_replyed;
    }

    public void setIs_replyed(int is_replyed) {
        this.is_replyed = is_replyed;
    }

    public List<ReplyInfo> getReplyList() {
        return replyList;
    }

    public void setReplyList(List<ReplyInfo> replyList) {
        this.replyList = replyList;
    }

    private String real_name;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getMsg_id() {
        return msg_id;
    }

    public void setMsg_id(String msg_id) {
        this.msg_id = msg_id;
    }

    public String getReply_text() {
        return reply_text;
    }

    public void setReply_text(String reply_text) {
        this.reply_text = reply_text;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public int getIs_delete() {
        return is_delete;
    }

    public void setIs_delete(int is_delete) {
        this.is_delete = is_delete;
    }

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }

    public int getIs_system_reply() {
        return is_system_reply;
    }

    public void setIs_system_reply(int is_system_reply) {
        this.is_system_reply = is_system_reply;
    }

    public List<String> getReply_msg() {
        return reply_msg;
    }

    public void setReply_msg(List<String> reply_msg) {
        this.reply_msg = reply_msg;
    }

    public String getMsg_text() {
        return msg_text;
    }

    public void setMsg_text(String msg_text) {
        this.msg_text = msg_text;
    }

    public String getPub_name() {
        return pub_name;
    }

    public void setPub_name(String pub_name) {
        this.pub_name = pub_name;
    }

    public int getIs_readed() {
        return is_readed;
    }

    public void setIs_readed(int is_readed) {
        this.is_readed = is_readed;
    }
}
