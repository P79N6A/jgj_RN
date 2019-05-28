package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 功能:同步账单
 * 作者：xuj
 * 时间: 2016-5-9 16:30
 */
public class SynBill extends UserInfo implements Serializable {

    /**
     * 当前用户的uid
     */
    private int self_uid;
    /**
     * 已添加的同步人的id
     */
    private int target_uid;
    /**
     * 已添加的同步人的备注
     */
    private String descript;
    /**
     * 是否已经同步过此项目非必须返回  1.同步   0.未同步
     */
    private int is_sync;
    /**
     * 已添加的同步人的添加时间
     */
    private int create_time;
    /**
     * 是否选中了
     */
    private boolean isSelcted;
    /**
     * 是否已经添加
     */
    private boolean isAdd;


    public int getSelf_uid() {
        return self_uid;
    }

    public void setSelf_uid(int self_uid) {
        this.self_uid = self_uid;
    }

    public int getTarget_uid() {
        return target_uid;
    }

    public void setTarget_uid(int target_uid) {
        this.target_uid = target_uid;
    }


    public String getDescript() {
        return descript;
    }

    public void setDescript(String descript) {
        this.descript = descript;
    }

    public int getIs_sync() {
        return is_sync;
    }

    public void setIs_sync(int is_sync) {
        this.is_sync = is_sync;
    }

    public int getCreate_time() {
        return create_time;
    }

    public void setCreate_time(int create_time) {
        this.create_time = create_time;
    }

    public boolean isSelcted() {
        return isSelcted;
    }

    public void setSelcted(boolean selcted) {
        isSelcted = selcted;
    }

    public boolean isAdd() {
        return isAdd;
    }

    public void setAdd(boolean add) {
        isAdd = add;
    }

}
