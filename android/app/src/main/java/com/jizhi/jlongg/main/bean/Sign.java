package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * CName:签到信息
 * User: hcs
 * Date: 2016-09-29
 * Time: 15:03
 */
public class Sign implements Serializable {
    private int is_creater;
    private String s_date;
    private String today_sign_record_num;
    private String today_sign_member_num;
    private List<Sign> list;
    private String sign_date;
    private String sign_num;
    private List<Sign> sign_list;
    private String real_name;
    private String head_pic;
    private String telphone;
    private String sign_addr;
    private String sign_addr2;
    private String sign_desc;
    private String sign_voice;
    private String sign_time;
    private Sign myuserinfo;
    private Sign userinfo;
    private String mber_id;
    private String sign_id;
    private String sign_voice_time;
    private List<String> sign_pic;
    private int is_today;
    private String group_name;
    private String team_comment;
    private String members_num;
    private String uid;
    private int had_sign;
    private String coordinate;
    private String group_user_name;

    public String getGroup_user_name() {
        return group_user_name;
    }

    public void setGroup_user_name(String group_user_name) {
        this.group_user_name = group_user_name;
    }

    public String getCoordinate() {
        return coordinate;
    }

    public void setCoordinate(String coordinate) {
        this.coordinate = coordinate;
    }
    public int getHad_sign() {
        return had_sign;
    }

    public void setHad_sign(int had_sign) {
        this.had_sign = had_sign;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getGroup_name() {
        return group_name;
    }

    public void setGroup_name(String group_name) {
        this.group_name = group_name;
    }

    public String getMembers_num() {
        return members_num;
    }

    public void setMembers_num(String members_num) {
        this.members_num = members_num;
    }

    public String getTeam_comment() {
        return team_comment;
    }

    public void setTeam_comment(String team_comment) {
        this.team_comment = team_comment;
    }

    public int getIs_today() {
        return is_today;
    }

    public void setIs_today(int is_today) {
        this.is_today = is_today;
    }

    public String getSign_id() {
        return sign_id;
    }

    public void setSign_id(String sign_id) {
        this.sign_id = sign_id;
    }

    public Sign getUserinfo() {
        return userinfo;
    }

    public void setUserinfo(Sign userinfo) {
        this.userinfo = userinfo;
    }

    public String getMber_id() {
        return mber_id;
    }

    public void setMber_id(String mber_id) {
        this.mber_id = mber_id;
    }

    public int getIs_creater() {
        return is_creater;
    }

    public void setIs_creater(int is_creater) {
        this.is_creater = is_creater;
    }

    public String getS_date() {
        return s_date;
    }

    public void setS_date(String s_date) {
        this.s_date = s_date;
    }

    public String getToday_sign_record_num() {
        return today_sign_record_num;
    }

    public void setToday_sign_record_num(String today_sign_record_num) {
        this.today_sign_record_num = today_sign_record_num;
    }

    public String getToday_sign_member_num() {
        return today_sign_member_num;
    }

    public void setToday_sign_member_num(String today_sign_member_num) {
        this.today_sign_member_num = today_sign_member_num;
    }

    public List<Sign> getList() {
        return list;
    }

    public void setList(List<Sign> list) {
        this.list = list;
    }

    public String getSign_date() {
        return sign_date;
    }

    public void setSign_date(String sign_date) {
        this.sign_date = sign_date;
    }

    public String getSign_num() {
        return sign_num;
    }

    public void setSign_num(String sign_num) {
        this.sign_num = sign_num;
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

    public String getTelphone() {
        return telphone;
    }

    public void setTelphone(String telphone) {
        this.telphone = telphone;
    }

    public String getSign_addr() {
        return sign_addr;
    }

    public void setSign_addr(String sign_addr) {
        this.sign_addr = sign_addr;
    }

    public String getSign_time() {
        return sign_time;
    }

    public void setSign_time(String sign_time) {
        this.sign_time = sign_time;
    }

    public List<Sign> getSign_list() {
        return sign_list;
    }

    public void setSign_list(List<Sign> sign_list) {
        this.sign_list = sign_list;
    }

    public Sign getMyuserinfo() {
        return myuserinfo;
    }

    public void setMyuserinfo(Sign myuserinfo) {
        this.myuserinfo = myuserinfo;
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

    public List<String> getSign_pic() {
        return sign_pic;
    }

    public void setSign_pic(List<String> sign_pic) {
        this.sign_pic = sign_pic;
    }
}
