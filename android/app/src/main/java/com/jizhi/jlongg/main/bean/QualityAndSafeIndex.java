package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * CName:质量，安全首页2.3.4
 * User: hcs
 * Date: 2017-11-30
 * Time: 10:41
 */

public class QualityAndSafeIndex implements Serializable {

    private String is_statu_check;//待复查
    private String is_statu_rect;//待整改
    private String check_me;//待我复查
    private String rect_me;//待我整改
    private String offer_me;//我提供的
    private int check_me_red;//待我复查红点
    private int rect_me_red;//待我整改红点
    private String finish_list;//完成

    public String getIs_statu_check() {
        return is_statu_check;
    }

    public void setIs_statu_check(String is_statu_check) {
        this.is_statu_check = is_statu_check;
    }

    public String getIs_statu_rect() {
        return is_statu_rect;
    }

    public void setIs_statu_rect(String is_statu_rect) {
        this.is_statu_rect = is_statu_rect;
    }

    public String getCheck_me() {
        return check_me;
    }

    public void setCheck_me(String check_me) {
        this.check_me = check_me;
    }

    public String getRect_me() {
        return rect_me;
    }

    public void setRect_me(String rect_me) {
        this.rect_me = rect_me;
    }

    public String getOffer_me() {
        return offer_me;
    }

    public void setOffer_me(String offer_me) {
        this.offer_me = offer_me;
    }

    public int getCheck_me_red() {
        return check_me_red;
    }

    public void setCheck_me_red(int check_me_red) {
        this.check_me_red = check_me_red;
    }

    public int getRect_me_red() {
        return rect_me_red;
    }

    public void setRect_me_red(int rect_me_red) {
        this.rect_me_red = rect_me_red;
    }

    public String getFinish_list() {
        return finish_list;
    }

    public void setFinish_list(String finish_list) {
        this.finish_list = finish_list;
    }
}
