package com.jizhi.jlongg.main.bean;


import android.graphics.drawable.Drawable;

/**
 * 功能:记账item
 * 时间:2017-2-7 17:48:28
 * 作者:xuj
 */
public class RecordItem {

    public static final int TYPE_EDIT = 1;

    public static final int TYPE_TEXT = 2;

    //点工、包工、借支共有的item
    public static final String SELECTED_ROLE = "SELECTED_ROLE"; //选择工人、班组长item
    public static final String SELECTED_DATE = "SELECTED_DATE"; //选择日期
    public static final String SELECTED_PROJECT = "SELECTED_PROJECT"; //所属项目
    public static final String RECORD_REMARK = "RECORD_REMARK"; //备注
    public static final String ROLE_FM = "RECORD_FM"; //班组长/工头
    public static final String ROLE_WORKER = "ROLE_WORKER"; //工人
    public static final String ALL_MONEY = "all_money"; //工钱
    public static final String LINE = "line";
    //点工
    public static final String WORK_TIME = "WORK_TIME"; //上班时常
    public static final String OVER_TIME = "OVER_TIME"; //加班时常
    public static final String SALARY = "SALARY"; //工资标准
    public static final String SALARY_TOTAL = "SALARY_TOTAL"; //工资
    public static final String SALARY_MONEY = "SALARY_MONEY"; //借支,结算金额
    public static final String P_S_TIME = "P_S_TIME"; //开工时间按
    public static final String P_E_TIME = "P_E_TIME"; //完工时间
    //包工
    public static final String SUBENTRY_NAME = "SUBENTRY_NAME"; //分项名称
    public static final String UNIT_PRICE = "UNIT_PRICE"; //单价
    public static final String COUNT = "COUNT"; //数量
    //借支
    public static final String SUM_MONEY = "SUM_MONEY"; //金额

    /* item文本 */
    private String text;
    /* item值 */
    private String value;
    /* 隐藏值 */
    private String hintValue;
    /* 值颜色 */
    private int valueColor;
    /* 类型 */
    private String itemType;
    /* 是否显示线 */
    private boolean isShowLine;
    /* 是否能点击 */
    private boolean isClick = true;
    /* 字体大小 */
    private int textSize;
    /* 字体颜色 */
    private int textColor;
    /* 值类型、1文本框或者2输入框 */
    private int valueType;
    //包工数量单位
    private String company;

    private Drawable icon_drawable;

    private boolean is_arrow;

    public boolean is_arrow() {
        return is_arrow;
    }

    public void setIs_arrow(boolean is_arrow) {
        this.is_arrow = is_arrow;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public Drawable getIcon_drawable() {
        return icon_drawable;
    }

    public void setIcon_drawable(Drawable icon_drawable) {
        this.icon_drawable = icon_drawable;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public int getValueColor() {
        return valueColor;
    }

    public void setValueColor(int valueColor) {
        this.valueColor = valueColor;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public boolean isShowLine() {
        return isShowLine;
    }

    public void setShowLine(boolean showLine) {
        isShowLine = showLine;
    }

    public String getHintValue() {
        return hintValue;
    }

    public void setHintValue(String hintValue) {
        this.hintValue = hintValue;
    }

    public boolean isClick() {
        return isClick;
    }

    public void setClick(boolean click) {
        isClick = click;
    }

    public RecordItem(String text, String hintValue, String itemType, boolean isShowLine) {
        this.text = text;
        this.hintValue = hintValue;
        this.itemType = itemType;
        this.isShowLine = isShowLine;
    }

    public RecordItem(String text, String hintValue, int valueColor, String itemType, int valueType) {
        this.text = text;
        this.hintValue = hintValue;
        this.valueColor = valueColor;
        this.itemType = itemType;
        this.valueType = valueType;
    }
    public RecordItem(String text, String hintValue, int valueColor, String itemType, int valueType,Drawable icon_drawable) {
        this.text = text;
        this.hintValue = hintValue;
        this.valueColor = valueColor;
        this.itemType = itemType;
        this.valueType = valueType;
        this.icon_drawable = icon_drawable;
    }

    public RecordItem(String text, String hintValue, String itemType) {
        this.text = text;
        this.hintValue = hintValue;
        this.itemType = itemType;
    }

    public RecordItem(String text, String hintValue, String itemType, int valueType, boolean is_arrow) {
        this.text = text;
        this.hintValue = hintValue;
        this.itemType = itemType;
        this.valueType = valueType;
        this.is_arrow = is_arrow;
    }

    public int getTextSize() {
        return textSize;
    }

    public void setTextSize(int textSize) {
        this.textSize = textSize;
    }

    public int getTextColor() {
        return textColor;
    }

    public void setTextColor(int textColor) {
        this.textColor = textColor;
    }

    public int getValueType() {
        return valueType;
    }

    public void setValueType(int valueType) {
        this.valueType = valueType;
    }
}
