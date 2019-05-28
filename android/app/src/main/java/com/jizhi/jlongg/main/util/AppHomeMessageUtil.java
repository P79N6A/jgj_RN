package com.jizhi.jlongg.main.util;

import com.jizhi.jlongg.main.bean.ChatMainInfo;
import com.jizhi.jlongg.main.bean.WorkCircleMessageMenu;

public class AppHomeMessageUtil {


    /**
     * 清空 点击模块消息未读数 比如点击首页的质量，日志等模块 需要将本地的表的未读数设置为0
     *
     * @param chatMainInfo 消息数据
     * @param clickMsgType 点击的消息类型 取值的范围 参考一下实现方法的类型
     */
    private void clearClickModuleMessageCount(ChatMainInfo chatMainInfo, int clickMsgType) {
        if (chatMainInfo == null) {
            return;
        }
        switch (clickMsgType) {
            case WorkCircleMessageMenu.QUALITY: //清空质量消息数
                chatMainInfo.setUnread_quality_count(0);
                break;
            case WorkCircleMessageMenu.SAFETY: //清空安全消息数
                chatMainInfo.setUnread_safe_count(0);
                break;
            case WorkCircleMessageMenu.CHECK: //清空检查消息数
                chatMainInfo.setUnread_inspect_count(0);
                break;
            case WorkCircleMessageMenu.TASK: //清空任务消息数
                chatMainInfo.setUnread_task_count(0);
                break;
            case WorkCircleMessageMenu.NOTICE: //清空通知消息数
                chatMainInfo.setUnread_notice_count(0);
                break;
            case WorkCircleMessageMenu.SIGN:  //清空签到消息数
                chatMainInfo.setUnread_sign_count(0);
                break;
            case WorkCircleMessageMenu.EXAMINATION: //清空审批消息数
                chatMainInfo.setUnread_approval_count(0);
                break;
            case WorkCircleMessageMenu.LOG:  //清空日志消息数
                chatMainInfo.setUnread_log_count(0);
                break;
        }
        chatMainInfo.save();
    }

}
