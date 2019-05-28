package com.jizhi.jlongg.main.bean;

import org.json.JSONArray;
import org.litepal.annotation.Column;
import org.litepal.crud.LitePalSupport;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 消息信息
 */
public class MessageEntity extends LitePalSupport implements Serializable {
    /*消息id*/
    private int msg_id = 0;
    /*消息类型 group,team*/
    private String class_type;
    /*组id*/
    private String group_id;
    /*用户名字*/
    private String user_name;
    /*用户真实名字*/
    private String full_name;
    /*消息内容*/
    private String msg_text;
    /*消息类型 text,voice,pic等*/
    private String msg_type;
    /*消息类型 编号*/
    private int msg_type_num;
    /*消息发送时间戳*/
    private String local_id;
    /*消息发送时间*/
    private String send_date;
    /*消息状态 1已读  0未读*/
    private String is_readed;
    /*本地消息状态 1已读  0未读*/
    private String is_readed_local = "0";
    private String is_out_member;
    /*头像地址 */
    private String head_pic;
    /*时间 */
    private String date;
    /*消息读取信息 */
    private String team_id;
    private List<String> msg_src = new ArrayList<>();
    //消息状态 0。成功  1.失败  2.发送中
    private int msg_state;
    /*此条消息归属uid */
    private String uid;
    /*语音长度 */
    private String voice_long;
    /*消息归属项目组 */
    private String from_group_name;
    /*消息未读数量 */
    private int unread_user_num;
    /*其他消息列表，日志通知等 */
    private List<ChatMsgEntity> list;
    /*消息已读未读信 */
    private ReadInfo read_info;
    /*当前用户手机号码 */
    private String mobile_phone;
    /*昵称*/
    private String real_name;
    /*特殊消息类型保存的json对象*/
    private String msg_prodetails;
    private JSONArray contentArray;
    /* 找工作内容 */
    @Column(ignore = true)
    private ProjectBase prodetailactive;
    /* 找帮手内容 */
    @Column(ignore = true)
    private FindHelper searchuser;
    @Column(ignore = true)
    private String record_id;
    @Column(ignore = true)
    private String bill_id;
    @Column(ignore = true)
    private String accounts_type;
    @Column(ignore = true)
    private String send_time;
    @Column(ignore = true)
    private String msg_sender;
    @Column(ignore = true)
    private String fmt_date;
    @Column(ignore = true)
    private String proName;
    @Column(ignore = true)
    private String groupName;
    private String path;
    private List<String> pic_w_h;
    @Column(ignore = true)
    private String s_date;
    @Column(ignore = true)
    private String status;
    @Column(ignore = true)
    private String sign_id;
    @Column(ignore = true)
    private String is_find_job;
    @Column(ignore = true)
    public GroupDiscussionInfo msg_prodetail;
    @Column(ignore = true)
    private boolean isPlaying;//是否正在播放
    @Column(ignore = true)
    private boolean isSendingPic;//图片是否正在发送中
    @Column(ignore = true)
    private String weat_am;//上午天气
    @Column(ignore = true)
    private String weat_pm;//下午天气
    @Column(ignore = true)
    private String wind_am;//上午风力
    @Column(ignore = true)
    private String wind_pm;//下午风力
    @Column(ignore = true)
    private String temp_am;//上午温度
    @Column(ignore = true)
    private String temp_pm;//下午温度
    @Column(ignore = true)
    private String techno_quali_log;//技术质量工作记录
    @Column(ignore = true)
    private String is_rectification;//	是否整改（1：整改；0：不需要），
    @Column(ignore = true)
    private String severity;//隐患级别（1：一般,2:严重）
    @Column(ignore = true)
    private String location;//位置
    @Column(ignore = true)
    private String principal_uid;//负责人（与字段is_rectification连用），
    @Column(ignore = true)
    private String finish_time;//完成时间（如果：20160909）
    @Column(ignore = true)
    private String statu;//1:待整改；2：待复查；3：已完结
    @Column(ignore = true)
    private String location_id;//如果取原来的位置，
    @Column(ignore = true)
    private String statu_text;////整改状态文本
    @Column(ignore = true)
    private String severity_text;//严重性文本
    @Column(ignore = true)
    private String update_time;//修改时间
    @Column(ignore = true)
    private String create_time;//创建时间
    @Column(ignore = true)
    private String principal_name;//整改负责人
    @Column(ignore = true)
    private List<ReplyInfo> reply_list;
    @Column(ignore = true)
    private int is_creater;
    @Column(ignore = true)
    private int is_admin;
    @Column(ignore = true)
    private String reply_text;
    ///1：待整改的问题，整改完成期限-当前日期<0天；2：待整改的问题，0<=整改完成期限-当前日期<3天时；3：待整改的问题，0<=整改完成期限-当前日期>=3天时
    @Column(ignore = true)
    private int finish_time_status;
    @Column(ignore = true)
    private UserInfo user_info;//执行者;
    @Column(ignore = true)
    private int show_bell;//执行者;// 1：红灯；2：黄灯；3：绿灯
    @Column(ignore = true)
    private String msg_steps;//整改措施
    @Column(ignore = true)
    private String rec_uid;//执行人
    @Column(ignore = true)
    private boolean isAutoPlay;//是否自动播放

