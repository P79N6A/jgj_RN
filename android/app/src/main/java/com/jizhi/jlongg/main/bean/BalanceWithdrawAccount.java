package com.jizhi.jlongg.main.bean;


import java.util.List;

/**
 * 余额提现
 *
 * @author Xuj
 * @time 2017年7月20日14:25:04
 * @Version 1.0
 */
public class BalanceWithdrawAccount extends UserInfo {

    /**
     * 账户id
     */
    private int id;
    /**
     * 列表数据
     */
    private List<BalanceWithdrawAccount> list;
    /**
     * 1是微信、2为支付宝
     */
    private int pay_type;
    /**
     * 正在使用 1 未使用为0
     */
    private int is_use;
    /**
     * 账户名称
     */
    private String account_name;
    /**
     * 账户金额
     */
    private float amount;

    public int getPay_type() {
        return pay_type;
    }

    public void setPay_type(int pay_type) {
        this.pay_type = pay_type;
    }


    public String getAccount_name() {
        return account_name;
    }

    public void setAccount_name(String account_name) {
        this.account_name = account_name;
    }

    public List<BalanceWithdrawAccount> getList() {
        return list;
    }

    public void setList(List<BalanceWithdrawAccount> list) {
        this.list = list;
    }

    public float getAmount() {
        return amount;
    }

    public void setAmount(float amount) {
        this.amount = amount;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIs_use() {
        return is_use;
    }

    public void setIs_use(int is_use) {
        this.is_use = is_use;
    }
}
