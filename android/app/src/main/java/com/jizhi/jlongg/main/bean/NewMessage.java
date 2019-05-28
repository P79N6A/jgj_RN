package com.jizhi.jlongg.main.bean;

import com.jizhi.jlongg.main.util.ProductUtil;

/**
 * 功能: 新消息实体
 * 作者：Xuj
 * 时间: 2016年8月26日 11:08:38
 */
public class NewMessage extends GroupDiscussionInfo {



    private String merge_last_msg_id;
    /* 标题 */
    private String title;
    /* 消息接收时间 */
    private String date;
    /* 执行人 */
    private String user_name;
    /* 合并后的名称 */
    private String merge_befor;
    /* 合并前的名称 */
    private String merge_after;
    /* 电话号码 */
    private String telphone;
    /* 是否能点击 */
    private String can_click;
    /* 同步对象的id */
    private String target_uid;
    /* 记账id,从这里创建和加入讨论组需要传*/
    private String bill_id;
    /* 拆分前的名称 */
    private String split_befor;
    /* 拆分后的名称 */
    private String split_after;
    /* 过期提示 */
    private String info;
    /* 1表示已支付  */
    private int isPay = ProductUtil.UN_PAID;
    /* 同步状态 */
    private int sync_state;


    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
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


    public String getMerge_befor() {
        return merge_befor;
    }

    public void setMerge_befor(String merge_befor) {
        this.merge_befor = merge_befor;
    }

    public String getMerge_after() {
        return merge_after;
    }

    public void setMerge_after(String merge_after) {
        this.merge_after = merge_after;
    }

    public String getTelphone() {
        return telphone;
    }

    public void setTelphone(String telphone) {
        this.telphone = telphone;
    }


    public String getCan_click() {
        return can_click;
    }

    public void setCan_click(String can_click) {
        this.can_click = can_click;
    }

    public String getTarget_uid() {
        return target_uid;
    }

    public void setTarget_uid(String target_uid) {
        this.target_uid = target_uid;
    }

    public String getBill_id() {
        return bill_id;
    }

    public void setBill_id(String bill_id) {
        this.bill_id = bill_id;
    }

    public String getSplit_befor() {
        return split_befor;
    }

    public void setSplit_befor(String split_befor) {
        this.split_befor = split_befor;
    }

    public String getSplit_after() {
        return split_after;
    }

    public void setSplit_after(String split_after) {
        this.split_after = split_after;
    }

    public int getIsPay() {
        return isPay;
    }

    public void setIsPay(int isPay) {
        this.isPay = isPay;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public String getMerge_last_msg_id() {
        return merge_last_msg_id;
    }

    public void setMerge_last_msg_id(String merge_last_msg_id) {
        this.merge_last_msg_id = merge_last_msg_id;
    }

    public int getSync_state() {
        return sync_state;
    }

    public void setSync_state(int sync_state) {
        this.sync_state = sync_state;
    }
}
