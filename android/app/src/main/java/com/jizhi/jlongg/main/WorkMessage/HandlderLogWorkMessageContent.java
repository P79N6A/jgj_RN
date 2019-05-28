package com.jizhi.jlongg.main.WorkMessage;

/**
 * 功能:处理日志工作消息类型
 * 作者：xuj
 * 时间: 2018年10月9日17:02:55
 */
public class HandlderLogWorkMessageContent implements HandlerWorkMessageContent {

    @Override
    public String getCommonWorkMessage(String messageFrom, String messageTo, String messageDetail, int state, boolean isModify) {
        if (!isModify) {
            switch (state) {
                case 4://已删除-->格式为:[操作者] 在[项目名称]删除了[日志日期]的[日志类型]
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                            messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
                default://[操作者] 在[项目名称]提交了一条[日志类型]
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                            messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
            }
        } else {
            return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                    messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
        }
    }
}
