package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 数据来源人同步项目组与未同步管理
 */
public class SourceMemberProList implements Serializable {
    /**
     * 项目组源数量
     */
    private int count;
    /**
     * 项目组源数据
     */
    private List<Project> list;

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public List<Project> getList() {
        return list;
    }

    public void setList(List<Project> list) {
        this.list = list;
    }
}
