package com.jizhi.jlongg.main.listener;


import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.Project;

import java.util.ArrayList;

/**
 * 功能: 数据来源人数据回调
 * 作者：Xuj
 * 时间: 2016年9月2日 15:04:34
 */
public interface SourceMemberListener {
    /**
     * 移除单个现项目组源
     */
    public void removeSource(Project project);
    /**
     * 要求同步项目组
     */
    public void requestPro();
    /**
     * 关联到本组
     */
    public void correlation();
    /**
     * 点击名称去到查看资料
     */
    public void clickName();
    /**
     * 拨打电话
     */
    public void callPhone();
}
