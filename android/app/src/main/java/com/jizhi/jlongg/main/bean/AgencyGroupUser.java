package com.jizhi.jlongg.main.bean;

public class AgencyGroupUser extends UserInfo {
    /**
     * 设置代班长开始时间
     */
    private String start_time;
    /**
     * 设置代班长结束时间
     */
    private String end_time;
    /**
     * 时间是否已过期
     */
    private int is_expire;
    /**
     * 1表示已开始代班记工时间
     */
    private int is_start;
    /**
     * 代班长记账时间
     */
    private String record_time;
    /**
     * 所属的班组id
     */
    private String group_id;

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getRecord_time() {
        return record_time;
    }

    public void setRecord_time(String record_time) {
        this.record_time = record_time;
    }

    public String getStart_time() {
        return start_time;
    }

    public void setStart_time(String start_time) {
        this.start_time = start_time;
    }

    public String getEnd_time() {
        return end_time;
    }

    public void setEnd_time(String end_time) {
        this.end_time = end_time;
    }

    public int getIs_expire() {
        return is_expire;
    }

    public void setIs_expire(int is_expire) {
        this.is_expire = is_expire;
    }

    public int getIs_start() {
        return is_start;
    }

    public void setIs_start(int is_start) {
        this.is_start = is_start;
    }


}
