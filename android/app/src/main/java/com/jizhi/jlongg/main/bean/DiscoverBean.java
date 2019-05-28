package com.jizhi.jlongg.main.bean;

/**
 * 作者    xuj
 * 时间    2019-1-10 下午 4:02
 * 文件   发现小红点
 * 描述
 */
public class DiscoverBean {
    /**
     * 新评论数
     */
    private int new_comment_num;
    /**
     * 新点赞数
     */
    private int new_liked_num;
    /**
     * 粉丝数
     */
    private int new_fans_num;

    public int getNew_comment_num() {
        return new_comment_num;
    }

    public void setNew_comment_num(int new_comment_num) {
        this.new_comment_num = new_comment_num;
    }

    public int getNew_liked_num() {
        return new_liked_num;
    }

    public void setNew_liked_num(int new_liked_num) {
        this.new_liked_num = new_liked_num;
    }

    public int getNew_fans_num() {
        return new_fans_num;
    }

    public void setNew_fans_num(int new_fans_num) {
        this.new_fans_num = new_fans_num;
    }
}
