package com.jizhi.jlongg.main.bean;

import org.litepal.annotation.Column;

import java.io.Serializable;
import java.util.List;

/**
 * 功能:找帮手
 * 时间:2016-4-14 11:07
 * 作者:xuj
 */
public class FindHelper extends BaseNetBean implements Serializable {
    /**
     * 搜索内容
     */
    private String title;
    private String realname;
    /**
     * 工龄
     */
    private String work_year;

    private String head_pic;
    private String work_name;

    private String  pid;
    /**
     * 头像
     */
    @Column(ignore = true)
    private String headpic;

    /**
     * 真实姓名
     */
    @Column(ignore = true)
    private String real_name;
    /**
     * 工种
     */
    @Column(ignore = true)
    private List<WorkType> work_type;
    /**
     * 好友个数
     */
    @Column(ignore = true)
    private int friendcount;
    /**
     * 用户id
     */
    @Column(ignore = true)
    private String uid;
    /**
     * 电话
     */
    @Column(ignore = true)
    private String telephone;
    /**
     * 是否认证 0：没有，1：认证了
     */
    @Column(ignore = true)
    private int verified;
    /**
     * 工人规模
     */
    @Column(ignore = true)
    private String scale;
    /**
     * 家乡
     */
    @Column(ignore = true)
    private String hometown;

    /**
     * 用户所在地
     */
    @Column(ignore = true)
    private String current_addr;
    private String role_type;

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getWork_name() {
        return work_name;
    }

    public void setWork_name(String work_name) {
        this.work_name = work_name;
    }

    public String getRole_type() {
        return role_type;
    }

    public void setRole_type(String role_type) {
        this.role_type = role_type;
    }

    public String getRealname() {
        return realname;
    }

    public void setRealname(String realname) {
        this.realname = realname;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getVerified() {
        return verified;
    }

    public void setVerified(int verified) {
        this.verified = verified;
    }

    public String getHeadpic() {
        return headpic;
    }

    public void setHeadpic(String headpic) {
        this.headpic = headpic;
    }

    public List<WorkType> getWork_type() {
        return work_type;
    }

    public void setWork_type(List<WorkType> work_type) {
        this.work_type = work_type;
    }

    public int getFriendcount() {
        return friendcount;
    }

    public void setFriendcount(int friendcount) {
        this.friendcount = friendcount;
    }

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

    public String getWork_year() {
        return work_year;
    }

    public void setWork_year(String work_year) {
        this.work_year = work_year;
    }

    public String getHometown() {
        return hometown;
    }

    public void setHometown(String hometown) {
        this.hometown = hometown;
    }

    public String getScale() {
        return scale;
    }

    public void setScale(String scale) {
        this.scale = scale;
    }

    public String getCurrent_addr() {
        return current_addr;
    }

    public void setCurrent_addr(String current_addr) {
        this.current_addr = current_addr;
    }

    public String getHead_pic() {
        return head_pic;
    }


    public void setHead_pic(String head_pic) {
        this.head_pic = head_pic;
    }
}
