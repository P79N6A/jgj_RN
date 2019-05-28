package com.jizhi.jlongg.main.bean;

import android.graphics.Color;

import java.io.Serializable;

/**
 * 功能: 单选
 * 作者：xuj
 * 时间: 2017年6月7日15:52:08
 */
public class SingleSelected implements Serializable {
    /**
     * 单选菜单名称
     */
    private String name;
    /**
     * 菜单值
     */
    private String value;
    /**
     * 选中的编号
     */
    private String selecteNumber;
    /**
     * 是否选中
     */
    private boolean isSelected;
    /**
     * 是否显示选中框
     */
    private boolean isShowSelectedIcon;
    /**
     * 是否显示背景
     */
    private boolean isShowBackGround;
    /**
     * 注销账户  主要是设置里面点进去需要使用
     */
    private boolean cancelAccount;
    /**
     * 切换记工显示方式
     */
    private boolean change_account_show_type;
    /**
     * 文本颜色
     */
    private int textColor = Color.parseColor("#333333");
    /**
     * 文字大小
     */
    private int textSize;

    public SingleSelected(boolean isShowBackGround, boolean change_account_show_type) {
        this.isShowBackGround = isShowBackGround;
        this.change_account_show_type = change_account_show_type;
    }


    public SingleSelected(String name, String selecteNumber) {
        this.name = name;
        this.selecteNumber = selecteNumber;
    }

    public SingleSelected(String name, boolean isShowSelectedIcon, boolean isShowBackGround, String selecteNumber) {
        this.name = name;
        this.isShowSelectedIcon = isShowSelectedIcon;
        this.isShowBackGround = isShowBackGround;
        this.selecteNumber = selecteNumber;
    }

    public SingleSelected(String name, boolean isShowSelectedIcon, boolean isShowBackGround, String selecteNumber, int textColor) {
        this.name = name;
        this.isShowSelectedIcon = isShowSelectedIcon;
        this.isShowBackGround = isShowBackGround;
        this.selecteNumber = selecteNumber;
        this.textColor = textColor;
    }

    public SingleSelected(String name, boolean isShowSelectedIcon, boolean isShowBackGround, String selecteNumber, int textColor, int textSize) {
        this.name = name;
        this.isShowSelectedIcon = isShowSelectedIcon;
        this.isShowBackGround = isShowBackGround;
        this.selecteNumber = selecteNumber;
        this.textColor = textColor;
        this.textSize = textSize;
    }

    public SingleSelected(String name, String value, boolean isShowSelectedIcon, boolean isShowBackGround, String selecteNumber, int textColor, int textSize) {
        this.name = name;
        this.value = value;
        this.isShowSelectedIcon = isShowSelectedIcon;
        this.isShowBackGround = isShowBackGround;
        this.selecteNumber = selecteNumber;
        this.textColor = textColor;
        this.textSize = textSize;
    }

    public SingleSelected(boolean isShowBackGround, boolean cancelAccount, String selecteNumber) {
        this.isShowBackGround = isShowBackGround;
        this.cancelAccount = cancelAccount;
        this.selecteNumber = selecteNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public String getSelecteNumber() {
        return selecteNumber;
    }

    public SingleSelected setSelecteNumber(String selecteNumber) {
        this.selecteNumber = selecteNumber;
        return this;
    }

    public boolean isShowBackGround() {
        return isShowBackGround;
    }

    public void setShowBackGround(boolean showBackGround) {
        isShowBackGround = showBackGround;
    }

    public boolean isShowSelectedIcon() {
        return isShowSelectedIcon;
    }

    public void setShowSelectedIcon(boolean showSelectedIcon) {
        isShowSelectedIcon = showSelectedIcon;
    }

    public int getTextColor() {
        return textColor;
    }

    public void setTextColor(int textColor) {
        this.textColor = textColor;
    }

    public boolean isCancelAccount() {
        return cancelAccount;
    }

    public void setCancelAccount(boolean cancelAccount) {
        this.cancelAccount = cancelAccount;
    }

    public boolean isChange_account_show_type() {
        return change_account_show_type;
    }

    public void setChange_account_show_type(boolean change_account_show_type) {
        this.change_account_show_type = change_account_show_type;
    }

    public int getTextSize() {
        return textSize;
    }

    public void setTextSize(int textSize) {
        this.textSize = textSize;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
