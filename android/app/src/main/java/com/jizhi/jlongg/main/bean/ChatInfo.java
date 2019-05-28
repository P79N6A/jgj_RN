package com.jizhi.jlongg.main.bean;

import java.util.ArrayList;

public class ChatInfo {

    /**
     * 聊聊列表数据
     */
    private ArrayList<GroupDiscussionInfo> list;
    /**
     * 已关闭的讨论组信息
     */
    private ArrayList<GroupDiscussionInfo> closed_list;
    /**
     * 未关闭的讨论组
     */
    private ArrayList<GroupDiscussionInfo> unclose_list;


    public ArrayList<GroupDiscussionInfo> getList() {
        return list;
    }

    public void setList(ArrayList<GroupDiscussionInfo> list) {
        this.list = list;
    }

    public ArrayList<GroupDiscussionInfo> getClosed_list() {
        return closed_list;
    }

    public void setClosed_list(ArrayList<GroupDiscussionInfo> closed_list) {
        this.closed_list = closed_list;
    }

    public ArrayList<GroupDiscussionInfo> getUnclose_list() {
        return unclose_list;
    }

    public void setUnclose_list(ArrayList<GroupDiscussionInfo> unclose_list) {
        this.unclose_list = unclose_list;
    }
}
