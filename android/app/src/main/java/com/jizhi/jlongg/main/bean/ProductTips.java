package com.jizhi.jlongg.main.bean;

import android.graphics.Color;

/**
 * Created by Administrator on 2017/8/16 0016.
 */

public class ProductTips extends ProductPriceInfo {

    /**
     * 主要是项目设置里面使用  显示item标题
     */
    private String first_title_name;
    /**
     * 主要是项目设置里面使用  显示itme值
     */
    private String second_title_name;
    /**
     * 是否能点击
     */
    private boolean isClick = true;
    /**
     * 是否显示背景
     */
    private boolean isShowBackGround;
    /**
     * 是否已过期
     */
    private int is_expired;
    /**
     * 值的颜色
     */
    private int valueColor = Color.parseColor("#333333");
    /**
     * 1.2.3.4
     */
    private int buy_type;

    public String getFirst_title_name() {
        return first_title_name;
    }

    public void setFirst_title_name(String first_title_name) {
        this.first_title_name = first_title_name;
    }

    public String getSecond_title_name() {
        return second_title_name;
    }

    public void setSecond_title_name(String second_title_name) {
        this.second_title_name = second_title_name;
    }


    public boolean isClick() {
        return isClick;
    }

    public void setClick(boolean click) {
        isClick = click;
    }

    public boolean isShowBackGround() {
        return isShowBackGround;
    }

    public void setShowBackGround(boolean showBackGround) {
        isShowBackGround = showBackGround;
    }


    public int getValueColor() {
        return valueColor;
    }

    public void setValueColor(int valueColor) {
        this.valueColor = valueColor;
    }

    public int getIs_expired() {
        return is_expired;
    }

    public void setIs_expired(int is_expired) {
        this.is_expired = is_expired;
    }

    public int getBuy_type() {
        return buy_type;
    }

    public void setBuy_type(int buy_type) {
        this.buy_type = buy_type;
    }
}
