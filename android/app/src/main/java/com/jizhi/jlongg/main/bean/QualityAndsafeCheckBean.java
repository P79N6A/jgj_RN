package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * CName:质量，安全检查页bean 2.3.0
 * User: hcs
 * Date: 2017-07-13
 * Time: 11:40
 */

public class QualityAndsafeCheckBean {
    //总数量
    private int allnum;
    //自定义
    private int is_special;
    //待检查
    private int check;
    //待我检查
    private int check_me_red;//待我检查红点
    private int check_me;
    private List<QualityAndsafeCheckMsgBean> list;
    private String inspect_name;
    private int quality_red;//质量问题红点
    private int inspect_red;//检查质量红点

    public int getCheck_me_red() {
        return check_me_red;
    }

    public void setCheck_me_red(int check_me_red) {
        this.check_me_red = check_me_red;
    }

    public int getQuality_red() {
        return quality_red;
    }

    public int getInspect_red() {
        return inspect_red;
    }

    public void setQuality_red(int quality_red) {
        this.quality_red = quality_red;
    }

    public void setInspect_red(int inspect_red) {
        this.inspect_red = inspect_red;
    }

    public String getInspect_name() {
        return inspect_name;
    }

    public void setInspect_name(String inspect_name) {
        this.inspect_name = inspect_name;
    }


    public int getAllnum() {
        return allnum;
    }

    public void setAllnum(int allnum) {
        this.allnum = allnum;
    }

    public int getIs_special() {
        return is_special;
    }

    public void setIs_special(int is_special) {
        this.is_special = is_special;
    }

    public int getCheck() {
        return check;
    }

    public void setCheck(int check) {
        this.check = check;
    }

    public int getCheck_me() {
        return check_me;
    }

    public void setCheck_me(int check_me) {
        this.check_me = check_me;
    }

    public List<QualityAndsafeCheckMsgBean> getList() {
        return list;
    }

    public void setList(List<QualityAndsafeCheckMsgBean> list) {
        this.list = list;
    }
}

