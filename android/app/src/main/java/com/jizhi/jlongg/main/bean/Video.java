package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * Created by Administrator on 2018-3-23.
 */

public class Video {
    /**
     * 视频缩略图 ..搞不懂为什么返回数据 取下标 第一个就行了
     */
    private List<String> pic_src;
    /**
     * 视频地址
     */
    private String video_url;
    /**
     * 视频时长,后台返回的秒
     */
    private long video_time;
    /**
     * 评论数
     */
    private String cms_content;
    /**
     * 视频id
     */
    private int video_id;
    /**
     * 所属的帖子id
     */
    private int id;
    /**
     * 点赞数
     */
    private int like_num;
    /**
     * 评论数
     */
    private int comment_num;
    /**
     * 上传的用户信息
     */
    private UserInfo user_info;
    /**
     * 1表示点赞,0未点赞
     */
    private int is_liked;



    public String getVideo_url() {
        return video_url;
    }

    public void setVideo_url(String video_url) {
        this.video_url = video_url;
    }

    public String getCms_content() {
        return cms_content;
    }

    public void setCms_content(String cms_content) {
        this.cms_content = cms_content;
    }

    public int getVideo_id() {
        return video_id;
    }

    public void setVideo_id(int video_id) {
        this.video_id = video_id;
    }

    public int getLike_num() {
        return like_num;
    }

    public void setLike_num(int like_num) {
        this.like_num = like_num;
    }

    public int getComment_num() {
        return comment_num;
    }

    public void setComment_num(int comment_num) {
        this.comment_num = comment_num;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public List<String> getPic_src() {
        return pic_src;
    }

    public void setPic_src(List<String> pic_src) {
        this.pic_src = pic_src;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIs_liked() {
        return is_liked;
    }

    public void setIs_liked(int is_liked) {
        this.is_liked = is_liked;
    }

    public long getVideo_time() {
        return video_time;
    }

    public void setVideo_time(long video_time) {
        this.video_time = video_time;
    }
}
