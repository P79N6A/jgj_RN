package com.jizhi.jlongg.main.bean;


import java.io.Serializable;

/**
 * 功能: 隐患级别
 * 作者：胡常生
 * 时间: 2017年5月26日 16:10:12
 */
public class ProjectLevel implements Serializable {
    private String name;
    private int id;
    /**
     * 是否选中了
     */
    private boolean isChecked;
    private int position;
    private String element_name;
    private String element_value;
    private String element_type;

    private DateAndTime dateAndTime;
    private String weather_value;

    public DateAndTime getDateAndTime() {
        if (null == dateAndTime) {
            dateAndTime = new DateAndTime();
        }
        return dateAndTime;
    }

    public void setDateAndTime(DateAndTime dateAndTime) {
        this.dateAndTime = dateAndTime;
    }

    public String getWeather_value() {
        return weather_value;
    }

    public void setWeather_value(String weather_value) {
        this.weather_value = weather_value;
    }

    public String getElement_type() {
        return element_type;
    }

    public void setElement_type(String element_type) {
        this.element_type = element_type;
    }

    public String getElement_value() {
        if (null == element_value) {
            element_value = "";
        }
        return element_value;
    }

    public void setElement_value(String element_value) {
        this.element_value = element_value;
    }


    public ProjectLevel(String name, int id) {
        this.name = name;
        this.id = id;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public String getElement_name() {
        return element_name;
    }

    public void setElement_name(String element_name) {
        this.element_name = element_name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public boolean isChecked() {
        return isChecked;
    }

    public void setChecked(boolean checked) {
        isChecked = checked;
    }

}
