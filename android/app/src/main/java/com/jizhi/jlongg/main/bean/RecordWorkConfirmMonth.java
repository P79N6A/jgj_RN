package com.jizhi.jlongg.main.bean;

/**
 * CName:待确认记工清单第二层
 * User: xuj
 * Date: 2017年9月28日
 * Time: 11:38:44
 */
public class RecordWorkConfirmMonth extends WorkDetail {
    /**
     * 是否是今天或者昨天的描述
     */
    private String date_desc;
    /**
     * 农历
     */
    private String date_turn;
    /**
     * 1新增 2修改；3删除
     */
    private int record_type;
    /**
     * 记账类型描述
     */
    private String record_desc;
    /**
     * 创建时间 字符串
     */
    private String format_create_time;
    /**
     * 创建时间  时间戳格式
     */
    private long create_time;
    /**
     * 添加字段 ，用于确认列表 的排序
     */
    private long date_strtotime;
    /**
     * 如果 workday/wait-confirm-list 中 is_diff_pro = 1 ，确认列表中的，显示oth_proname中的值
     */
    private int is_diff_pro;
    /**
     *
     */
    private String oth_proname;


    public String getDate_turn() {
        return date_turn;
    }

    public void setDate_turn(String date_turn) {
        this.date_turn = date_turn;
    }

    public String getDate_desc() {
        return date_desc;
    }

    public void setDate_desc(String date_desc) {
        this.date_desc = date_desc;
    }

    public int getRecord_type() {
        return record_type;
    }

    public void setRecord_type(int record_type) {
        this.record_type = record_type;
    }

    public String getRecord_desc() {
        return record_desc;
    }

    public void setRecord_desc(String record_desc) {
        this.record_desc = record_desc;
    }

    public String getFormat_create_time() {
        return format_create_time;
    }

    public void setFormat_create_time(String format_create_time) {
        this.format_create_time = format_create_time;
    }

    public long getCreate_time() {
        return create_time;
    }

    public void setCreate_time(long create_time) {
        this.create_time = create_time;
    }

    public long getDate_strtotime() {
        return date_strtotime;
    }

    public void setDate_strtotime(long date_strtotime) {
        this.date_strtotime = date_strtotime;
    }

    public int getIs_diff_pro() {
        return is_diff_pro;
    }

    public void setIs_diff_pro(int is_diff_pro) {
        this.is_diff_pro = is_diff_pro;
    }

    public String getOth_proname() {
        return oth_proname;
    }

    public void setOth_proname(String oth_proname) {
        this.oth_proname = oth_proname;
    }
}
