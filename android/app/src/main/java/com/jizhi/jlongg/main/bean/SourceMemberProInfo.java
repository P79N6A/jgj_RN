package com.jizhi.jlongg.main.bean;

/**
 * Created by Administrator on 2016/11/11 0011.
 */

public class SourceMemberProInfo extends UserInfo {

    /**
     * 未作为源的项目组
     */
    private SourceMemberProList sync_unsource;
    /**
     * 已经作为源的项目组
     */
    private SourceMemberProList sync_source;
    /**
     * 要求同步标识
     */
    private int is_demand;

    public SourceMemberProList getSync_unsource() {
        return sync_unsource;
    }

    public void setSync_unsource(SourceMemberProList sync_unsource) {
        this.sync_unsource = sync_unsource;
    }

    public SourceMemberProList getSync_source() {
        return sync_source;
    }

    public void setSync_source(SourceMemberProList sync_source) {
        this.sync_source = sync_source;
    }

    public int getIs_demand() {
        return is_demand;
    }

    public void setIs_demand(int is_demand) {
        this.is_demand = is_demand;
    }
}
