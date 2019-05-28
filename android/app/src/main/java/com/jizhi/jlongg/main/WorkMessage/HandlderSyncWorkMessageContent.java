package com.jizhi.jlongg.main.WorkMessage;

/**
 * 功能:处理同步工作消息类型
 * 作者：xuj
 * 时间: 2018年10月9日17:02:55
 */
public class HandlderSyncWorkMessageContent implements HandlerWorkMessageContent {

    @Override
    public String getCommonWorkMessage(String messageFrom, String messageTo, String messageDetail, int state, boolean isModify) {
        if (!isModify) {
            switch (state) {
                case 1://要求同步项目 -->格式为:用户A 要求你同步项目情况
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
                case 2://待复查-->格式为:用户A（项目部）向你请求同步记工数据  【拒绝】【同步】
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
                case 3://已完结-->格式为:你拒绝同步项目情况给用户A（项目部）
                    return "<font color='#666666'>你拒绝同步项目情况给</font><strong><font color='#000000'>&nbsp;" + messageFrom + "</font></strong>";
                case 4://已删除-->格式为:[操作者]在[项目名称]删除了一项安排给你的[质量 | 安全]整改
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                            messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
                default://待整改-->[操作者]在[项目名称]修改了一项[质量 | 安全]问题的整改措施，点击查看详情
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                            messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
            }
        } else {
            return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                    messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
        }
    }
}
