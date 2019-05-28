package com.jizhi.jlongg.main.bean;

import org.litepal.annotation.Column;
import org.litepal.crud.LitePalSupport;

import java.io.Serializable;

/**
 * 功能:工种详情
 * 时间:2016-4-18 19:30
 * 作者:xuj
 */
public class WorkInfomation extends LitePalSupport implements Serializable {
    /**
     * 合作类型，1是点工，2是包工，3是总包
     */
    private CooperateType cooperate_type;
    /**
     * 金额
     */
    private float money;
    /**
     * 金额
     */
    private String max_money;
    /**
     * 计价单位
     */
    private String balance_way;
    /**
     * 总规模
     */
    private String total_scale;
    /**
     * 开工时间
     */
    private String work_begin;
//    /**
//     * 工种熟练度
//     */
//    @Column(ignore = true)
//    private WorkLevel work_level;
//    /**
//     * 工种类型
//     */
//    @Column(ignore = true)
//    private WorkType work_type;
    /**
     * 所需人数
     */
    @Column(ignore = true)
    private String person_count;
    /**
     * 包工类型1按总包显示、2按点工显示
     */
    @Column(ignore = true)
    private int contractor;

    public String getWork_begin() {
        return work_begin;
    }

    public void setWork_begin(String work_begin) {
        this.work_begin = work_begin;
    }

    public String getBalance_way() {
        return balance_way;
    }

    public void setBalance_way(String balance_way) {
        this.balance_way = balance_way;
    }
//
//    public WorkLevel getWork_level() {
//        return work_level;
//    }
//
//    public void setWork_level(WorkLevel work_level) {
//        this.work_level = work_level;
//    }
//
//    public WorkType getWork_type() {
//        return work_type;
//    }
//
//    public void setWork_type(WorkType work_type) {
//        this.work_type = work_type;
//    }

    public CooperateType getCooperate_type() {
        return cooperate_type;
    }

    public void setCooperate_type(CooperateType cooperate_type) {
        this.cooperate_type = cooperate_type;
    }


    public void setMoney(int money) {
        this.money = money;
    }

    public String getPerson_count() {
        return person_count;
    }

    public void setPerson_count(String person_count) {
        this.person_count = person_count;
    }


    public int getContractor() {
        return contractor;
    }

    public void setContractor(int contractor) {
        this.contractor = contractor;
    }

    public float getMoney() {
        return money;
    }

    public void setMoney(float money) {
        this.money = money;
    }

    public String getTotal_scale() {
        return total_scale;
    }

    public void setTotal_scale(String total_scale) {
        this.total_scale = total_scale;
    }

    public String getMax_money() {
        return max_money;
    }

    public void setMax_money(String max_money) {
        this.max_money = max_money;
    }
}
