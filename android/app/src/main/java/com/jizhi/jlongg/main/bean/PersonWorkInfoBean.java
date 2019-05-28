package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * CName:4.0.1个人名片信息类
 * User: hcs
 * Date: 2018-07-30
 * Time: 下午 3:39
 */
public class PersonWorkInfoBean implements Serializable {
    //聊天类型
    private String class_type;
    //项目编号
    private String group_id;
    //项目名字
    private String group_name;
    //用户uid
    private String uid;
    //1.跳转聊天 其他跳转加好友
    private int is_chat;
    //4.0.2增加字段,添加好友来源时，区分来源
    private String page;//connection 人脉 ,dynamic 工友圈, job 找活招工
    //名字
    private String real_name;
    //头像
    private String head_pic;
    //3已实名
    private String verified;
    //组认证
    private String group_verified;
    //个人认证
    private String person_verified;
    //名族
    private String nationality;
    //工龄
    private String work_year;
    //规模人数
    private String scale;
    //工头工种
    private WorkerInfo foreman_info;
    //工人工种
    private WorkerInfo worker_info;
//    //合并后的工种
//    private List<String> work_type;
    //1.显示名片 2.显示找工作信息
    private int click_type;
    //项目标题
    private String pro_title;
    //项目pid
    private String pid;
    //是否完善资料
    private int is_info;
    private int role_type;
    //简历跳转的聊天
    private int is_resume;
    /**
     * 工种信息
     */
    private WorkInfomation classes;

    public String getPage() {
        return page;
    }

    public void setPage(String page) {
        this.page = page;
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

    public String getVerified() {
        return verified;
    }

    public void setVerified(String verified) {
        this.verified = verified;
    }

    public String getGroup_verified() {
        return group_verified;
    }

    public void setGroup_verified(String group_verified) {
        this.group_verified = group_verified;
    }

    public String getPerson_verified() {
        return person_verified;
    }

    public void setPerson_verified(String person_verified) {
        this.person_verified = person_verified;
    }

    public String getNationality() {
        return nationality;
    }

    public void setNationality(String nationality) {
        this.nationality = nationality;
    }

    public String getWork_year() {
        return work_year;
    }

    public void setWork_year(String work_year) {
        this.work_year = work_year;
    }

    public String getScale() {
        return scale;
    }

    public void setScale(String scale) {
        this.scale = scale;
    }

    public WorkerInfo getForeman_info() {
        return foreman_info;
    }

    public void setForeman_info(WorkerInfo foreman_info) {
        this.foreman_info = foreman_info;
    }

    public WorkerInfo getWorker_info() {
        return worker_info;
    }

    public void setWorker_info(WorkerInfo worker_info) {
        this.worker_info = worker_info;
    }

//    public List<String> getWork_type() {
//        return work_type;
//    }
//
//    public void setWork_type(List<String> work_type) {
//        this.work_type = work_type;
//    }

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

    public String getGroup_name() {
        return group_name;
    }

    public void setGroup_name(String group_name) {
        this.group_name = group_name;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public int getIs_chat() {
        return is_chat;
    }

    public void setIs_chat(int is_chat) {
        this.is_chat = is_chat;
    }

    public int getClick_type() {
        return click_type;
    }

    public void setClick_type(int click_type) {
        this.click_type = click_type;
    }

    public String getPro_title() {
        return pro_title;
    }

    public void setPro_title(String pro_title) {
        this.pro_title = pro_title;
    }

    public WorkInfomation getClasses() {
        return classes;
    }

    public void setClasses(WorkInfomation classes) {
        this.classes = classes;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public int getIs_info() {
        return is_info;
    }

    public void setIs_info(int is_info) {
        this.is_info = is_info;
    }

    public int getRole_type() {
        return role_type;
    }

    public void setRole_type(int role_type) {
        this.role_type = role_type;
    }

    public int getIs_resume() {
        return is_resume;
    }

    public void setIs_resume(int is_resume) {
        this.is_resume = is_resume;
    }
}
