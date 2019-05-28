package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

public class ItemClickBean implements Serializable {
    // 1.复制  2.重发 3.删除  4.撤回
    private int id;
    private String context;

    public ItemClickBean(int id, String context) {
        this.id = id;
        this.context = context;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getContext() {
        return context;
    }

    public void setContext(String context) {
        this.context = context;
    }
}
