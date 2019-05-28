package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * 数据来源人  数据源管理
 */
public class SourceMemberProManager implements Serializable {
    /**
     * 数据来源人,项目组数据源
     */
    private SourceMemberProCount sync_count;
    /**
     * 数据来源人项目组
     */
    private ArrayList<SourceMemberProInfo> list;


    public SourceMemberProCount getSync_count() {
        return sync_count;
    }

    public void setSync_count(SourceMemberProCount sync_count) {
        this.sync_count = sync_count;
    }

    public ArrayList<SourceMemberProInfo> getList() {
        return list;
    }

    public void setList(ArrayList<SourceMemberProInfo> list) {
        this.list = list;
    }
}
