package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 功能:检查点
 * 时间:2017年11月16日15:43:05
 * 作者:Xuj
 */
public class CheckPoint implements Serializable{

    /**
     * 检查点id
     */
    private int dot_id;
    /**
     * 检查点名
     */
    private String dot_name;
    /**
     * true表示当前item正在添加检查内容
     */
    private boolean isAddCheckContent;

    public CheckPoint(boolean isAddCheckContent) {
        this.isAddCheckContent = isAddCheckContent;
    }

    public CheckPoint() {
    }


    public String getDot_name() {
        return dot_name;
    }

    public void setDot_name(String dot_name) {
        this.dot_name = dot_name;
    }

    public boolean isAddCheckContent() {
        return isAddCheckContent;
    }

    public void setAddCheckContent(boolean addCheckContent) {
        isAddCheckContent = addCheckContent;
    }

    public int getDot_id() {
        return dot_id;
    }

    public void setDot_id(int dot_id) {
        this.dot_id = dot_id;
    }
}
