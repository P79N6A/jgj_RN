package com.jizhi.jlongg.main.WorkMessage;

/**
 * 功能:处理检查计划工作消息类型
 * 作者：xuj
 * 时间: 2018年10月9日17:02:55
 */
public class HandlderCheckPlanWorkMessageContent implements HandlerWorkMessageContent {


    @Override
    public String getCommonWorkMessage(String messageFrom, String messageTo, String messageDetail, int state, boolean isModify) {
        switch (state) {
            case 1: //检查计划执行通知 格式为:[项目名称]的[检查计划名称]即将开始执行，点击查看详情
                return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;的&nbsp;</font><strong><font color='#000000'>" +
                        messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
            case 3://检查计划完成通知 格式为:你在[项目名称]安排的[检查计划名称]已执行完成，点击查看详情
//                return "<font color='#666666'>你在</font><strong><font color='#000000'>" + messageTo + "</font></strong><font color='#666666'>&nbsp;安排的&nbsp;</font><strong><font color='#000000'>" +
//                        messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
                return "<font color='#666666'>你在</font><strong><font color='#000000'>" + messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
            default://检查计划安排通知  [操作者]在[项目名称]给你安排了一项检查计划，点击查看详情
                return "<strong><font color='#000000'>" + messageFrom + "</font></strong><font color='#666666'>&nbsp;在&nbsp;</font><strong><font color='#000000'>" +
                        messageTo + "</font></strong><font color='#666666'>&nbsp;" + messageDetail + "</font>";
        }
    }
}
