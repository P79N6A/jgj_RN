package com.jizhi.jlongg.main.WorkMessage;

/**
 * 功能:处理会议工作消息类型
 * 作者：xuj
 * 时间: 2018年10月9日17:02:55
 */
public class HandlderMettingWorkMessageContent implements HandlerWorkMessageContent {


    @Override
    public String getCommonWorkMessage(String messageFrom, String messageTo, String messageDetail, int state, boolean isModify) {
        if (!isModify) {
            switch (state) {
                case 1://你有一个会议即将开始 -->格式为: [发起人]邀请你参与[会议开始时间]的会议即将开始
//                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;邀请你参与&nbsp;</font><strong><font color='#000000'>" +
//                            messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
                case 4://你有一个会议被取消 -->格式为:[操作者]取消了一条会议邀请
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                            messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
                default://你有一个会议邀请 -->[操作者]向你发起了一条会议邀请，并安排你进行会议记录
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong>&nbsp;" + messageDetail + "</font>";
            }
        } else {
            return "<strong><font color='#000000'>" + messageFrom + "</font></strong>&nbsp;" + messageDetail + "</font>";
        }
    }
}
