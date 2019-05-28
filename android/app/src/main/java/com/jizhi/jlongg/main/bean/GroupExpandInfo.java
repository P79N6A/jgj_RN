package com.jizhi.jlongg.main.bean;

/**
 * 作者    你的名字
 * 时间    2019-3-14 上午 9:48
 * 文件    yzg_android_s
 * 描述
 */
public class GroupExpandInfo extends GroupDiscussionInfo {
    /**
     * 创建者名字
     */
    public String creater_name;
    /**
     * 扫描时的邀请人Id
     */
    public String inviter_uid;
    /**
     * 关闭时间
     */
    public String close_time;
    /**
     * 来自哪里的添加
     * 1表示从快速加群-->工种群
     * 2表示从快速加群-->地区群
     */
    private int add_from;



    public String getCreater_name() {
        return creater_name;
    }

    public void setCreater_name(String creater_name) {
        this.creater_name = creater_name;
    }

    public String getInviter_uid() {
        return inviter_uid;
    }

    public void setInviter_uid(String inviter_uid) {
        this.inviter_uid = inviter_uid;
    }

    public String getClose_time() {
        return close_time;
    }

    public void setClose_time(String close_time) {
        this.close_time = close_time;
    }

    public int getAdd_from() {
        return add_from;
    }

    public void setAdd_from(int add_from) {
        this.add_from = add_from;
    }

}
