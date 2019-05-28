package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * @author: SCY
 * @date: 2019/4/18   18:28
 * @version:
 * @desc:
 */
public class ShowLogMode implements Serializable {
    private List<LogModeElement> logModeElements;
    private List<ImageItem> photos;
    private String cat_id;//日志类型
    private String uid;//用户ID
    private String group_id;//组信息
    private int position;
    private String select_id;
    //private String weather_value="";

    public List<LogModeElement> getLogModeElements() {
        return logModeElements;
    }

    public void setLogModeElements(List<LogModeElement> logModeElements) {
        this.logModeElements = logModeElements;
    }

    public List<ImageItem> getPhotos() {
        return photos;
    }

    public void setPhotos(List<ImageItem> photos) {
        this.photos = photos;
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

//    public String getWeather_value() {
//        return weather_value;
//    }
//
//    public void setWeather_value(String weather_value) {
//        this.weather_value = weather_value;
//    }
}
