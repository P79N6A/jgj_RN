package com.jizhi.jlongg.main.bean;

import org.litepal.annotation.Column;
import org.litepal.crud.LitePalSupport;

import java.io.Serializable;
import java.util.List;

/**
 * 功能:项目基础数据
 * 时间:2016-4-19 13:03
 * 作者:xuj
 */
public class ProjectBase extends LitePalSupport implements Serializable{
    /**
     * 项目标题
     */
    private String pro_title;
    /**
     * 工种信息
     */
    private WorkInfomation classes;
    /**
     * 总面积
     */
    private String pro_totalarea;
    /**
     * 项目id
     */
    private int pid;
    /**
     * 角色
     */
    private int role_type;
    /**
     * 好友数量
     */
    @Column(ignore = true)
    private int sharefriendnum;
    /**
     * 工头名称
     */
    @Column(ignore = true)
    private String fmname;
    /**
     * 项目描述
     */
    @Column(ignore = true)
    private String pro_description;
    /**
     * 项目地址
     */
    @Column(ignore = true)
    private String pro_address;
    /**
     * 区域名称
     */
    @Column(ignore = true)
    private String regionname;
    /**
     * 0、已招满 1、未招满
     */
    @Column(ignore = true)
    private int is_full;
    /**
     * 是否需要垫资
     */
    @Column(ignore = true)
    private int prepay;
    /**
     * 项目标题
     */
    @Column(ignore = true)
    private String protitle;
    /**
     * 项目名称
     */
    @Column(ignore = true)
    private String proname;
    /**
     * 发布人电话
     */
    @Column(ignore = true)
    private PersonInfo[] contact_info;
    /**
     * 分享内容
     */
    @Column(ignore = true)
    private Share share;
    /**
     * 浏览次数
     */
    @Column(ignore = true)
    private int review_cnt;
    /**
     * 好友列表
     */
    @Column(ignore = true)
    private List<FriendBean> friend_result;
    /**
     * 地址
     */
    @Column(ignore = true)
    private String proaddress;
    /**
     * 福利
     */
    @Column(ignore = true)
    private List<Welfare> welfare;
    /**
     * 地址坐标
     * 1.纬度
     * 2.经度
     */
    @Column(ignore = true)
    private double[] pro_location;
    /**
     * 项目创建描述
     * 如1天前发布
     */
    @Column(ignore = true)
    private String create_time_txt;

    @Column(ignore = true)
    private int find_role;


    public int getFind_role() {
        return find_role;
    }

    public void setFind_role(int find_role) {
        this.find_role = find_role;
    }

    public int getIs_full() {
        return is_full;
    }

    public void setIs_full(int is_full) {
        this.is_full = is_full;
    }


    public String getRegionname() {
        return regionname;
    }

    public void setRegionname(String regionname) {
        this.regionname = regionname;
    }


    public String getPro_address() {
        return pro_address;
    }

    public void setPro_address(String pro_address) {
        this.pro_address = pro_address;
    }

    public String getPro_title() {
        return pro_title;
    }

    public void setPro_title(String pro_title) {
        this.pro_title = pro_title;
    }


    public String getPro_totalarea() {
        return pro_totalarea;
    }

    public void setPro_totalarea(String pro_totalarea) {
        this.pro_totalarea = pro_totalarea;
    }


    public int getSharefriendnum() {
        return sharefriendnum;
    }

    public void setSharefriendnum(int sharefriendnum) {
        this.sharefriendnum = sharefriendnum;
    }

    public String getPro_description() {
        return pro_description;
    }

    public void setPro_description(String pro_description) {
        this.pro_description = pro_description;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public int getPrepay() {
        return prepay;
    }

    public void setPrepay(int prepay) {
        this.prepay = prepay;
    }


    public String getProtitle() {
        return protitle;
    }

    public void setProtitle(String protitle) {
        this.protitle = protitle;
    }


    public String getProname() {
        return proname;
    }

    public void setProname(String proname) {
        this.proname = proname;
    }

    public String getFmname() {
        return fmname;
    }

    public void setFmname(String fmname) {
        this.fmname = fmname;
    }

    public PersonInfo[] getContact_info() {
        return contact_info;
    }

    public void setContact_info(PersonInfo[] contact_info) {
        this.contact_info = contact_info;
    }

    public WorkInfomation getClasses() {
        return classes;
    }

    public void setClasses(WorkInfomation classes) {
        this.classes = classes;
    }


    public String getCreate_time_txt() {
        return create_time_txt;
    }

    public void setCreate_time_txt(String create_time_txt) {
        this.create_time_txt = create_time_txt;
    }


    public Share getShare() {
        return share;
    }

    public void setShare(Share share) {
        this.share = share;
    }

    public int getReview_cnt() {
        return review_cnt;
    }

    public void setReview_cnt(int review_cnt) {
        this.review_cnt = review_cnt;
    }

    public String getProaddress() {
        return proaddress;
    }

    public void setProaddress(String proaddress) {
        this.proaddress = proaddress;
    }


    public double[] getPro_location() {
        return pro_location;
    }

    public void setPro_location(double[] pro_location) {
        this.pro_location = pro_location;
    }


    public List<Welfare> getWelfare() {
        return welfare;
    }

    public void setWelfare(List<Welfare> welfare) {
        this.welfare = welfare;
    }

    public List<FriendBean> getFriend_result() {
        return friend_result;
    }

    public void setFriend_result(List<FriendBean> friend_result) {
        this.friend_result = friend_result;
    }
}
