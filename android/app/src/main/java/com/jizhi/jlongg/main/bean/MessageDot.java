package com.jizhi.jlongg.main.bean;

import org.litepal.crud.LitePalSupport;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Administrator on 2016/12/19 0019.
 */

public class MessageDot extends LitePalSupport implements Serializable {
    private int notice;
    private int log;
    private int safe;
    private int quality;
    private int badge;
    private int sign;
    private String allnum;//总条数
    private List<MessageEntity> msg_list;
    private String msg_type;
    private String s_date;
    private List<LogGroupBean> list;

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

    public int getBadge() {
        return badge;
    }

    public void setBadge(int badge) {
        this.badge = badge;
    }

    public int getSign() {
        return sign;
    }

    public void setSign(int sign) {
        this.sign = sign;
    }

    public String getAllnum() {
        return allnum;
    }

    public void setAllnum(String allnum) {
        this.allnum = allnum;
    }

    public List<MessageEntity> getMsg_list() {
        return msg_list;
    }

    public void setMsg_list(List<MessageEntity> msg_list) {
        this.msg_list = msg_list;
    }

    public String getMsg_type() {
        return msg_type;
    }

    public void setMsg_type(String msg_type) {
        this.msg_type = msg_type;
    }

    public String getS_date() {
        return s_date;
    }

    public void setS_date(String s_date) {
        this.s_date = s_date;
    }

    public List<LogGroupBean> getList() {
        return list;
    }

    public void setList(List<LogGroupBean> list) {
        this.list = list;
    }
}
