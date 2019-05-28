package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 记功类型
 * huchangsheng：Administrator on 2016/2/22 14:41
 */
public class RecordAccount extends WorkBaseInfo implements Serializable {
    /**
     * 工作日 (返回格式为12)
     */
    private int date;
    /**
     * 表示有点工,包工记工天
     */
    private int is_record;
    /**
     * 别人是否对我已记工
     */
    private int is_record_to_me;
    /**
     * 如果当前项目成员在其他项目中已记录过点工信息 则msg不为空
     */
    private BatchAccountOtherProInfo msg;
    /**
     * 1休息表示。 2:表示包工   v3.4.2
     */
    private int rwork_type;
    /**
     * 3:表示借支；4:结算  v3.4.2
     */
    private int awork_type;
    /**
     * 如果is_double = 0，则判断accounts_type 是否 当前的记工类型,如果不等，返回提示语
     */
    private int accounts_type;
    /**
     * 一人计多天界面，判断是否记了两笔,优先级高于accounts_type
     */
    private int is_double;

    public int getDate() {
        return date;
    }

    public void setDate(int date) {
        this.date = date;
    }


    public BatchAccountOtherProInfo getMsg() {
        return msg;
    }

    public void setMsg(BatchAccountOtherProInfo msg) {
        this.msg = msg;
    }

    public int getIs_notes() {
        return is_notes;
    }

    public void setIs_notes(int is_notes) {
        this.is_notes = is_notes;
    }

    public int getIs_record() {
        return is_record;
    }

    public void setIs_record(int is_record) {
        this.is_record = is_record;
    }

    public int getRwork_type() {
        return rwork_type;
    }

    public void setRwork_type(int rwork_type) {
        this.rwork_type = rwork_type;
    }

    public int getAwork_type() {
        return awork_type;
    }

    public void setAwork_type(int awork_type) {
        this.awork_type = awork_type;
    }


    public int getIs_double() {
        return is_double;
    }

    public void setIs_double(int is_double) {
        this.is_double = is_double;
    }

    public int getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(int accounts_type) {
        this.accounts_type = accounts_type;
    }

    public int getIs_record_to_me() {
        return is_record_to_me;
    }

    public void setIs_record_to_me(int is_record_to_me) {
        this.is_record_to_me = is_record_to_me;
    }
}
