package com.jizhi.jlongg.main.bean;

/**
 * CName:推荐列表
 * User: hcs
 * Date: 2016-07-04
 * Time: 11:12
 */
public class Recommend {

    private String title;
    private String content;
    private int icon;
    private String url;

    public Recommend() {
    }

    public Recommend(String title, String content, int icon, String url) {
        this.title = title;
        this.content = content;
        this.icon = icon;
        this.url = url;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getIcon() {
        return icon;
    }

    public void setIcon(int icon) {
        this.icon = icon;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
