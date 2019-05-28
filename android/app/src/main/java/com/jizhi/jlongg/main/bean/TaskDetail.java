package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 任务详情
 */
public class TaskDetail implements Serializable {

    // 任务级别(1:一般；2：紧急；3：非常紧急)
    public static final int COMMONLY = 1;
    public static final int URGENT = 2;
    public static final int VERY_URGENT = 3;

    /**
     * 任务id
     */
    private String task_id;
    /**
     * 任务内容
     */
    private String task_content;
    /**
     * 任务等级
     */
    private int task_level;
    /**
     * 任务完成时间
     */
    private String task_finish_time;
    /**
     * 1 任务已过期 2 临近过期 3 有截止时间 0 没有截止时间
     */
    private int task_finish_time_type;
    /**
     * 是否具有修改任务状态的权限
     */
    private int is_can_deal;
    /**
     * 任务图片
     */
    private List<String> msg_src;
    /**
     * 负责人信息
     */
    private UserInfo principal_user_info;
    /**
     * 发布者信息
     */
    private UserInfo pub_user_info;
    /**
     * 任务创建时间
     */
    private String create_time;
    /**
     * 0:待处理，1：已完成
     */
    private int task_status;


    public String getTask_id() {
        return task_id;
    }

    public void setTask_id(String task_id) {
        this.task_id = task_id;
    }

    public String getTask_content() {
        return task_content;
    }

    public void setTask_content(String task_content) {
        this.task_content = task_content;
    }


    public String getTask_finish_time() {
        return task_finish_time;
    }

    public void setTask_finish_time(String task_finish_time) {
        this.task_finish_time = task_finish_time;
    }


    public int getTask_finish_time_type() {
        return task_finish_time_type;
    }

    public void setTask_finish_time_type(int task_finish_time_type) {
        this.task_finish_time_type = task_finish_time_type;
    }

    public int getIs_can_deal() {
        return is_can_deal;
    }

    public void setIs_can_deal(int is_can_deal) {
        this.is_can_deal = is_can_deal;
    }

    public List<String> getMsg_src() {
        return msg_src;
    }

    public void setMsg_src(List<String> msg_src) {
        this.msg_src = msg_src;
    }

    public int getTask_level() {
        return task_level;
    }

    public void setTask_level(int task_level) {
        this.task_level = task_level;
    }

    public UserInfo getPrincipal_user_info() {
        return principal_user_info;
    }

    public void setPrincipal_user_info(UserInfo principal_user_info) {
        this.principal_user_info = principal_user_info;
    }

    public UserInfo getPub_user_info() {
        return pub_user_info;
    }

    public void setPub_user_info(UserInfo pub_user_info) {
        this.pub_user_info = pub_user_info;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public int getTask_status() {
        return task_status;
    }

    public void setTask_status(int task_status) {
        this.task_status = task_status;
    }
}
