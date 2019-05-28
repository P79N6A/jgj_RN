package com.jizhi.jlongg.main.bean;


import android.graphics.Color;
import android.graphics.drawable.Drawable;

/**
 * 聊天管理
 */
public class ChatManagerItem extends UserInfo {

    public static final int TEXT_ITEM = 0; //普通文本Item
    public static final int SWITCH_BTN = 1; //开关Item
    public static final int RIGHT_IMAGE_ITEM = 2; //图片
    public static final int CHECK_VERSION_ITEM = 3; //检测版本
    public static final int EDITOR = 4; //编辑框
    public static final int TEXT_HINT = 5; //提示文字
    public static final int PROJECT_CHANGE = 6; //整改措施
    public static final int RIGHT_IMAGE_AND_ARROW = 7; //右侧有图片跟箭头
    /* 菜单 */
    private String menu;

    /* 菜单图标 */
    private Drawable menuDrawable;
    /* 菜单值 */
    private String value;
    private String menuValue;

    /* 菜单值颜色 */
    private int menuValueColor;
    private String valueBottom;

    private int valueBottomSize;
    /* 菜单值底部颜色 */
    private int valueBottomColor;
    /* 当菜单没有值,显示的内容*/
    private String menuHint;
    /* 是否能点击 */
    private boolean isClick;
    /* 是否显示背景*/
    private boolean isShowBackGround;
    /* 菜单类型 */
    private int menuType;
    /* 菜单类型 */
    private int itemType = TEXT_ITEM;
    /*是否是按钮 */
    private boolean isButton;
    private boolean switchState;
    /*是否隐藏右侧图片 */
    private boolean isHideRightImage;


    /* 值的颜色 */
    private int valueColor = Color.parseColor("#333333");

    private boolean isNewVersion;

    private int rightImageResources = 0;

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

    public ChatManagerItem(String menu, String value) {
        this.menu = menu;
        this.value = value;
    }

    public ChatManagerItem(String menu, boolean isClick, boolean isShowBackGround, int menuType) {
        this.menu = menu;
        this.isClick = isClick;
        this.isShowBackGround = isShowBackGround;
        this.menuType = menuType;
    }

    public ChatManagerItem(String menu, boolean isClick, boolean isShowBackGround, int menuType, String menuValue) {
        this.menu = menu;
        this.isClick = isClick;
        this.isShowBackGround = isShowBackGround;
        this.menuType = menuType;
        this.menuValue = menuValue;
    }

    public ChatManagerItem(String menu, int menuType, Drawable menuDrawable) {
        this.menu = menu;
        this.menuType = menuType;
        this.menuDrawable = menuDrawable;
    }


    public boolean isButton() {
        return isButton;
    }

    public void setButton(boolean button) {
        isButton = button;
    }

    public boolean isShowBackGround() {
        return isShowBackGround;
    }

    public void setShowBackGround(boolean showBackGround) {
        isShowBackGround = showBackGround;
    }

    public int getMenuType() {
        return menuType;
    }

    public void setMenuType(int menuType) {
        this.menuType = menuType;
    }

    public int getItemType() {
        return itemType;
    }

    public void setItemType(int itemType) {
        this.itemType = itemType;
    }

    public boolean isSwitchState() {
        return switchState;
    }

    public void setSwitchState(boolean switchState) {
        this.switchState = switchState;
    }

    public String getMenuValue() {
        return menuValue;
    }

    public void setMenuValue(String menuValue) {
        this.menuValue = menuValue;
    }

    public boolean isNewVersion() {
        return isNewVersion;
    }

    public void setNewVersion(boolean newVersion) {
        isNewVersion = newVersion;
    }

    public String getMenuHint() {
        return menuHint;
    }

    public void setMenuHint(String menuHint) {
        this.menuHint = menuHint;
    }

    public int getValueColor() {
        return valueColor;
    }

    public void setValueColor(int valueColor) {
        this.valueColor = valueColor;
    }

    public int getRightImageResources() {
        return rightImageResources;
    }

    public void setRightImageResources(int rightImageResources) {
        this.rightImageResources = rightImageResources;
    }

    public Drawable getMenuDrawable() {
        return menuDrawable;
    }

    public void setMenuDrawable(Drawable menuDrawable) {
        this.menuDrawable = menuDrawable;
    }

    public String getValueBottom() {
        return valueBottom;
    }

    public void setValueBottom(String valueBottom) {
        this.valueBottom = valueBottom;
    }

    public int getMenuValueColor() {
        return menuValueColor;
    }

    public void setMenuValueColor(int menuValueColor) {
        this.menuValueColor = menuValueColor;
    }

    public int getValueBottomColor() {
        return valueBottomColor;
    }

    public void setValueBottomColor(int valueBottomColor) {
        this.valueBottomColor = valueBottomColor;
    }

    public int getValueBottomSize() {
        return valueBottomSize;
    }

    public void setValueBottomSize(int valueBottomSize) {
        this.valueBottomSize = valueBottomSize;
    }

    public boolean isHideRightImage() {
        return isHideRightImage;
    }

    public void setHideRightImage(boolean hideRightImage) {
        isHideRightImage = hideRightImage;
    }
}
