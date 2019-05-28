package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 任务详情
 */
public class TaskBaseInfo implements Serializable {
    /**
     * 待处理
     */
    private int un_deal_count;
    /**
     * 我负责的
     */
    private int my_admin_count;
    /**
     * 我提交的
     */
    private int my_submit_count;
    /**
     * 我参与的
     */
    private int my_join_count;
    /**
     * 1表示有有我负责的 小红点
     */
    private int is_admin_msg;
    /**
     * 1表示有我参与的 小红点
     */
    private int is_join_msg;

    public int getUn_deal_count() {
        return un_deal_count;
    }

    public void setUn_deal_count(int un_deal_count) {
        this.un_deal_count = un_deal_count;
    }

    public int getMy_admin_count() {
        return my_admin_count;
    }

    public void setMy_admin_count(int my_admin_count) {
        this.my_admin_count = my_admin_count;
    }

    public int getMy_submit_count() {
        return my_submit_count;
    }

    public void setMy_submit_count(int my_submit_count) {
        this.my_submit_count = my_submit_count;
    }

    public int getMy_join_count() {
        return my_join_count;
    }

    public void setMy_join_count(int my_join_count) {
        this.my_join_count = my_join_count;
    }

    public int getIs_admin_msg() {
        return is_admin_msg;
    }

    public void setIs_admin_msg(int is_admin_msg) {
        this.is_admin_msg = is_admin_msg;
    }

    public int getIs_join_msg() {
        return is_join_msg;
    }

    public void setIs_join_msg(int is_join_msg) {
        this.is_join_msg = is_join_msg;
    }
}
