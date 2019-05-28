package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 工资清单 项目名称详情
 * huchangsheng：Xuj on 2016/2/22 14:41
 */
public class PayRollProList implements Serializable {

    /**
     * 本月应收、应付
     */
    private float total_month;
    /**
     * 上班时长
     */
    private String total_manhour;
    /**
     * 加班时长
     */
    private String total_over;
    /**
     * 列表数据
     */
    private List<PayRollList> list;
    /**
     * 工资清单每日详情
     */
    private List<PayRollList> workday;
    /**
     * 新记账月 对象
     */
    private AccountUtil new_total_month;


    public float getTotal_month() {
        return total_month;
    }

    public void setTotal_month(float total_month) {
        this.total_month = total_month;
    }

    public List<PayRollList> getList() {
        return list;
    }

    public void setList(List<PayRollList> list) {
        this.list = list;
    }

    public String getTotal_manhour() {
        return total_manhour;
    }

    public void setTotal_manhour(String total_manhour) {
        this.total_manhour = total_manhour;
    }

    public String getTotal_over() {
        return total_over;
    }

    public void setTotal_over(String total_over) {
        this.total_over = total_over;
    }

    public List<PayRollList> getWorkday() {
        return workday;
    }

    public void setWorkday(List<PayRollList> workday) {
        this.workday = workday;
    }

    public AccountUtil getNew_total_month() {
        return new_total_month;
    }

    public void setNew_total_month(AccountUtil new_total_month) {
        this.new_total_month = new_total_month;
    }
}
