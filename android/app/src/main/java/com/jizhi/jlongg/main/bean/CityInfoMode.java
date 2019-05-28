package com.jizhi.jlongg.main.bean;


/**
 * 城市数据信息
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-26 下午6:54:06
 */
public class CityInfoMode {
    private String city_code;
    private String city_name;
    private String city_provice;
    private String first_char;
    private String short_name;
    private String parent_id;
    private String city_url;
    private String uid;
    private int source;
    private String unit;

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public int getSource() {
        return source;
    }

    public void setSource(int source) {
        this.source = source;
    }

    public CityInfoMode() {
        super();
    }

    public CityInfoMode(String city_code, String city_name, String parent_id) {
        super();
        this.city_code = city_code;
        this.city_name = city_name;
        this.parent_id = parent_id;
    }


    public CityInfoMode(String city_name, String city_code) {
        super();
        this.city_name = city_name;
        this.city_code = city_code;
    }

    public String getCity_code() {
        return city_code;
    }

    public void setCity_code(String city_code) {
        this.city_code = city_code;
    }

    public String getCity_name() {
        return city_name;
    }

    public void setCity_name(String city_name) {
        this.city_name = city_name;
    }

    public String getFirst_char() {
        return first_char;
    }

    public void setFirst_char(String first_char) {
        this.first_char = first_char;
    }

    public String getShort_name() {
        return short_name;
    }

    public void setShort_name(String short_name) {
        this.short_name = short_name;
    }

    public String getParent_id() {
        return parent_id;
    }

    public void setParent_id(String parent_id) {
        this.parent_id = parent_id;
    }

    public String getCity_url() {
        return city_url;
    }

    public void setCity_url(String city_url) {
        this.city_url = city_url;
    }

//	public void setSortLetters(String sortLetters) {
//		this.sortLetters = sortLetters;
//	}


    @Override
    public String toString() {
        return "CityInfoMode{" +
                    "city_code='" + city_code + '\'' +
                    ", city_name='" + city_name + '\'' +
                    ", parent_id='" + parent_id + '\'' +
                    '}';
    }

    public String getCity_provice() {
        return city_provice;
    }

    public void setCity_provice(String city_provice) {
        this.city_provice = city_provice;
    }
}
