package com.jizhi.jlongg.main.listener;


import com.jizhi.jlongg.main.bean.NewMessage;

/**
 * 功能: 新通知
 * 作者：Xuj
 * 时间: 2016-9-9 16:16
 */
public interface NoticeOperateListener {
    public void remove(NewMessage bean);//移除通知

    public void refuse(NewMessage bean, int syncType);//拒绝同步

    public void into(NewMessage bean);  //进入班组

    public void renew(NewMessage bean); //续期

    public void audit(NewMessage bean); //审核认证
}
