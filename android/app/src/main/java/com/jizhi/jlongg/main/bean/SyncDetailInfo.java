package com.jizhi.jlongg.main.bean;

/**
 * Created by Administrator on 2018-5-4.
 */

public class SyncDetailInfo {
    /**
     * 同步类型
     */
    private String sync_type;
    /**
     * 项目名称
     */
    private String pro_name;
    /**
     * 同步id
     */
    private String sync_id;
    /**
     * 同步项目的id
     */
    private int pid;
    /**
     * uid
     */
    private String uid;
    /**
     * 同步对象人名称
     */
    private String real_name;

    public String getSync_type() {
        return sync_type;
    }

    public void setSync_type(String sync_type) {
        this.sync_type = sync_type;
    }

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }


    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public String getSync_id() {
        return sync_id;
    }

    public void setSync_id(String sync_id) {
        this.sync_id = sync_id;
    }

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }
}
