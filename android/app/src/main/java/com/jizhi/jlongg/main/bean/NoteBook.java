package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 记事本 2018/4/19 0019.
 */

public class NoteBook implements Serializable{
    //编号
    private String id;
    //时间
    private String publish_time;
    //内容
    private String content;
    //星期
    private String weekday;
    //图片信息
    private List<String> images;
    //有重要的笔记
    private int is_import;
    //日期
    private int date;

    public List<String> getImages() {
        return images;
    }

    public void setImages(List<String> images) {
        this.images = images;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPublish_time() {
        return publish_time;
    }

    public void setPublish_time(String publish_time) {
        this.publish_time = publish_time;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getWeekday() {
        return weekday;
    }

    public void setWeekday(String weekday) {
        this.weekday = weekday;
    }

    public int getIs_import() {
        return is_import;
    }

    public void setIs_import(int is_import) {
        this.is_import = is_import;
    }

    public int getDate() {
        return date;
    }

    public void setDate(int date) {
        this.date = date;
    }
}
