package com.jizhi.jlongg.main.WorkMessage;

public class SyncWorkMessageFactory implements WorkMessageContentFactory {

    /**
     * 获取同步的工作消息类型
     *
     * @param messageType 消息类型
     * @param messageFrom 消息来自
     * @param messageTo   消息到
     */
    @Override
    public String createMessageContent(String messageType, String messageFrom, String messageTo, String messageDetail, int status,
                                       boolean isModify, String classType) {
//        return new HandlderCloudWorkMessageContent().getCommonWorkMessage(messageFrom, messageTo, messageDetail, status, isModify);
        return null;
    }
}
