package com.jizhi.jlongg.main.WorkMessage;

/**
 * 功能:云盘消息类型
 * 作者：xuj
 * 时间: 2018年10月9日17:02:55
 */
public class HandlderCloudWorkMessageContent implements HandlerWorkMessageContent {

    @Override
    public String getCommonWorkMessage(String messageFrom, String messageTo, String messageDetail, int state, boolean isModify) {
        return "<strong><font color='#000000'>" + messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
    }
}
