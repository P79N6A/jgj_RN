
package com.jizhi.jlongg.main.bean;


import org.litepal.crud.LitePalSupport;

import java.io.Serializable;
import java.util.List;

/**
 * CName:消息内容
 * User: hcs
 * Date: 2016-08-25
 * Time: 18:01
 */
public class ChatMsgEntity extends LitePalSupport implements Serializable {
    private String msg_id;
    //内容
    private String msg_text;
    //名字
    private String date;
    //date
    private String user_name;
    //date
    private String head_pic;
    //班组group_id，0:表示没有班组 如果是全局是工人角色，不会返回此字段
    private String group_id;
    //文本消息
    private String msg_type;
    private String is_out_member;
    private int msg_type_num;
    private String local_id;

    private String team_id;

    private List<String> msg_src;
    private ReadInfo read_info;
    //消息状态 0。成功  1.失败  2.发送中
    private int msg_state;

    private String voice_long;
    //消息状态 1已读  0未读
    private String is_readed;
    //消息状态 1已读  1.未读
    private int unread_num;
    //消息状态 1已读  1.未读
    private List<ChatMsgEntity> msg_list;
    private String record_id;
    private String bill_id = "0";
    private String accounts_type;
    private int notice;
    private int log;
    private int safe;
    private int quality;
    private int badge;
    private int sign;
    private int is_next_act;
    private String class_type;
    private List<ChatMsgEntity> list;
    private String send_time;
    private String msg_sender;
    private String fmt_date;
    private String proName;
    private String groupName;
    private String path;
    private List<String> pic_w_h;
    private String s_date;
    private String uid;
    private String status;
    private String from_group_name;
    private String weat_am;//上午天气
    private String weat_pm;//下午天气
    private String wind_am;//上午风力
    private String wind_pm;//下午风力
    private String temp_am;//上午温度
    private String temp_pm;//下午温度
    private String techno_quali_log;//技术质量工作记录
    private int is_exist;

    private String msg;
    public int getIs_exist() {
        return is_exist;
    }

    public int getIs_next_act() {
        return is_next_act;
    }

    public void setIs_next_act(int is_next_act) {
        this.is_next_act = is_next_act;
    }

    public void setIs_exist(int is_exist) {
        this.is_exist = is_exist;
    }

    public String getWeat_am() {
        return weat_am;
    }

    public void setWeat_am(String weat_am) {
        this.weat_am = weat_am;
    }

    public String getWeat_pm() {
        return weat_pm;
    }

    public void setWeat_pm(String weat_pm) {
        this.weat_pm = weat_pm;
    }

    public String getWind_am() {
        return wind_am;
    }

    public void setWind_am(String wind_am) {
        this.wind_am = wind_am;
    }

    public String getWind_pm() {
        return wind_pm;
    }

    public void setWind_pm(String wind_pm) {
        this.wind_pm = wind_pm;
    }

    public String getTemp_am() {
        return temp_am;
    }

    public void setTemp_am(String temp_am) {
        this.temp_am = temp_am;
    }

    public String getTemp_pm() {
        return temp_pm;
    }

    public void setTemp_pm(String temp_pm) {
        this.temp_pm = temp_pm;
    }

    public String getTechno_quali_log() {
        return techno_quali_log;
    }

    public void setTechno_quali_log(String techno_quali_log) {
        this.techno_quali_log = techno_quali_log;
    }

    public String getFrom_group_name() {
        return from_group_name;
    }

