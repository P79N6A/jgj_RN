package com.jizhi.jlongg.main.bean;

/**
 * 顶部菜单更多实体类
 */
public class DialogMoreBean {
    private int type;
    private String context;

    public DialogMoreBean(int type, String context) {
        this.type = type;
        this.context = context;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getContext() {
        return context;
    }

    public void setContext(String context) {
        this.context = context;
    }
}
