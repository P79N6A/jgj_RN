package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

public class MessageFailBean implements Serializable {
    private int is_source;
    private String local_id;

    public int getIs_source() {
        return is_source;
    }

    public void setIs_source(int is_source) {
        this.is_source = is_source;
    }

    public String getLocal_id() {
        return local_id;
    }

    public void setLocal_id(String local_id) {
        this.local_id = local_id;
    }
}
