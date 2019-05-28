package com.jizhi.jlongg.main.WorkMessage;

public class GroupStateWorkMessageFactory implements WorkMessageContentFactory {

    /**
     * 获取班组、项目组、群聊工作消息状态
     *
     * @param messageType 消息类型
     * @param messageFrom 消息来自
     * @param messageTo   消息到
     */
    @Override
    public String createMessageContent(String messageType, String messageFrom, String messageTo, String messageDetail, int status, boolean isModify, String classType) {
        return new HandlderGroupChatStateWorkMessageContent().getCommonWorkMessage(messageFrom, messageTo, messageDetail, messageType, classType);
    }
}
