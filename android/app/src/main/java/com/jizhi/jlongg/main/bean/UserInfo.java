package com.jizhi.jlongg.main.bean;

import com.google.gson.annotations.Expose;

import org.litepal.annotation.Column;

import java.io.Serializable;

/**
 * 用户基础信息
 */
public class UserInfo implements Serializable {


    //使用 new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();创建Gson对象，没有@Expose注释的属性将不会被序列化
    /**
     * 用户id
     */
    @Expose
    public String uid;
    /**
     * 电话号码
     */
    @Expose
    private String telephone;
    /**
     * 备注或者昵称
     */
    @Expose
    private String real_name;
    /**
     * 真实姓名
     */
    @Expose
    private String full_name;
    /**
     * 用户头像
     */
    private String head_pic;
    /**
     * 1表示已注册
     */
    @Column(ignore = true)
    private int is_register;
    /**
     * 首字母缩写
     */
    @Column(ignore = true)
    private String sortLetters;
    /**
     * 字母全拼
     * 比如name是徐杰 则是 xj
     */
    @Column(ignore = true)
    private String pinYin;
    /**
     * 个性签名内容
     */
    @Column(ignore = true)
    private String signature;
    /**
     * 评价内容
     */
    private String comment;
    /**
     * 是否已发送好友申请
     */
    @Column(ignore = true)
    private boolean isSendAddFriend;
    /**
     * 3已实名
     */
    private int verified;
    /**
     * 认证类型,0为都未认证,1为已工人认证,2为班组认证
     */
    private int auth_type;


    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
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

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }


    public int getIs_register() {
        return is_register;
    }

    public void setIs_register(int is_register) {
        this.is_register = is_register;
    }

    public String getSortLetters() {
        return sortLetters;
    }

    public void setSortLetters(String sortLetters) {
        this.sortLetters = sortLetters;
    }

    public String getSignature() {
        return signature;
    }

    public void setSignature(String signature) {
        this.signature = signature;
    }

    public boolean isSendAddFriend() {
        return isSendAddFriend;
    }

    public void setSendAddFriend(boolean sendAddFriend) {
        isSendAddFriend = sendAddFriend;
    }

    public java.lang.String getFull_name() {
        return full_name;
    }

    public void setFull_name(java.lang.String full_name) {
        this.full_name = full_name;
    }

    public int getVerified() {
        return verified;
    }

    public void setVerified(int verified) {
        this.verified = verified;
    }

    public int getAuth_type() {
        return auth_type;
    }

    public void setAuth_type(int auth_type) {
        this.auth_type = auth_type;
    }

    public String getPinYin() {
        return pinYin;
    }

    public void setPinYin(String pinYin) {
        this.pinYin = pinYin;
    }
}
