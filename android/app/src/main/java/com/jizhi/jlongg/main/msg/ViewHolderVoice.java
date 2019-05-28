package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.graphics.drawable.AnimationDrawable;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.ScreenUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.util.NewMessageUtils;

import java.util.List;

public class ViewHolderVoice extends MessageRecycleViewHolder {
    //    private Activity activity;
    //左右语音框
    private RelativeLayout rea_voice_left, rea_voice_right;
    //左右语音动画
    private ImageView anim_left, anim_right;
    //左语音未读圆点
    private ImageView red_circle;
    //播放动画
    private AnimationDrawable voiceAnimation;

    public ViewHolderVoice(View itemView, Activity activity, boolean isSignChat, MessageBroadCastListener messageBroadCastListener) {
        super(itemView);
        this.activity = activity;
        this.isSignChat = isSignChat;
        this.messageBroadCastListener = messageBroadCastListener;
        initAlickItemView();
        initItemView();
    }

    @Override
    public void bindHolder(int position, List<MessageBean> list) {
        this.position = position;
        setItemData(list.get(position));
    }

    /**
     * 获取itemView
     */
    public void initItemView() {
        //左右语音框
        rea_voice_left = itemView.findViewById(R.id.rea_voice_left);
        rea_voice_right = itemView.findViewById(R.id.rea_voice_right);
        //左右内容
        tv_text_left = itemView.findViewById(R.id.tv_text_left);
        tv_text_right = itemView.findViewById(R.id.tv_text_right);
        //左右语音动画
        anim_left = itemView.findViewById(R.id.voiceAnimationImage_left);
        anim_right = itemView.findViewById(R.id.voiceAnimationImage_right);
        //左语音未读圆点
        red_circle = itemView.findViewById(R.id.red_circle);

    }


    /**
     * 设置item显示数据
     */
    public void setItemData(MessageBean message) {
        setItemAlickData(message);
        if (!NewMessageUtils.isMySendMessage( message)) {
            tv_text_left.setText(message.getVoice_long() + "\"");
            //根据时间设置语音长度
            ScreenUtils.setViewWidthLengthLin(activity, rea_voice_left, message.getVoice_long());
            if (message.getIs_readed_local() == 0) {
                red_circle.setVisibility(View.VISIBLE);
            } else {
                red_circle.setVisibility(View.GONE);
            }
            rea_voice_left.setOnClickListener(onClickListener);
            rea_voice_left.setOnLongClickListener(onLongClickListener);
        } else {
            tv_text_right.setText(message.getVoice_long() + "\"");
            rea_voice_right.setOnLongClickListener(onLongClickListener);
            //根据时间设置语音长度
            ScreenUtils.setViewWidthLengthLin(activity, rea_voice_right, message.getVoice_long());
            NewMessageUtils.settextStyle(activity, tv_text_right);
            if (!isSignChat && message.getUnread_members_num() > 0) {
                tv_unread_right.setVisibility(View.VISIBLE);
                tv_unread_right.setText(activity.getResources().getString(R.string.message_unread, message.getUnread_members_num()));
            } else {
                tv_unread_right.setVisibility(View.GONE);
            }
            rea_voice_right.setOnClickListener(onClickListener);
            img_sendfail.setOnClickListener(onClickListener);
        }

        if (message.isPlaying()) {
            LUtils.e("----22-----即将开始播放开始播放-------" + position);
            red_circle.setVisibility(View.GONE);
            anim_right.setImageResource(R.drawable.message_voice_right_playing);
            anim_left.setImageResource(R.drawable.message_voice_left_playing);
            voiceAnimation = NewMessageUtils.isMySendMessage(message) ? (AnimationDrawable) anim_right.getDrawable() : (AnimationDrawable) anim_left.getDrawable();
            voiceAnimation.start();
            messageBroadCastListener.startPlayVoice(position);
        } else {
            LUtils.e("-----22----停止播放-------" + position);
            messageBroadCastListener.stopPlayVoice(position);
            if (NewMessageUtils.isMySendMessage(message)) {
                anim_right.setImageResource(R.drawable.icon_message_right_voice3);
            } else {
                anim_left.setImageResource(R.drawable.icon_message_left_voice3);
            }
            //如果动画正在执行就停止
            if (null != voiceAnimation && voiceAnimation.isRunning()) {
                voiceAnimation.stop();
            }
        }
    }
}
