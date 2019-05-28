package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * CName:
 * User: hcs
 * Date: 2016-08-17
 * Time: 18:45
 */
public class HelpCenterInfo implements Serializable {

    private String desc;//所属大类描述
    private int main_id;//帮助信息的id
    private String title;//帮助信息的 title
    private String content;//帮助信息的 content
    private List<HelpCenterInfo> list;

    public List<HelpCenterInfo> getList() {
        return list;
    }

    public void setList(List<HelpCenterInfo> list) {
        this.list = list;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public int getMain_id() {
        return main_id;
    }

    public void setMain_id(int main_id) {
        this.main_id = main_id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
