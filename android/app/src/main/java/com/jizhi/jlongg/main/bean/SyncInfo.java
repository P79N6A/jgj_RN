package com.jizhi.jlongg.main.bean;

import java.util.ArrayList;

/**
 * Created by Administrator on 2018-5-4.
 */

public class SyncInfo {
    /**
     * 同步人信息
     */
    private UserInfo user_info;
    /**
     * 同步的项目数
     */
    private int synced_num;
    /**
     * 同步列表数据
     */
    private ArrayList<SyncDetailInfo> synced_list;

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public int getSynced_num() {
        return synced_num;
    }

    public void setSynced_num(int synced_num) {
        this.synced_num = synced_num;
    }

    public ArrayList<SyncDetailInfo> getSynced_list() {
        return synced_list;
    }

    public void setSynced_list(ArrayList<SyncDetailInfo> synced_list) {
        this.synced_list = synced_list;
    }
}
