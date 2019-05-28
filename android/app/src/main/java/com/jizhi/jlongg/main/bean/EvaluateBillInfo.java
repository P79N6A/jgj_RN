package com.jizhi.jlongg.main.bean;

/**
 * Created by Administrator on 2018-4-25.
 */

public class EvaluateBillInfo {
    /**
     * 点工信息
     */
    private WorkBaseInfo work_type;
    /**
     * 包工承包信息
     */
    private WorkBaseInfo contract_type_one;
    /**
     * 包工分包信息
     */
    private WorkBaseInfo contract_type_two;
    /**
     * 借支信息
     */
    private WorkBaseInfo expend_type;
    /**
     * 结算信息
     */
    private WorkBaseInfo balance_type;
    /**
     * 未结工资
     */
    private WorkBaseInfo unbalance_type;

    public WorkBaseInfo getWork_type() {
        return work_type;
    }

    public void setWork_type(WorkBaseInfo work_type) {
        this.work_type = work_type;
    }


    public WorkBaseInfo getExpend_type() {
        return expend_type;
    }

    public void setExpend_type(WorkBaseInfo expend_type) {
        this.expend_type = expend_type;
    }

    public WorkBaseInfo getBalance_type() {
        return balance_type;
    }

    public void setBalance_type(WorkBaseInfo balance_type) {
        this.balance_type = balance_type;
    }

    public WorkBaseInfo getUnbalance_type() {
        return unbalance_type;
    }

    public void setUnbalance_type(WorkBaseInfo unbalance_type) {
        this.unbalance_type = unbalance_type;
    }

    public WorkBaseInfo getContract_type_one() {
        return contract_type_one;
    }

    public void setContract_type_one(WorkBaseInfo contract_type_one) {
        this.contract_type_one = contract_type_one;
    }

    public WorkBaseInfo getContract_type_two() {
        return contract_type_two;
    }

    public void setContract_type_two(WorkBaseInfo contract_type_two) {
        this.contract_type_two = contract_type_two;
    }
}
