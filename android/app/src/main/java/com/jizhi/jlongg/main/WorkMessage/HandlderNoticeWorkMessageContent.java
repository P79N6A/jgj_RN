package com.jizhi.jlongg.main.WorkMessage;

/**
 * 功能:处理通知工作消息类型
 * 作者：xuj
 * 时间: 2018年10月9日17:02:55
 */
public class HandlderNoticeWorkMessageContent implements HandlerWorkMessageContent {


    @Override
    public String getCommonWorkMessage(String messageFrom, String messageTo, String messageDetail, int state, boolean isModify) {
        switch (state) {
            default:
                return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                        messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
        }
    }
}
