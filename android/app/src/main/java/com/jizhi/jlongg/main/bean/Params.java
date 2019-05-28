package com.jizhi.jlongg.main.bean;

import com.jizhi.jlongg.main.util.Constance;

import java.io.Serializable;

/**
 * 参数类型
 * xuj：2016年3月8日 12:50:40
 */
public class Params implements Serializable {
    /** */
    private String value;

    private String key;

    /** type 默认为String */
    private String type = Constance.BEAN_STRING;

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }


    public Params(String key,String value){
        this.key = key;
        this.value = value;
    }

    public Params(String key,String value,String type){
        this.key = key;
        this.value = value;
        this.type = type;
    }
}
