package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * 功能:
 * 作者：xuj
 * 时间: 2016-4-27 16:44
 */
public class ProjectList1 {
    /**
     * 项目数据
     */
    private List<FindProjectBean> data_list;
    /**
     * 工种信息
     */
    private List<TypeList> type_list;

    public List<TypeList> getType_list() {
        return type_list;
    }

    public void setType_list(List<TypeList> type_list) {
        this.type_list = type_list;
    }

    public List<FindProjectBean> getData_list() {
        return data_list;
    }

    public void setData_list(List<FindProjectBean> data_list) {
        this.data_list = data_list;
    }
}
