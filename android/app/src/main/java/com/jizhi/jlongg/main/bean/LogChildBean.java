package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Administrator on 2017/7/20 0020.
 */

public class LogChildBean implements Serializable {

    private int id;
    private List<String> imgs;
    private String show_list_content;
    private String create_time;
    private String cat_name;
    private UserInfo user_info;
    private int is_old_data;

    public int getIs_old_data() {
        return is_old_data;
    }

    public void setIs_old_data(int is_old_data) {
        this.is_old_data = is_old_data;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public List<String> getImgs() {
        return imgs;
    }

    public void setImgs(List<String> imgs) {
        this.imgs = imgs;
    }

    public String getShow_list_content() {
        return show_list_content;
    }

    public void setShow_list_content(String show_list_content) {
        this.show_list_content = show_list_content;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public String getCat_name() {
        return cat_name;
    }

    public void setCat_name(String cat_name) {
        this.cat_name = cat_name;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }
}
