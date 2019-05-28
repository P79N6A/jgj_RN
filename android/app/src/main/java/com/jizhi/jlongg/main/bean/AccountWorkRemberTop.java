package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * 记工流水2.3.7
 */

public class AccountWorkRemberTop {
    /*点工*/
    private WorkBaseInfo work_type;
    /*包工*/
    private WorkBaseInfo contract_type;
    /*借支*/
    private WorkBaseInfo expend_type;
    /*结算*/
    private WorkBaseInfo balance_type;
    /*包工记工天*/
    private WorkBaseInfo attendance_type;
    private List<AccountWorkRember> list;
    //本月一共记工笔数
    private int total_num;
    //包工承包
    private WorkBaseInfo contract_type_one;
    //包工分包
    private WorkBaseInfo contract_type_two;

    public int getTotal_num() {
        return total_num;
    }

    public void setTotal_num(int total_num) {
        this.total_num = total_num;
    }

    public WorkBaseInfo getWork_type() {
        return work_type;
    }

    public void setWork_type(WorkBaseInfo work_type) {
        this.work_type = work_type;
    }

    public WorkBaseInfo getContract_type() {
        return contract_type;
    }

    public void setContract_type(WorkBaseInfo contract_type) {
        this.contract_type = contract_type;
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

    public List<AccountWorkRember> getList() {
        return list;
    }

    public void setList(List<AccountWorkRember> list) {
        this.list = list;
    }

    public WorkBaseInfo getAttendance_type() {
        return attendance_type;
    }

    public void setAttendance_type(WorkBaseInfo attendance_type) {
        this.attendance_type = attendance_type;
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