    public void setFrom_group_name(String from_group_name) {
        this.from_group_name = from_group_name;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getS_date() {
        return s_date;
    }

    public void setS_date(String s_date) {
        this.s_date = s_date;
    }

    public List<String> getPic_w_h() {
        return pic_w_h;
    }

    public void setPic_w_h(List<String> pic_w_h) {
        this.pic_w_h = pic_w_h;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getProName() {
        return proName;
    }

    public void setProName(String proName) {
        this.proName = proName;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getFmt_date() {
        return fmt_date;
    }

    public void setFmt_date(String fmt_date) {
        this.fmt_date = fmt_date;
    }

    public String getSend_time() {
        return send_time;
    }

    public void setSend_time(String send_time) {
        this.send_time = send_time;
    }

    public String getMsg_sender() {
        return msg_sender;
    }

    public void setMsg_sender(String msg_sender) {
        this.msg_sender = msg_sender;
    }

    public List<ChatMsgEntity> getList() {
        return list;
    }

    public void setList(List<ChatMsgEntity> list) {
        this.list = list;
    }

    public int getSign() {
        return sign;
    }

    public void setSign(int sign) {
        this.sign = sign;
    }

    public int getBadge() {
        return badge;
    }

    public void setBadge(int badge) {
        this.badge = badge;
    }

    public int getNotice() {
        return notice;
    }

    public void setNotice(int notice) {
        this.notice = notice;
    }

    public int getLog() {
        return log;
    }

    public void setLog(int log) {
        this.log = log;
    }

    public int getSafe() {
        return safe;
    }

    public void setSafe(int safe) {
        this.safe = safe;
    }

    public int getQuality() {
        return quality;
    }

    public void setQuality(int quality) {
        this.quality = quality;
    }

    public String getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(String accounts_type) {
        this.accounts_type = accounts_type;
    }

    public String getBill_id() {
        return bill_id;
    }

    public void setBill_id(String bill_id) {
        this.bill_id = bill_id;
    }

    public String getRecord_id() {
        return record_id;
    }

    public void setRecord_id(String record_id) {
        this.record_id = record_id;
    }

    public int getUnread_num() {
        return unread_num;
    }

    public void setUnread_num(int unread_num) {
        this.unread_num = unread_num;
    }

    public List<ChatMsgEntity> getMsg_list() {
        return msg_list;
    }

    public void setMsg_list(List<ChatMsgEntity> msg_list) {
        this.msg_list = msg_list;
    }

    //语音消息时长，如果msg_type为voice时必传
    public String getVoice_long() {
        return voice_long;
    }

    public void setVoice_long(String voice_long) {
        this.voice_long = voice_long;
    }

    public int getMsg_state() {
        return msg_state;
    }

    public void setMsg_state(int msg_state) {
        this.msg_state = msg_state;
    }

    public ReadInfo getRead_info() {
        return read_info;
    }

    public void setRead_info(ReadInfo read_info) {
        this.read_info = read_info;
    }

    public List<String> getMsg_src() {
        return msg_src;
    }

    public void setMsg_src(List<String> msg_src) {
        this.msg_src = msg_src;
    }

    public String getMsg_id() {
        return msg_id;
    }

    public void setMsg_id(String msg_id) {
        this.msg_id = msg_id;
    }

    public String getMsg_text() {
        return msg_text;
    }

    public void setMsg_text(String msg_text) {
        this.msg_text = msg_text;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public String getHead_pic() {
        return head_pic;
    }

    public void setHead_pic(String head_pic) {
        this.head_pic = head_pic;
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

    public String getIs_out_member() {
        return is_out_member;
    }

    public void setIs_out_member(String is_out_member) {
        this.is_out_member = is_out_member;
    }

    public int getMsg_type_num() {
        return msg_type_num;
    }

    public void setMsg_type_num(int msg_type_num) {
        this.msg_type_num = msg_type_num;
    }

    public String getLocal_id() {
        return local_id;
    }

    public void setLocal_id(String local_id) {
        this.local_id = local_id;
    }

    public String getIs_readed() {
        return is_readed;
    }

    public void setIs_readed(String is_readed) {
        this.is_readed = is_readed;
    }

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getTeam_id() {
        return team_id;
    }

    public void setTeam_id(String team_id) {
        this.team_id = team_id;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
