package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 任务详情
 */
public class Task implements Serializable {
    /**
     * 未处理数量
     */
    private int un_deal_count;
    /**
     * 已完成数量
     */
    private int complete_count;
    /**
     * 任务列表详情
     */
    private List<TaskDetail> task_list;


    public int getComplete_count() {
        return complete_count;
    }

    public void setComplete_count(int complete_count) {
        this.complete_count = complete_count;
    }

    public List<TaskDetail> getTask_list() {
        return task_list;
    }

    public void setTask_list(List<TaskDetail> task_list) {
        this.task_list = task_list;
    }

    public int getUn_deal_count() {
        return un_deal_count;
    }

    public void setUn_deal_count(int un_deal_count) {
        this.un_deal_count = un_deal_count;
    }
}
