package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 批量记账多人
 *
 * @author xuj
 * @version 1.0
 * @time 2017年2月16日15:18:48
 */
public class BatchAccount implements Serializable {


    public static final String UN_ACCOUNT_STRING = "unaccount"; //未记账
    public static final String ACCOUNTED_STRING = "accounted"; //已记账


    /**
     * unaccount未记账  accounted  已记账
     */
    private String type;
    /**
     * 记账人数
     */
    private int account_num;
    /**
     * 上次记账的类型
     * 1是点工
     * 5是包工考勤
     */
    private int last_accounts_type;
    /**
     * 记账集合
     */
    private List<BatchAccountDetail> list;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getAccount_num() {
        return account_num;
    }

    public void setAccount_num(int account_num) {
        this.account_num = account_num;
    }

    public List<BatchAccountDetail> getList() {
        return list;
    }

    public void setList(List<BatchAccountDetail> list) {
        this.list = list;
    }

    public int getLast_accounts_type() {
        return last_accounts_type;
    }

    public void setLast_accounts_type(int last_accounts_type) {
        this.last_accounts_type = last_accounts_type;
    }
}
