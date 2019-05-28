package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * 作者    消息扩展类型
 * 时间    2019-4-2 下午 4:03
 * 文件    yzg_android_s
 * 描述
 */
public class MessageExtend implements Serializable {
    /**
     * 项目名称
     */
    private String pro_name;

    /**
     * 需要变色的列表数据
     * content 表示需要变色的文本
     * color   表示需要变的颜色
     */
    private ArrayList<MessageExtend> content;
    /**
     * 文字变色颜色
     */
    private String color;
    /**
     * 文字需要变色的内容
     */
    private String field;
    /**
     * 消息扩展
     */
    private MessageExtend msg_content;
    /**
     * 今日拨打电话人数
     */
    private String today_num;
    /**
     * 累计拨打电话人数
     */
    private String all_num;
    /**
     * 累计浏览次数
     */
    private String view_count;
    /**
     * 系统提示
     */
    private String system_msg;
    /**
     * 系统跳转url
     */
    private String jump_url;

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public ArrayList<MessageExtend> getContent() {
        return content;
    }

    public void setContent(ArrayList<MessageExtend> content) {
        this.content = content;
    }

    public String getField() {
        return field;
    }

    public void setField(String field) {
        this.field = field;
    }

    public MessageExtend getMsg_content() {
        return msg_content;
    }

    public void setMsg_content(MessageExtend msg_content) {
        this.msg_content = msg_content;
    }

    public String getToday_num() {
        return today_num;
    }

    public void setToday_num(String today_num) {
        this.today_num = today_num;
    }

    public String getAll_num() {
        return all_num;
    }

    public void setAll_num(String all_num) {
        this.all_num = all_num;
    }

    public String getView_count() {
        return view_count;
    }

    public void setView_count(String view_count) {
        this.view_count = view_count;
    }

    public String getSystem_msg() {
        return system_msg;
    }

    public void setSystem_msg(String system_msg) {
        this.system_msg = system_msg;
    }

    public String getJump_url() {
        return jump_url;
    }

    public void setJump_url(String jump_url) {
        this.jump_url = jump_url;
    }
}
