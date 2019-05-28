package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * 晴雨表记录的当天天气信息
 */

public class WeatherInfo {
    private List<WeatherInfo> weather_info;
    private String weat_am;//上午天气
    private String weat_pm;//下午天气
    private String wind_am;//上午风力
    private String wind_pm;//下午风力
    private String temp_am;//上午温度
    private String temp_pm;//下午温度
    private String weat_one;//
    private String weat_two;//
    private String weat_three;//
    private String weat_four;//
    //显示天气上午动画
    private boolean isShowWear_amAnim;
    //显示天气下午动画
    private boolean isShowWear_pmAnim;

    public List<WeatherInfo> getWeather_info() {
        return weather_info;
    }

    public void setWeather_info(List<WeatherInfo> weather_info) {
        this.weather_info = weather_info;
    }

    public String getWeat_am() {
        return weat_am;
    }

    public void setWeat_am(String weat_am) {
        this.weat_am = weat_am;
    }

    public String getWeat_pm() {
        return weat_pm;
    }

    public void setWeat_pm(String weat_pm) {
        this.weat_pm = weat_pm;
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

    public String getWeat_one() {
        return weat_one;
    }

    public void setWeat_one(String weat_one) {
        this.weat_one = weat_one;
    }

    public String getWeat_two() {
        return weat_two;
    }

    public void setWeat_two(String weat_two) {
        this.weat_two = weat_two;
    }

    public String getWeat_three() {
        return weat_three;
    }

    public void setWeat_three(String weat_three) {
        this.weat_three = weat_three;
    }

    public String getWeat_four() {
        return weat_four;
    }

    public void setWeat_four(String weat_four) {
        this.weat_four = weat_four;
    }

    public boolean isShowWear_amAnim() {
        return isShowWear_amAnim;
    }

    public void setShowWear_amAnim(boolean showWear_amAnim) {
        isShowWear_amAnim = showWear_amAnim;
    }

    public boolean isShowWear_pmAnim() {
        return isShowWear_pmAnim;
    }

    public void setShowWear_pmAnim(boolean showWear_pmAnim) {
        isShowWear_pmAnim = showWear_pmAnim;
    }
}
