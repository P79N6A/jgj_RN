package com.jizhi.jlongg.main.listener;

/**
 * 功能:重新打开已关闭讨论组、班组
 * 作者：Xuj
 * 时间: 2016年9月6日 15:39:46
 */
public interface ReOpenCloseTeamListener {

    /**
     * 重新打开讨论组、项目组
     * @param groupId
     * @param classType
     */
    public void reOpen(String groupId,String classType);
}
