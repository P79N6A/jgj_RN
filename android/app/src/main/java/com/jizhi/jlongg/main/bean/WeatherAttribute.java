package com.jizhi.jlongg.main.bean;

import com.jizhi.jlongg.main.activity.WebSocketBaseParameter;

/**
 * 功能: 晴雨表属性
 * 作者：xuj
 * 时间: 2017年3月31日11:08:04
 */
public class WeatherAttribute extends WebSocketBaseParameter {


    private int weat_one; //天气1(晴：1；阴：2；多云：3；雨：4；风：5；雪：6；雾:7;霾：8；冰冻：9:停电：10，不选：0)
    private int weat_two; //天气2
    private int weat_three; //天气3
    private int weat_four; //天气4
    private String temp_am; //上午温度
    private String temp_pm; //下午温度
    private String wind_am;//上午风力
    private String wind_pm;//下午风力
    private String detail; //描述


    public static final int CLEAR_DAY = 1; //晴
    public static final int SHADE = 2; //阴
    public static final int CLOUDY = 3; //多云
    public static final int RAIN = 4; //雨
    public static final int WIND = 5; //风
    public static final int SNOW = 6; //雪
    public static final int FOG = 7; //雾
    public static final int HAZE = 8; //霾
    public static final int ICE_SNOW = 9; //冰冻
    public static final int POWER_CUT = 10; //停电
    public static final int NOTHING = 0; //无
    /**
     * 天气表id
     */
    private int id;
    /**
     * 天气颜色
     */
    private int weatherColor;
    /**
     * 天气ID
     */
    private int weatherId;
    /**
     * 天气图片
     */
    private int weatherIcon;
    /**
     * 天气名称
     */
    private String weatherName;
    /**
     * 是否选中当前天气
     */
    private boolean isSelected;
    /**
     * 选择顺序
     */
    private int selectOrder;
    /**
     * 列表天气 温度描述
     */
    private String weat;
    /**
     * 记录员信息
     */
    private UserInfo record_info;
    /**
     * 日期描述
     */
    private String day;

    /**
     * 服务器返回的风力描述
     */
    private String wind;
    /**
     * 服务器返回的温度描述
     */
    private String temp;

    /**
     * 2017-06-01
     */
    private String all_date;

    /**
     * 天气是否已关闭 0表示未关闭  1表示关闭
     */
    private int is_close;


    public WeatherAttribute(int weatherIcon, String weatherName, int weatherId, int weatherColor) {
        this.weatherIcon = weatherIcon;
        this.weatherName = weatherName;
        this.weatherId = weatherId;
        this.weatherColor = weatherColor;
    }

    public WeatherAttribute(int weatherIcon, String weatherName) {
        this.weatherIcon = weatherIcon;
        this.weatherName = weatherName;
    }

    public WeatherAttribute() {
    }

    public int getWeatherIcon() {
        return weatherIcon;
    }

    public void setWeatherIcon(int weatherIcon) {
        this.weatherIcon = weatherIcon;
    }

    public String getWeatherName() {
        return weatherName;
    }

    public void setWeatherName(String weatherName) {
        this.weatherName = weatherName;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public int getWeatherId() {
        return weatherId;
    }

    public void setWeatherId(int weatherId) {
        this.weatherId = weatherId;
    }

    public int getWeatherColor() {
        return weatherColor;
    }

    public void setWeatherColor(int weatherColor) {
        this.weatherColor = weatherColor;
    }

    public int getSelectOrder() {
        return selectOrder;
    }

    public void setSelectOrder(int selectOrder) {
        this.selectOrder = selectOrder;
    }

    public int getWeat_one() {
        return weat_one;
    }

    public void setWeat_one(int weat_one) {
        this.weat_one = weat_one;
    }

    public int getWeat_two() {
        return weat_two;
    }

    public void setWeat_two(int weat_two) {
        this.weat_two = weat_two;
    }

    public int getWeat_three() {
        return weat_three;
    }

    public void setWeat_three(int weat_three) {
        this.weat_three = weat_three;
    }

    public int getWeat_four() {
        return weat_four;
    }

    public void setWeat_four(int weat_four) {
        this.weat_four = weat_four;
    }

    public String getTemp_am() {
        return temp_am;
    }

    public void setTemp_am(String temp_am) {
        this.temp_am = temp_am;
    }

    public String getTemp_pm() {
        return temp_pm;
    }

    public void setTemp_pm(String temp_pm) {
        this.temp_pm = temp_pm;
    }

    public String getWind_am() {
        return wind_am;
    }

    public void setWind_am(String wind_am) {
        this.wind_am = wind_am;
    }

    public String getWind_pm() {
        return wind_pm;
    }

    public void setWind_pm(String wind_pm) {
        this.wind_pm = wind_pm;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }


    public UserInfo getRecord_info() {
        return record_info;
    }

    public void setRecord_info(UserInfo record_info) {
        this.record_info = record_info;
    }

    public String getWeat() {
        return weat;
    }

    public void setWeat(String weat) {
        this.weat = weat;
    }

    public String getDay() {
        return day;
    }

    public void setDay(String day) {
        this.day = day;
    }

    public String getWind() {
        return wind;
    }

    public void setWind(String wind) {
        this.wind = wind;
    }

    public String getTemp() {
        return temp;
    }

    public void setTemp(String temp) {
        this.temp = temp;
    }

    public String getAll_date() {
        return all_date;
    }

    public void setAll_date(String all_date) {
        this.all_date = all_date;
    }

    public int getIs_close() {
        return is_close;
    }

    public void setIs_close(int is_close) {
        this.is_close = is_close;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
