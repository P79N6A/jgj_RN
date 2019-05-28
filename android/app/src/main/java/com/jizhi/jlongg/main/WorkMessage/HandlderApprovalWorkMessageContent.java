package com.jizhi.jlongg.main.WorkMessage;

/**
 * 功能:处理审批工作消息类型
 * 作者：xuj
 * 时间: 2018年10月9日17:02:55
 */
public class HandlderApprovalWorkMessageContent implements HandlerWorkMessageContent {


    @Override
    public String getCommonWorkMessage(String messageFrom, String messageTo, String messageDetail, int state, boolean isModify) {
        if (!isModify) {
            switch (state) {
                case 1://你提交的申请已被拒绝 -->格式为:[申请人] 在[项目名称]提交的[申请类型]申请已被其他审批人拒绝
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                            messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
                case 2://你收到一条审批抄送-->格式为:你在[项目名称]收到一条[申请类型]审批抄送
                    return "<font color='#666666'>你在</font><strong><font color='#000000'>&nbsp;" + messageTo + "&nbsp;</font></strong>" + "<font color='#666666'>" + messageDetail + "</font>";
                case 3://你有一条申请已审批通过 -->格式为:你在[项目名称]有一条[申请类型]申请已通过审批
                    return "<font color='#666666'>你在</font><strong><font color='#000000'>&nbsp;" + messageTo + "&nbsp;</font></strong>" + "<font color='#666666'>" + messageDetail + "</font>";
                case 4://撤回了一条申请 -->格式为:[操作者]在[项目名称]撤回了一条[申请类型]申请
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                            messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
                default://[操作者] 在[项目名称]提交了一条[申请类型]申请，请及时审批
                    return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                            messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
            }
        } else {
            return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                    messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
        }
    }
}
