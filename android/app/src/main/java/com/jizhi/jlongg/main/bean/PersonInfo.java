package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 人物电话、名称
 * huchangsheng：Administrator on 2016/2/22 14:41
 */
public class PersonInfo implements Serializable {

    /**
     * 发布人名称
     */
    private String fmname;
    /**
     * 发布人电话
     */
    private String telph;

    public String getFmname() {
        return fmname;
    }

    public void setFmname(String fmname) {
        this.fmname = fmname;
    }

    public String getTelph() {
        return telph;
    }

    public void setTelph(String telph) {
        this.telph = telph;
    }
}
