package com.jizhi.jlongg.main.bean;

/**
 * CName:
 * User: hcs
 * Date: 2016-04-15
 * Time: 16:24
 */
public class Welfare {
    /**
     * 福利名称
     */
    private String name;
    /**
     * 编码
     */
    private int code;


    private String welfareName;
    private boolean isChecked;

    public Welfare(String welfareName, boolean isChecked) {
        this.welfareName = welfareName;
        this.isChecked = isChecked;
    }

    public String getWelfareName() {
        return welfareName;
    }

    public void setWelfareName(String welfareName) {
        this.welfareName = welfareName;
    }

    public boolean isChecked() {
        return isChecked;
    }

    public void setIsChecked(boolean isChecked) {
        this.isChecked = isChecked;
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
