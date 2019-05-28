package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 签到对象
 */
public class SignBean implements Serializable{
    //我的签到信息
    private SignMyInfoBean myself;
    //签到信息
    private List<SignListBean> list;

    public SignMyInfoBean getMyself() {
        return myself;
    }

    public void setMyself(SignMyInfoBean myself) {
        this.myself = myself;
    }

    public List<SignListBean> getList() {
        return list;
    }

    public void setList(List<SignListBean> list) {
        this.list = list;
    }
}
