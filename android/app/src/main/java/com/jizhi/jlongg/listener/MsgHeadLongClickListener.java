package com.jizhi.jlongg.listener;

import com.jizhi.jlongg.main.bean.MessageEntity;

/**
 * 消息长按
 */

public interface MsgHeadLongClickListener {
     void MsgHeadLongClickLisstener(MessageEntity msgEntity);

    /**
     * 图片发送成功
     */
     void sendPictureSuccess(MessageEntity msgEntity, int position);

    /**
     * 图片正在发送
     */
     void sendPictureSending(int position);

    /**
     * 播放语音
     */
    void playVoice(int position);
}
