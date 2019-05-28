package com.jizhi.jlongg.main.WorkMessage;

public interface WorkMessageContentFactory {

    /**
     * @param messageType   消息类型(具体的看文档)
     * @param messageFrom   消息的类型(这个取值为操作者)
     * @param messageTo     消息来自哪里(这个取值为项目名称)
     * @param messageDetail 消息内容详情(需要展示的消息剩下的完整类型)
     * @param status        消息的状态 根据不同的工作消息类型有不同的状态 具体的需要看文档
     * @param isModify      true表示工作消息已修改
     * @param classType     组类型 取值为team、group(班组、项目组状态发生变化的时候需要调用)
     * @return
     */
    public String createMessageContent(String messageType, String messageFrom, String messageTo, String messageDetail, int status, boolean isModify, String classType);
}
