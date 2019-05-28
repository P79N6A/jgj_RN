package com.jizhi.jlongg.main.bean;

import com.jizhi.jlongg.main.application.UclientApplication;

import org.litepal.LitePal;
import org.litepal.crud.LitePalSupport;

import java.io.Serializable;
import java.util.List;

/**
 * @author: SCY
 * @date: 2019/4/17   17:02
 * @version:
 * @desc:
 */
public class SaveLogMode extends LitePalSupport implements Serializable {
    private String cat_id;//日志类型
    private String uid;//用户ID
    private String group_id;//组信息
    private String photos;//选择的图片信息
    private String  logModeElements;//json型的相应填写信息
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

    public String getPhotos() {
        return photos;
    }

    public void setPhotos(String photos) {
        this.photos = photos;
    }

    public String getLogModeElements() {
        return logModeElements;
    }

    public void setLogModeElements(String logModeElements) {
        this.logModeElements = logModeElements;
    }

    public String getCat_id() {
        return cat_id;
    }

    public void setCat_id(String cat_id) {
        this.cat_id = cat_id;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }


    //    private String key;//数据库的
//    private String value;
//    private String element_type;
//    private String uid;
//    private String group_id;
//
//    public SaveLogMode() {
//
//    }
//    public SaveLogMode(String key, String value,String element_type) {
//        this.key = key;
//        this.value = value;
//        this.element_type = element_type;
//    }
//
//
//    public String getKey() {
//        return key;
//    }
//
//    public void setKey(String key) {
//        this.key = key;
//    }
//
//    public String getValue() {
//        return value;
//    }
//
//    public void setValue(String value) {
//        this.value = value;
//    }
//
//    public String getElement_type() {
//        return element_type;
//    }
//
//    public void setElement_type(String element_type) {
//        this.element_type = element_type;
//    }
//
//    public String getUid() {
//        return uid;
//    }
//
//    public void setUid(String uid) {
//        this.uid = uid;
//    }
//
//    public String getGroup_id() {
//        return group_id;
//    }
//
//    public void setGroup_id(String group_id) {
//        this.group_id = group_id;
//    }
}
