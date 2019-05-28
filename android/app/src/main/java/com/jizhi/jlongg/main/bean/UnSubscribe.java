package com.jizhi.jlongg.main.bean;

/**
 * Created by Administrator on 2018-6-7.
 */

public class UnSubscribe {
    /**
     * 注销原因
     */
    private String name;
    /**
     * 是否选中
     */
    private boolean is_selected;
    /**
     * 注销id
     */
    private int code;


    public boolean is_selected() {
        return is_selected;
    }

    public void setIs_selected(boolean is_selected) {
        this.is_selected = is_selected;
    }


    public UnSubscribe() {
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

}
