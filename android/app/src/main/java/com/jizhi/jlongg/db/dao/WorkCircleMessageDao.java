package com.jizhi.jlongg.db.dao;

import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;

import java.util.List;

/**
 * 功能: 聊天记录存储
 * 作者：Xuj
 * 时间: 2016-8-31 10:31
 */
public interface WorkCircleMessageDao {
    /**
     * 获取项目缓存数据
     */
    public List<GroupDiscussionInfo> getWorkCircleCasheData();

    /**
     * 保存单条项目数据、方便下次缓存中调用
     */
    public void saveWorkCircleSingleData(GroupDiscussionInfo bean);

    /**
     * 保存多条项目数据、方便下次缓存中调用
     */
    public void saveWorkCircleMultiData(List<GroupDiscussionInfo> list);


    /**
     * 获取已关闭班组缓存数据
     */
    public void getAlreadClosedCasheData();
}
