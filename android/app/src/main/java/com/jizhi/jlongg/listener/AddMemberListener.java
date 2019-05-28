package com.jizhi.jlongg.listener;

/**
 * 功能:新建班组、人员管理
 * 作者：xuj
 * 时间: 2016年8月19日 11:11:34
 */
public interface AddMemberListener {
    /**
     * 添加人员
     *
     * @param state 1.代表添加班组成员2.添加来源人
     */
     void add(int state);

    /**
     * 删除人员
     *
     * @param state 1.代表添加班组成员 2.添加来源人
     */
     void remove(int state);
}

