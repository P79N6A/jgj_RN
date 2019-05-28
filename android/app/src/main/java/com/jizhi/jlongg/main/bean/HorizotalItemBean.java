package com.jizhi.jlongg.main.bean;


import android.graphics.Color;
import android.graphics.drawable.Drawable;

/**
 * 聊天管理
 */
public class HorizotalItemBean extends UserInfo {
    /**
     * 菜单id 主要是做事件点击区分
     */
    private int menuId;
    /**
     * 菜单
     */
    private String menu;
    /**
     * 菜单图标
     */
    private Drawable menuDrawable;
    /**
     * 菜单值
     */
    private String value;
    /**
     * 菜单值颜色,默认为黑色
     */
    private int valueColor = Color.parseColor("#000000");
    /**
     * 是否能点击
     */
    private boolean isClick = true;
    /**
     * 小红点提示
     */
    private String red_tips;
    /**
     * 是否显示小红点
     */
    private boolean show_little_red_dot;

    public String getMenu() {
        return menu;
    }

    public void setMenu(String menu) {
        this.menu = menu;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public boolean isClick() {
        return isClick;
    }

    public void setClick(boolean click) {
        isClick = click;
    }

    public HorizotalItemBean(String menu, String value, int menuId, Drawable menuDrawable) {
        this.menu = menu;
        this.value = value;
        this.menuId = menuId;
        this.menuDrawable = menuDrawable;
    }

    public HorizotalItemBean(String menu, int menuId, Drawable menuDrawable) {
        this.menu = menu;
        this.menuId = menuId;
        this.menuDrawable = menuDrawable;
    }

    public Drawable getMenuDrawable() {
        return menuDrawable;
    }

    public void setMenuDrawable(Drawable menuDrawable) {
        this.menuDrawable = menuDrawable;
    }

    public int getValueColor() {
        return valueColor;
    }

    public void setValueColor(int valueColor) {
        this.valueColor = valueColor;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public String getRed_tips() {
        return red_tips;
    }

    public void setRed_tips(String red_tips) {
        this.red_tips = red_tips;
    }

    public boolean isShow_little_red_dot() {
        return show_little_red_dot;
    }

    public void setShow_little_red_dot(boolean show_little_red_dot) {
        this.show_little_red_dot = show_little_red_dot;
    }
}
