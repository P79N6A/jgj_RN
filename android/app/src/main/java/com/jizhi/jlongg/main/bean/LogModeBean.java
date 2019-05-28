package com.jizhi.jlongg.main.bean;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * CName:日志模版bean
 * User: hcs
 * Date: 2017-07-21
 * Time: 10:28
 */

public class LogModeBean implements Serializable {
    private int id;
    private String cat_id;
    private String element_name;
    private String element_type;
    private int element_type_number;
    private String length_range;
    private int is_require;//是否必填
    private String is_show_list;
    private String create_time;
    private String element_key;
    private String element_unit;
    private String date_type;
    private int decimal_place;//小树位数
    private List<ProjectLevel> select_value_list;
    private List<ProjectLevel> list;
    private List<LogModeBean> element_list;
    private String element_value;
    private String element_id;
    private UserInfo user_info;
    private String msg_id;
    private String group_id;
    private String class_type;
    private String from_group_name;
    private WeatherInfo weather_info;
    private String weather_value;
    private String select_id;
    private int position;
    private List<String> msg_src;
    private DateAndTime dateAndTime;
    private String week_day;
    private String cat_name;
    private LogReceiver receiver_list;

    public LogReceiver getReceiver_list() {
        return receiver_list;
    }

    public void setReceiver_list(LogReceiver receiver_list) {
        this.receiver_list = receiver_list;
    }

    public String getCat_name() {
        return cat_name;
    }

    public void setCat_name(String cat_name) {
        this.cat_name = cat_name;
    }

    public String getWeek_day() {
        return week_day;
    }

    public void setWeek_day(String week_day) {
        this.week_day = week_day;
    }

    private int is_replyed;

    public int getIs_replyed() {
        return is_replyed;
    }

    public void setIs_replyed(int is_replyed) {
        this.is_replyed = is_replyed;
    }

    public List<String> getMsg_src() {
        return msg_src;
    }

    public void setMsg_src(List<String> msg_src) {
        this.msg_src = msg_src;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public String getSelect_id() {
        return select_id;
    }

    public void setSelect_id(String select_id) {
        this.select_id = select_id;
    }

    public String getWeather_value() {
        return weather_value;
    }

    public void setWeather_value(String weather_value) {
        this.weather_value = weather_value;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public WeatherInfo getWeather_info() {
        return weather_info;
    }

    public void setWeather_info(WeatherInfo weather_info) {
        this.weather_info = weather_info;
    }

    public String getMsg_id() {
        return msg_id;
    }

    public void setMsg_id(String msg_id) {
        this.msg_id = msg_id;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getFrom_group_name() {
        return from_group_name;
    }

    public void setFrom_group_name(String from_group_name) {
        this.from_group_name = from_group_name;
    }

    public String getElement_id() {
        return element_id;
    }

    public void setElement_id(String element_id) {
        this.element_id = element_id;
    }

    public List<LogModeBean> getElement_list() {
        return element_list;
    }

    public void setElement_list(List<LogModeBean> element_list) {
        this.element_list = element_list;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public String getElement_value() {
        return element_value;
    }

    public void setElement_value(String element_value) {
        this.element_value = element_value;
    }

    public int getElement_type_number() {
        return element_type_number;
    }

    public void setElement_type_number(int element_type_number) {
        this.element_type_number = element_type_number;
    }

    public String getElement_key() {
        return element_key;
    }

    public void setElement_key(String element_key) {
        this.element_key = element_key;
    }

    public String getElement_unit() {
        return element_unit;
    }

    public void setElement_unit(String element_unit) {
        this.element_unit = element_unit;
    }

    public String getDate_type() {
        return date_type;
    }

    public void setDate_type(String date_type) {
        this.date_type = date_type;
    }

    public int getDecimal_place() {
        return decimal_place;
    }

    public void setDecimal_place(int decimal_place) {
        this.decimal_place = decimal_place;
    }


    public String getCat_id() {
        return cat_id;
    }

    public void setCat_id(String cat_id) {
        this.cat_id = cat_id;
    }

    public String getElement_name() {
        return element_name;
    }

    public void setElement_name(String element_name) {
        this.element_name = element_name;
    }

    public String getElement_type() {
        return element_type;
    }

    public void setElement_type(String element_type) {
        this.element_type = element_type;
    }

    public String getLength_range() {
        return length_range;
    }

    public void setLength_range(String length_range) {
        this.length_range = length_range;
    }

    public int getIs_require() {
        return is_require;
    }

    public void setIs_require(int is_require) {
        this.is_require = is_require;
    }

    public String getIs_show_list() {
        return is_show_list;
    }

    public void setIs_show_list(String is_show_list) {
        this.is_show_list = is_show_list;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public List<ProjectLevel> getSelect_value_list() {
        return select_value_list;
    }

    public void setSelect_value_list(List<ProjectLevel> select_value_list) {
        this.select_value_list = select_value_list;
    }

    public List<ProjectLevel> getList() {
        if (null == list) {
            list = new ArrayList<>();
        }
        return list;
    }

    public void setList(List<ProjectLevel> list) {
        this.list = list;
    }

    public DateAndTime getDateAndTime() {
        if (null == dateAndTime) {
            dateAndTime = new DateAndTime();
        }
        return dateAndTime;
    }

    public void setDateAndTime(DateAndTime dateAndTime) {
        this.dateAndTime = dateAndTime;
    }
}
