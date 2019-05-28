package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * @author: SCY
 * @date: 2019/4/18   18:02
 * @version:
 * @desc:
 */
public class LogModeElement implements Serializable {
    private String element_key;
    private String element_value;
    private String element_type;
    private int position;
    private String select_id;
    private String weather_value;
    private String location;

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getElement_key() {
        return element_key;
    }

    public void setElement_key(String element_key) {
        this.element_key = element_key;
    }

    public String getElement_value() {
        return element_value;
    }

    public void setElement_value(String element_value) {
        this.element_value = element_value;
    }

    public String getElement_type() {
        return element_type;
    }

    public void setElement_type(String element_type) {
        this.element_type = element_type;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public String getSelect_id() {
        return select_id;
    }

    public void setSelect_id(String select_id) {
        this.select_id = select_id;
    }

    public String getWeather_value() {
        return weather_value;
    }

    public void setWeather_value(String weather_value) {
        this.weather_value = weather_value;
    }
}
