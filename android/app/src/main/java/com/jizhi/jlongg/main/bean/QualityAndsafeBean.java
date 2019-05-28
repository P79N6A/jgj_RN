package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * Created by Administrator on 2017/6/7 0007.
 */

public class QualityAndsafeBean {
    //待整改
    private String is_statu_rect;
    //待复查
    private String is_statu_check;
    //待我整改
    private String rect_me;
    //待我复查
    private String check_me;
    //小铃铛是否显示红点1:显示 0：不显示
    private int is_new_message;
    //质量安全列表
    private List<MessageEntity> list;
    private String list_counts;
    private int quality_red;
    private int inspect_red;
    private int rect_me_red;//待我整改红点 1：表示有红点
    private int check_me_red;//待我复查红点 1：表示有红点

    public int getRect_me_red() {
        return rect_me_red;
    }

    public void setRect_me_red(int rect_me_red) {
        this.rect_me_red = rect_me_red;
    }

    public int getCheck_me_red() {
        return check_me_red;
    }

    public void setCheck_me_red(int check_me_red) {
        this.check_me_red = check_me_red;
    }

    public int getQuality_red() {
        return quality_red;
    }

    public void setQuality_red(int quality_red) {
        this.quality_red = quality_red;
    }

    public int getInspect_red() {
        return inspect_red;
    }

    public void setInspect_red(int inspect_red) {
        this.inspect_red = inspect_red;
    }

    public String getList_counts() {
        return list_counts;
    }

    public void setList_counts(String list_counts) {
        this.list_counts = list_counts;
    }

    public int getIs_new_message() {
        return is_new_message;
    }

    public void setIs_new_message(int is_new_message) {
        this.is_new_message = is_new_message;
    }

    public String getIs_statu_rect() {
        return is_statu_rect;
    }

    public void setIs_statu_rect(String is_statu_rect) {
        this.is_statu_rect = is_statu_rect;
    }

    public String getIs_statu_check() {
        return is_statu_check;
    }

    public void setIs_statu_check(String is_statu_check) {
        this.is_statu_check = is_statu_check;
    }

    public String getRect_me() {
        return rect_me;
    }

    public void setRect_me(String rect_me) {
        this.rect_me = rect_me;
    }

    public String getCheck_me() {
        return check_me;
    }

    public void setCheck_me(String check_me) {
        this.check_me = check_me;
    }

    public List<MessageEntity> getList() {
        return list;
    }

    public void setList(List<MessageEntity> list) {
        this.list = list;
    }
}

