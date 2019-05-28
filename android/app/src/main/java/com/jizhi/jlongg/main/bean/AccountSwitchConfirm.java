package com.jizhi.jlongg.main.bean;

/**
 * 我要对账属性
 */
public class AccountSwitchConfirm extends BaseNetBean {
    /**
     * 对账开关
     */
    private int status;  //表示关闭 ；0:表示开启

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
