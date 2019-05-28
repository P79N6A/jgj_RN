package com.jizhi.jlongg.main.bean;

/**
 * CName:
 * User: hcs
 * Date: 2016-06-23
 * Time: 17:54
 */
public class CalendarModel {
    /**
     * 阳历年
     */
    private String calendarYear;
    /**
     * 阳历月
     */
    private String solarCalendarMonth;
    /**
     * 阳历日
     */
    private String solarCalendarDate;
    /**
     * 农历年
     */
    private String lunarCalendarYear;
    /**
     * 农历月
     */
    private String lunarCalendarMonth;
    /**
     * 农历日
     */
    private String lunarCalendarDate;
    /**
     * 年单位
     */
    private String yearCompany;
    /**
     * 月单位
     */
    private String monthCompany;
    /**
     * 日单位
     */
    private String dateCompany;

    /**
     * 星期单位
     */
    private String weekStr;

    public CalendarModel() {
        yearCompany = "年";
        monthCompany = "月";
        dateCompany = "日";
    }

    public void setDateCompany(String dateCompany) {
        this.dateCompany = dateCompany;
    }

    public String getCalendarYear() {
        return calendarYear;
    }

    public void setCalendarYear(String calendarYear) {
        this.calendarYear = calendarYear;
    }

    public String getSolarCalendarMonth() {
        return solarCalendarMonth;
    }

    public void setSolarCalendarMonth(String solarCalendarMonth) {
        this.solarCalendarMonth = solarCalendarMonth;
    }

    public String getSolarCalendarDate() {
        return solarCalendarDate;
    }

    public void setSolarCalendarDate(String solarCalendarDate) {
        this.solarCalendarDate = solarCalendarDate;
    }

    public String getLunarCalendarMonth() {
        return lunarCalendarMonth;
    }

    public void setLunarCalendarMonth(String lunarCalendarMonth) {
        this.lunarCalendarMonth = lunarCalendarMonth;
    }

    public String getLunarCalendarDate() {
        return lunarCalendarDate;
    }

    public void setLunarCalendarDate(String lunarCalendarDate) {
        this.lunarCalendarDate = lunarCalendarDate;
    }

    public String getWeekStr() {
        return weekStr;
    }

    public void setWeekStr(String weekStr) {
        this.weekStr = weekStr;
    }

    public String getYearCompany() {
        return yearCompany;
    }

    public String getDateCompany() {
        return dateCompany;
    }

    public String getMonthCompany() {
        return monthCompany;
    }

    public String getLunarCalendarYear() {
        return lunarCalendarYear;
    }

    public void setLunarCalendarYear(String lunarCalendarYear) {
        this.lunarCalendarYear = lunarCalendarYear;
    }
}
