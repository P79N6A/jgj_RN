package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * 功能: 项目Banner
 * 作者：xuj
 * 时间: 2016-8-22 14:48
 */
public class Banner {
    /* 图片路径 */
    private String img_path;
    /* 	链接类型 : aap内部地址 "app",html地址 "html",直接返回广告对应内容 "api",无效果"none" */
    private String link_type;
    /* 直接返回值 */
    private String link_api;
    /* 	链接对应 地址 */
    private String link_key;

    private String ad_type;

    private List<Banner> list;

    private List<Float> ad_size;

    private String aid;//广告ID
    private String pid;//广告位ID

    public String getAid() {
        return aid;
    }

    public void setAid(String aid) {
        this.aid = aid;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public List<Banner> getList() {
        return list;
    }

    public void setList(List<Banner> list) {
        this.list = list;
    }

    public String getAd_type() {
        return ad_type;
    }

    public void setAd_type(String ad_type) {
        this.ad_type = ad_type;
    }

    public String getImg_path() {
        return img_path;
    }

    public void setImg_path(String img_path) {
        this.img_path = img_path;
    }

    public Banner(String img_path) {
        this.img_path = img_path;
    }

    public String getLink_type() {
        return link_type;
    }

    public void setLink_type(String link_type) {
        this.link_type = link_type;
    }

    public String getLink_api() {
        return link_api;
    }

    public void setLink_api(String link_api) {
        this.link_api = link_api;
    }

    public String getLink_key() {
        return link_key;
    }

    public void setLink_key(String link_key) {
        this.link_key = link_key;
    }

    public List<Float> getAd_size() {
        return ad_size;
    }

    public void setAd_size(List<Float> ad_size) {
        this.ad_size = ad_size;
    }
}
