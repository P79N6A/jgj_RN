package com.jizhi.jlongg.main.bean;

/**
 * 数据来源人  项目组数据源
 */
public class SourceMemberProCount extends UserInfo {

    /**
     * 已处理数据来源人个数
     */
    private int sync_source_person_count;
    /**
     * 未处理数据来源人个数
     */
    private int sync_unsource_person_count;


    public int getSync_source_person_count() {
        return sync_source_person_count;
    }

    public void setSync_source_person_count(int sync_source_person_count) {
        this.sync_source_person_count = sync_source_person_count;
    }

    public int getSync_unsource_person_count() {
        return sync_unsource_person_count;
    }

    public void setSync_unsource_person_count(int sync_unsource_person_count) {
        this.sync_unsource_person_count = sync_unsource_person_count;
    }
}