    public boolean isAutoPlay() {
        return isAutoPlay;
    }

    public void setAutoPlay(boolean autoPlay) {
        isAutoPlay = autoPlay;
    }

    public String getRec_uid() {
        return rec_uid;
    }

    public void setRec_uid(String rec_uid) {
        this.rec_uid = rec_uid;
    }

//
//    public JSONArray getContentArray() {
//        return contentArray;
//    }
//
//    public void setContentArray(JSONArray contentArray) {
//        this.contentArray = contentArray;
//    }

    public int getShow_bell() {
        return show_bell;
    }

    public void setShow_bell(int show_bell) {
        this.show_bell = show_bell;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public int getFinish_time_status() {
        return finish_time_status;
    }

    public void setFinish_time_status(int finish_time_status) {
        this.finish_time_status = finish_time_status;
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

    public int getIs_creater() {
        return is_creater;
    }

    public void setIs_creater(int is_creater) {
        this.is_creater = is_creater;
    }

    public int getIs_admin() {
        return is_admin;
    }

    public void setIs_admin(int is_admin) {
        this.is_admin = is_admin;
    }

    public List<ReplyInfo> getReply_list() {
        return reply_list;
    }

    public void setReply_list(List<ReplyInfo> reply_list) {
        this.reply_list = reply_list;
    }

    public String getPrincipal_name() {
        return principal_name;
    }

    public void setPrincipal_name(String principal_name) {
        this.principal_name = principal_name;
    }

    public String getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(String update_time) {
        this.update_time = update_time;
    }

    public String getStatu_text() {
        return statu_text;
    }

    public void setStatu_text(String statu_text) {
        this.statu_text = statu_text;
    }

    public String getSeverity_text() {
        return severity_text;
    }

    public void setSeverity_text(String severity_text) {
        this.severity_text = severity_text;
    }

    public String getLocation_id() {
        return location_id;
    }

    public void setLocation_id(String location_id) {
        this.location_id = location_id;
    }

    public String getIs_rectification() {
        return is_rectification;
    }

    public void setIs_rectification(String is_rectification) {
        this.is_rectification = is_rectification;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getPrincipal_uid() {
        return principal_uid;
    }

    public void setPrincipal_uid(String principal_uid) {
        this.principal_uid = principal_uid;
    }

    public String getFinish_time() {
        return finish_time;
    }

    public void setFinish_time(String finish_time) {
        this.finish_time = finish_time;
    }

    public String getStatu() {
        return statu;
    }

    public void setStatu(String statu) {
        this.statu = statu;
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

    public boolean isSendingPic() {
        return isSendingPic;
    }

    public void setSendingPic(boolean sendingPic) {
        isSendingPic = sendingPic;
    }

    public String getIs_readed_local() {
        return is_readed_local;
    }

    public void setIs_readed_local(String is_readed_local) {
        this.is_readed_local = is_readed_local;
    }

    public boolean isPlaying() {
        return isPlaying;
    }

    public void setPlaying(boolean playing) {
        isPlaying = playing;
    }

    public String getMsg_prodetails() {
        return msg_prodetails;
    }

    public void setMsg_prodetails(String msg_prodetails) {
        this.msg_prodetails = msg_prodetails;
    }

    public GroupDiscussionInfo getMsg_prodetail() {
        return msg_prodetail;
    }

    public void setMsg_prodetail(GroupDiscussionInfo msg_prodetail) {
        this.msg_prodetail = msg_prodetail;
    }

    public ProjectBase getProdetailactive() {
        return prodetailactive;
    }

    public String getIs_find_job() {
        return is_find_job;
    }

    public void setIs_find_job(String is_find_job) {
        this.is_find_job = is_find_job;
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

    public String getSign_id() {
        return sign_id;
    }

    public void setSign_id(String sign_id) {
        this.sign_id = sign_id;
    }

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }

    public String getMobile_phone() {
        return mobile_phone;
    }

    public void setMobile_phone(String mobile_phone) {
        this.mobile_phone = mobile_phone;
    }

    public ReadInfo getRead_info() {
        return read_info;
    }

    public void setRead_info(ReadInfo read_info) {
        this.read_info = read_info;
    }

    public List<ChatMsgEntity> getList() {
        return list;
    }

    public void setList(List<ChatMsgEntity> list) {
        this.list = list;
    }

    public int getMsg_id() {
        return msg_id;
    }

    public void setMsg_id(int msg_id) {
        this.msg_id = msg_id;
    }

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public String getMsg_text() {
        return msg_text;
    }

    public void setMsg_text(String msg_text) {
        this.msg_text = msg_text;
    }

    public String getMsg_type() {
        return msg_type;
    }

    public void setMsg_type(String msg_type) {
        this.msg_type = msg_type;
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

    public String getSend_date() {
        return send_date;
    }

    public void setSend_date(String send_date) {
        this.send_date = send_date;
    }

    public String getIs_readed() {
        return is_readed;
    }

    public void setIs_readed(String is_readed) {
        this.is_readed = is_readed;
    }

    public String getIs_out_member() {
        return is_out_member;
    }

    public void setIs_out_member(String is_out_member) {
        this.is_out_member = is_out_member;
    }

    public String getHead_pic() {
        return head_pic;
    }

    public void setHead_pic(String head_pic) {
        this.head_pic = head_pic;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTeam_id() {
        return team_id;
    }

    public void setTeam_id(String team_id) {
        this.team_id = team_id;
    }

    public List<String> getMsg_src() {
        return msg_src;
    }

    public void setMsg_src(List<String> msg_src) {
        this.msg_src = msg_src;
    }

    public int getMsg_state() {
        return msg_state;
    }

    public void setMsg_state(int msg_state) {
        this.msg_state = msg_state;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getVoice_long() {
        return voice_long;
    }

    public void setVoice_long(String voice_long) {
        this.voice_long = voice_long;
    }

    public String getFrom_group_name() {
        return from_group_name;
    }

    public void setFrom_group_name(String from_group_name) {
        this.from_group_name = from_group_name;
    }

    public int getUnread_user_num() {
        return unread_user_num;
    }

    public void setUnread_user_num(int unread_user_num) {
        this.unread_user_num = unread_user_num;
    }

    public String getRecord_id() {
        return record_id;
    }

    public void setRecord_id(String record_id) {
        this.record_id = record_id;
    }


    public String getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(String accounts_type) {
        this.accounts_type = accounts_type;
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

    public String getFmt_date() {
        return fmt_date;
    }

    public void setFmt_date(String fmt_date) {
        this.fmt_date = fmt_date;
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

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public List<String> getPic_w_h() {
        return pic_w_h;
    }

    public void setPic_w_h(List<String> pic_w_h) {
        this.pic_w_h = pic_w_h;
    }

    public String getS_date() {
        return s_date;
    }

    public void setS_date(String s_date) {
        this.s_date = s_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMsg_steps() {
        return msg_steps;
    }

    public void setMsg_steps(String msg_steps) {
        this.msg_steps = msg_steps;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public String getBill_id() {
        return bill_id;
    }

    public void setBill_id(String bill_id) {
        this.bill_id = bill_id;
    }
}

