package com.jizhi.jlongg.main.message;

import com.jizhi.jlongg.main.activity.WebSocketBaseParameter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;

import java.io.Serializable;
import java.util.List;

/**
 * 功能: WebSocket基础参数
 * 作者：Xuj
 * 时间: 2016年8月27日 17:03:14
 */
public class WebSocketMeassgeParameter extends WebSocketBaseParameter implements Serializable {

    public WebSocketMeassgeParameter() {
    }

    /**
     * 值noticeList
     */
//    private String action;
    /**
     * 签名字符串
     */
//    private String sign;
    //消息类型 text文本消息,voice语音消息，notice通知,log 日志,signIn 签到,safe 安全,quality 质量
    private String msg_type;
    //类别，group为班组，team为讨论组
    private String class_type;
    //如果class_type为group
    private String group_id;
    //则传group_id,为team则传team_id
    private String team_id;
    //语音消息可不传，其他必传
    private String msg_text;
    //语音或者图片地址 "msg_src":['notice1.png','notice2.png',] 或 "msg_src":['notice1.mp3']
    private List<String> msg_src;
    //消息发送时间,如果不传则取服务器接收数据时间
    private String send_time;
    //本地消息id
    private String local_id;
    //本地最后一条msg_id，如果是0表示从第一条开始获取
    private String last_msg_id;
    //每次返回的条数，如果不传默认10条
    private String size;
    //成员
    private String rec_uid;
    private String voice_long;

    private String msg_id;
    //pre向上翻页，next向下翻页
    private String pageturn;
    //记账id
    private String bill_id;
    //签到地址
    private String sign_addr;
    //签到地址第二行
    private String sign_addr2;
    //签到备注
    private String sign_desc;
    //语音
    private String sign_voice;
    //语间长度
    private String sign_voice_time;
    //图片,多张使用逗号隔开
    private String sign_pic;
    private String mber_id;
    private String sign_id;
    private String s_date;
    private String type;
    public String msg_info;
    private String at_uid;
    private List<String> pic_w_h;
    private String uid;
    //经度
    private String coordinate;
    //回复内容
    private String reply_text;
    private String reply_type;
    private String weat_am;//上午天气
    private String weat_pm;//下午天气
    private String wind_am;//上午风力
    private String wind_pm;//下午风力
    private String temp_am;//上午温度
    private String temp_pm;//下午温度
    private String techno_quali_log;//技术质量工作记录

    public String getReply_text() {
        return reply_text;
    }

    private String is_rectification;//	是否整改（1：整改；0：不需要），
    private String severity;//隐患级别（1：一般,2:严重）
    private String location;//位置
    private String principal_uid;//负责人（与字段is_rectification连用），
    private String finish_time;//完成时间（如果：20160909）
    private String statu;//1:待整改；2：待复查；3：已完结

    public String getWeat_am() {
        return weat_am;
    }

    private String location_id;//如果取原来的位置，
    private String pg;
    private String pagesize;
    private String pu_inpsid;
    private String insp_id;//

    public String is_find_job;
    public GroupDiscussionInfo msg_prodetail;
    private String msg_sender;
    //简历跳转的聊天
    private String is_resume;
    public String getIs_resume() {
        return is_resume;
    }

    public void setIs_resume(String is_resume) {
        this.is_resume = is_resume;
    }

    private int is_source;
    /**
     * 名片，工作信息等其他扩展消息json字符串
     */
    private String msg_text_other;

    public String getMsg_info() {
        return msg_info;
    }

    public void setMsg_info(String msg_info) {
        this.msg_info = msg_info;
    }

    public String getRec_uid() {
        return rec_uid;
    }

    public void setRec_uid(String rec_uid) {
        this.rec_uid = rec_uid;
    }

    public String getInsp_id() {
        return insp_id;
    }

    public void setInsp_id(String insp_id) {
        this.insp_id = insp_id;
    }

    public String getPu_inpsid() {
        return pu_inpsid;
    }

    public void setPu_inpsid(String pu_inpsid) {
        this.pu_inpsid = pu_inpsid;
    }

    public String getPg() {
        return pg;
    }

    public void setPg(String pg) {
        this.pg = pg;
    }

    public String getPagesize() {
        return pagesize;
    }

    public void setPagesize(String pagesize) {
        this.pagesize = pagesize;
    }

    public String getReply_type() {
        return reply_type;
    }

