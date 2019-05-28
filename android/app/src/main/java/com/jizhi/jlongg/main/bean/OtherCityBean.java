package com.jizhi.jlongg.main.bean;

public class OtherCityBean {
    /** 该城市多少个工作 */
    private int pronum;


    private int workernum;;
    /** 城市 */
    private String[] shortname;
    /** 市级编码 */
    private String city_code;

    public int getPronum() {
        return pronum;
    }

    public void setPronum(int pronum) {
        this.pronum = pronum;
    }

    public String[] getShortname() {
        return shortname;
    }

    public void setShortname(String[] shortname) {
        this.shortname = shortname;
    }

    public String getCity_code() {
        return city_code;
    }

    public void setCity_code(String city_code) {
        this.city_code = city_code;
    }

    public int getWorkernum() {
        return workernum;
    }

    public void setWorkernum(int workernum) {
        this.workernum = workernum;
    }
}
