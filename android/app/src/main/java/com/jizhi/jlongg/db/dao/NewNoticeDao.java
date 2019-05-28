package com.jizhi.jlongg.db.dao;

import android.content.Context;

import com.jizhi.jlongg.main.bean.NewMessage;

import java.util.List;

/**
 * 功能: 新通知
 * 作者：Xuj
 * 时间: 2016-8-31 10:31
 */
public interface NewNoticeDao {
    /**
     * 获取新通知列表数据
     */
    public List<NewMessage> getAllMessage(Context context);

    /**
     * 保存多条新通知列表数据
     *
     * @param list 需要保存的列表
     */
    public void saveNoticeMultiData(List<NewMessage> list, String uid);

    /**
     * 保存单条新通知列表数据
     *
     * @param bean 需要保存的对象
     */
    public void saveNoticeSingleData(NewMessage bean, String uid);

    /**
     * 当前记录是否存在
     *
     * @param bean
     * @return
     */
    public boolean isExistNoticeId(NewMessage bean, String uid);

    /**
     * 修改列表状态
     *
     * @param noticeId
     * @param classType
     */
    public void updateGroupType(int noticeId, String classType);

    /**
     * 移除对象
     *
     * @param bean
     */
    public void remove(NewMessage bean);

    /**
     * 修改支付状态
     *
     * @param noticeId
     */
    public void updatePayState(String noticeId);

    /**
     * 修改项目组名称
     *
     * @param bean
     */
    public void updateGroupName(NewMessage bean, String updateName);


    /**
     * 设置同步标识
     *
     * @param noticeId
     * @param syncTag 主要是同步的时候使用  0表示还未操作 1表示同步成功 2表示拒绝
     */
    public void setSyncTag(String noticeId, int syncTag);

}
