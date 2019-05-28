package com.jizhi.jlongg.main.WorkMessage;

public interface HandlerGroupChatStateWorkMessage {

    /**
     * @param messageFrom   消息来自哪里
     * @param messageTo     消息到哪里
     * @param messageDetail 消息内容详情
     * @param state         消息的状态
     * @return
     */
    public String getCommonWorkMessage(String messageFrom, String messageTo, String messageDetail, String state, String classType);

}
