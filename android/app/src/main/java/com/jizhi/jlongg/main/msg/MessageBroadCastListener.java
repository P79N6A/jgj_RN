package com.jizhi.jlongg.main.msg;

import com.jizhi.jlongg.main.bean.MessageBean;

import java.util.List;

/**
 * 消息回调接口
 */
public interface MessageBroadCastListener {
    /**
     * 发送消息回调
     */

    void sendPicMessage(List<MessageBean> beanList);

    /**
     * 加载本地消息回调
     */

    void showRoamMessage(List<MessageBean> beanList);

    /**
     * 显示多条消息到顶部
     */

    void showMoreMessageTop(List<MessageBean> beanList);

    /**
     * 显示多条消息到底部
     */

    void showMoreMessageBottom(List<MessageBean> beanList);

    /**
     * 显示单挑条消息到底部
     */

    void showSingleMessageBottom(MessageBean bean);

    /**
     * 消息撤回
     */
    void reCallMessage(MessageBean bean);

    /**
     * 消息发送成功改变状态
     */
    void changetMsgState(MessageBean bean);

    /**
     * 消息已读回执
     */
    void MsgAlreadyRead(List<MessageBean> bean);

    /**
     * 更新未读数量
     */
    void MsgUnderReadCount(MessageBean bean);

    /**
     * 开始播放播放语音
     */
    void startPlayVoice(int position);

    /**
     * 停止播放播放语音
     */
    void stopPlayVoice(int position);

    /**
     * 点击语音
     */
    void clickVoice(int position);

    /**
     * 点击头像
     */
    void clickHead(int position);

    /**
     * 重发消息
     */
    void sendFialMessage(int position);

    /**
     * 未读详情
     */
    void toReadInfoList(int position);

    /**
     * 长按消息
     */
    void onLongClickListener(int position);

    /**
     * 长按头像
     */
    void onHeadLongClickListener(int position);

    /**
     * 点击图片
     */
    void onPictureClick(int position);

    /**
     * 质量日志通知安全详情
     */
    void toNoticeOrLogSafeQualityDetail(int position);

    /**
     * 发送名片
     */
    void onSendPostCard(int position, String text,boolean isSendPostCard);

    /**
     * 发送招工信息
     */
    void onSendFindJob(int position, String text);

    /**
     * 点击名片
     */
    void clickPostCard(int position);


    /**
     * 添加消息集合
     */
    void AddMessageList(List<MessageBean> listMsg);

    /**
     * 关闭当前页面
     */
    void finishActivity();

    /**
     * 修改了昵称
     */
    void userNameFlush(String name, String uid);

    /**
     * 更新未读数量
     */
    void MsgUnderListReadCount(List<MessageBean> mEntity);

    /**
     * 更新未读数量
     */
    void MsgUnderListReadCount11111111111(List<MessageBean> mEntity);
    /**
     * 消息发送失败
     */
    void sendMsgFail(String local_id);

}
