package com.jizhi.jlongg.main.listener;

/**
 * 功能: 添加人员回调
 * 作者：Xuj
 * 时间: 2016年9月2日 15:04:34
 */
public interface AddMemberListener {
    /**
     * 添加人员
     *
     * @param state 1.代表添加班组成员2.添加来源人
     */
    public void add(int state);

    /**
     * 删除人员
     *
     * @param state 1.代表添加班组成员 2.添加来源人
     */
    public void remove(int state);
}
