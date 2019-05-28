package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

public class Region implements Serializable {
    /**
     * 城市编号
     */
    private int code;
    /**
     * 城市名称
     */
    private List<String> name;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public List<String> getName() {
        return name;
    }

    public void setName(List<String> name) {
        this.name = name;
    }

}
