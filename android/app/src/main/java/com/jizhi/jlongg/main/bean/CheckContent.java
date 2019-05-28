package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * 功能:检查内容
 * 时间:2017年11月16日15:43:05
 * 作者:Xuj
 */
public class CheckContent extends BaseCheckInfo {
    /**
     * 检查内容id
     */
    private int content_id;
    /**
     * 检查内容名称
     */
    private String content_name;
    /**
     * 是否展示全部的检查点
     */
    private boolean is_expand;

    /**
     * 检查点详情
     */
    private List<CheckPoint> dot_list;

    public int getContent_id() {
        return content_id;
    }

    public void setContent_id(int content_id) {
        this.content_id = content_id;
    }

    public String getContent_name() {
        return content_name;
    }

    public void setContent_name(String content_name) {
        this.content_name = content_name;
    }

    public List<CheckPoint> getDot_list() {
        return dot_list;
    }

    public void setDot_list(List<CheckPoint> dot_list) {
        this.dot_list = dot_list;
    }

    public boolean is_expand() {
        return is_expand;
    }

    public void setIs_expand(boolean is_expand) {
        this.is_expand = is_expand;
    }
}
