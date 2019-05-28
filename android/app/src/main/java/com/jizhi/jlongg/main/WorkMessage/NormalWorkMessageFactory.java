package com.jizhi.jlongg.main.WorkMessage;

import com.jizhi.jlongg.main.msg.MessageType;


public class NormalWorkMessageFactory implements WorkMessageContentFactory {

    /**
     * 获取普通的工作消息类型
     *
     * @param messageType 消息类型
     * @param messageFrom 消息来自
     * @param messageTo   消息到
     */
    @Override
    public String createMessageContent(String messageType, String messageFrom, String messageTo, String messageDetail, int status, boolean isModify, String classType) {
        switch (messageType) {
            case MessageType.MSG_QUALITY_STRING: //质量
                return new HandlderQualitySafeWorkMessageContent().getCommonWorkMessage(messageFrom, messageTo, messageDetail, status, isModify);
            case MessageType.MSG_SAFE_STRING: //安全
                return new HandlderQualitySafeWorkMessageContent().getCommonWorkMessage(messageFrom, messageTo, messageDetail, status, isModify);
            case MessageType.MSG_NOTICE_STRING: //通知
                return new HandlderNoticeWorkMessageContent().getCommonWorkMessage(messageFrom, messageTo, messageDetail, status, isModify);
            case MessageType.MSG_METTING_STRING: //会议
                return new HandlderMettingWorkMessageContent().getCommonWorkMessage(messageFrom, messageTo, messageDetail, status, isModify);
            case MessageType.MSG_LOG_STRING: //日志
                return new HandlderLogWorkMessageContent().getCommonWorkMessage(messageFrom, messageTo, messageDetail, status, isModify);
            case MessageType.MSG_TASK_STRING: //任务
                return new HandlderTaskWorkMessageContent().getCommonWorkMessage(messageFrom, messageTo, messageDetail, status, isModify);
            case MessageType.MSG_INSPECT_STRING: //检查
                return new HandlderCheckPlanWorkMessageContent().getCommonWorkMessage(messageFrom, messageTo, messageDetail, status, isModify);
            case MessageType.MSG_APPROVAL_STRING: //审批
                return new HandlderApprovalWorkMessageContent().getCommonWorkMessage(messageFrom, messageTo, messageDetail, status, isModify);
            default:
                return "未知的系统消息类型";
        }
    }
}
