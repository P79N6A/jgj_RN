package com.jizhi.jlongg.main.WorkMessage;

import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.WebSocketConstance;

/**
 * 功能:云盘消息类型
 * 作者：xuj
 * 时间: 2018年10月9日17:02:55
 */
public class HandlderGroupChatStateWorkMessageContent implements HandlerGroupChatStateWorkMessage {

    @Override
    public String getCommonWorkMessage(String messageFrom, String messageTo, String messageDetail, String state, String classType) {
        String teamGroupName = classType.equals(WebSocketConstance.TEAM) ? "项目组" : "班组";
        switch (state) {
            case MessageType.JOIN: //加入班组、项目组
                return "<strong><font color='#000000'>" + messageFrom + "&nbsp;</font></strong><font color='#666666'>将你加入" + teamGroupName +
                        ":</font>" + "<strong><font color='#000000'>&nbsp;" + messageTo + "&nbsp;</font></strong>";
            case MessageType.REMOVE: //移除班组、项目组
                return "<font color='#666666'>你被</font><strong><font color='#000000'>&nbsp;" + messageFrom + "&nbsp;</font></strong><font color='#666666'>移出" + teamGroupName + ":</font><strong>" +
                        "<font color='#000000'>&nbsp;" + messageTo + "&nbsp;</font></strong>";
            case MessageType.CLOSE://关闭班组、项目组
                return "<font color='#666666'>" + teamGroupName + ":</font><strong><font color='#000000'>&nbsp;" + messageTo + "&nbsp;</font></strong><font color='#666666'>被:</font>" +
                        "<strong><font color='#000000'>&nbsp;" + messageFrom + "&nbsp;</font></strong><font color='#666666'>关闭</font>";
            case MessageType.REOPEN: //重新开启班组、项目组
                return "<font color='#666666'>" + teamGroupName + ":</font><strong><font color='#000000'>&nbsp;" + messageTo + "&nbsp;</font></strong><font color='#666666'>被:</font>" +
                        "<strong><font color='#000000'>&nbsp;" + messageFrom + "&nbsp;</font></strong><font color='#666666'>重新开启</font>";
            case MessageType.TRANSFER_OF_MANAGEMENT: //转让群管理员
                return "<strong><font color='#000000'>" + messageFrom + "</font><font color='#666666'>&nbsp;把&nbsp;</font></strong><font color='#666666'>" + messageDetail + "</font>";
        }
        return null;
    }
}