    public void setReply_type(String reply_type) {
        this.reply_type = reply_type;
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

    public void setReply_text(String reply_text) {
        this.reply_text = reply_text;
    }

    public String getCoordinate() {
        return coordinate;
    }

    public void setCoordinate(String coordinate) {
        this.coordinate = coordinate;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public List<String> getPic_w_h() {
        return pic_w_h;
    }

    public void setPic_w_h(List<String> pic_w_h) {
        this.pic_w_h = pic_w_h;
    }

    public String getAt_uid() {
        return at_uid;
    }

    public void setAt_uid(String at_uid) {
        this.at_uid = at_uid;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }


    //    private String sign;
//
//    public String getSign() {
//        return sign;
//    }
//
//    public void setSign(String sign) {
//        this.sign = sign;
//    }

    public String getS_date() {
        return s_date;
    }

    public void setS_date(String s_date) {
        this.s_date = s_date;
    }

    public String getSign_id() {
        return sign_id;
    }

    public void setSign_id(String sign_id) {
        this.sign_id = sign_id;
    }

    public String getMber_id() {
        return mber_id;
    }

    public void setMber_id(String mber_id) {
        this.mber_id = mber_id;
    }

    public String getBill_id() {
        return bill_id;
    }

    public void setBill_id(String bill_id) {
        this.bill_id = bill_id;
    }

    public String getPageturn() {
        return pageturn;
    }

    public void setPageturn(String pageturn) {
        this.pageturn = pageturn;
    }

    public String getMsg_id() {
        return msg_id;
    }

    public void setMsg_id(String msg_id) {
        this.msg_id = msg_id;
    }

    public String getVoice_long() {
        return voice_long;
    }

    public void setVoice_long(String voice_long) {
        this.voice_long = voice_long;
    }

    public String getLast_msg_id() {
        return last_msg_id;
    }

    public void setLast_msg_id(String last_msg_id) {
        this.last_msg_id = last_msg_id;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
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

    public String getMsg_text() {
        return msg_text;
    }

    public void setMsg_text(String msg_text) {
        this.msg_text = msg_text;
    }

    public List<String> getMsg_src() {
        return msg_src;
    }

    public void setMsg_src(List<String> msg_src) {
        this.msg_src = msg_src;
    }

    public String getSend_time() {
        return send_time;
    }

    public void setSend_time(String send_time) {
        this.send_time = send_time;
    }

    public String getLocal_id() {
        return local_id;
    }

    public void setLocal_id(String local_id) {
        this.local_id = local_id;
    }

    public String getMsg_type() {
        return msg_type;
    }

    public String getSign_addr() {
        return sign_addr;
    }

    public void setSign_addr(String sign_addr) {
        this.sign_addr = sign_addr;
    }

    public String getSign_addr2() {
        return sign_addr2;
    }

    public void setSign_addr2(String sign_addr2) {
        this.sign_addr2 = sign_addr2;
    }

    public String getSign_desc() {
        return sign_desc;
    }

    public void setSign_desc(String sign_desc) {
        this.sign_desc = sign_desc;
    }

    public String getSign_voice() {
        return sign_voice;
    }

    public void setSign_voice(String sign_voice) {
        this.sign_voice = sign_voice;
    }

    public String getSign_voice_time() {
        return sign_voice_time;
    }

    public void setSign_voice_time(String sign_voice_time) {
        this.sign_voice_time = sign_voice_time;
    }

    public String getSign_pic() {
        return sign_pic;
    }

    public void setSign_pic(String sign_pic) {
        this.sign_pic = sign_pic;
    }

    public String getIs_find_job() {
        return is_find_job;
    }

    public void setIs_find_job(String is_find_job) {
        this.is_find_job = is_find_job;
    }

    public String getMsg_sender() {
        return msg_sender;
    }

    public void setMsg_sender(String msg_sender) {
        this.msg_sender = msg_sender;
    }

    public GroupDiscussionInfo getMsg_prodetail() {
        return msg_prodetail;
    }

    public void setMsg_prodetail(GroupDiscussionInfo msg_prodetail) {
        this.msg_prodetail = msg_prodetail;
    }

    public String getMsg_text_other() {
        return msg_text_other;
    }

    public void setMsg_text_other(String msg_text_other) {
        this.msg_text_other = msg_text_other;
    }

    public int getIs_source() {
        return is_source;
    }

    public void setIs_source(int is_source) {
        this.is_source = is_source;
    }
}
