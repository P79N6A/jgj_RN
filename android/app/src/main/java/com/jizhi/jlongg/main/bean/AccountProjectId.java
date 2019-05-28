package com.jizhi.jlongg.main.bean;

import org.litepal.crud.LitePalSupport;

import java.io.Serializable;

/**
 * 存储工头记账对于新班组需要弹窗
 */
public class AccountProjectId extends LitePalSupport implements Serializable {
    private int pid;

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }
    @Override
    public boolean equals(Object o) {
        if (o instanceof AccountProjectId) {
            AccountProjectId bean = (AccountProjectId) o;
            return this.pid == bean.getPid();
        }
        return super.equals(o);
    }
}
