package com.jizhi.jlongg.main.listener;

import android.widget.TextView;

import com.jizhi.jongg.widget.BubbleImageView;

import java.util.List;

/**
 * Created by Administrator on 2016/12/2 0002.
 */

public interface MsgUploadListener {

    public void UpListener(int position, List<String> path, TextView tv_progress);
    public void UpListenerBuddleImg(int position, List<String> path, BubbleImageView bubbleImageView);
    public void UpVoiceRead(int position);
}
