package com.jizhi.jlongg.main.bean;

/**
 * 找工作详情
 *
 * @author Xuj
 * @time 2018年6月19日17:48:42
 * @Version 1.0
 */
public class RecruitDetail {
    /**
     * 工种类型
     */
    private WorkType cooperate_type;
    /**
     * 项目类型
     */
    private WorkType pro_type;
    /**
     * 总价金额
     */
    private double money;
    /**
     * 规模
     */
    private double total_scale;
    /**
     * 包工的标识
     */
    private int contractor;
    /**
     * 单价金额
     */
    private double unitMoney;
    /**
     * 单位
     */
    private String balance_way;
    /**
     * 招工人数
     */
    private String person_count;


    public WorkType getCooperate_type() {
        return cooperate_type;
    }

    public void setCooperate_type(WorkType cooperate_type) {
        this.cooperate_type = cooperate_type;
    }

    public double getMoney() {
        return money;
    }

    public void setMoney(double money) {
        this.money = money;
    }

    public double getTotal_scale() {
        return total_scale;
    }

    public void setTotal_scale(double total_scale) {
        this.total_scale = total_scale;
    }

    public int getContractor() {
        return contractor;
    }

    public void setContractor(int contractor) {
        this.contractor = contractor;
    }

    public WorkType getPro_type() {
        return pro_type;
    }

    public void setPro_type(WorkType pro_type) {
        this.pro_type = pro_type;
    }

    public double getUnitMoney() {
        return unitMoney;
    }

    public void setUnitMoney(double unitMoney) {
        this.unitMoney = unitMoney;
    }

    public String getBalance_way() {
        return balance_way;
    }

    public void setBalance_way(String balance_way) {
        this.balance_way = balance_way;
    }

    public String getPerson_count() {
        return person_count;
    }

    public void setPerson_count(String person_count) {
        this.person_count = person_count;
    }
}
