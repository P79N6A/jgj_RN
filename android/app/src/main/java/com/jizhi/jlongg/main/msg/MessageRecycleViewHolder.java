package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.graphics.drawable.AnimationDrawable;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 聊天适配器父类
 */
public abstract class MessageRecycleViewHolder extends RecyclerView.ViewHolder {
    //是否是单聊
    protected boolean isSignChat;
    //左右布局
    protected RelativeLayout layout_left, layout_right;
    //左右头像
    protected RoundeImageHashCodeTextLayout img_head_left, img_head_right;
    //左右内容
    protected TextView tv_text_left, tv_text_right;
    //左用户名字
    protected TextView tv_username_left;
    //右未读数，时间
    protected TextView tv_unread_right, tv_date_right;
    //右发送失败标识，发送动画
    protected ImageView img_sendfail, spinner;
    protected MessageBroadCastListener messageBroadCastListener;
    protected int position;
    protected Activity activity;

    public MessageRecycleViewHolder(View itemView) {
        super(itemView);
    }

    public abstract void bindHolder(int position, List<MessageBean> list);

    /**
     * 设置消息状态
     *
     * @param message
     */
    public void setMessageState(MessageBean message) {
        if (message.getMsg_state() == 2) {
            //正在发送
            spinner.setVisibility(View.VISIBLE);
            img_sendfail.setVisibility(View.INVISIBLE);
            spinner.setBackgroundResource(R.drawable.load_spinner); //将动画资源文件设置为ImageView的背景
            AnimationDrawable anim = (AnimationDrawable) spinner.getBackground(); //获取ImageView背景,此时已被编译成AnimationDrawable
            if (!anim.isRunning()) {
                anim.start();  //开始动画
            }
        } else if (message.getMsg_state() == 0) {
            //发送成功
            spinner.setVisibility(View.INVISIBLE);
            img_sendfail.setVisibility(View.INVISIBLE);
        } else if (message.getMsg_state() == 1) {
            //发送失败
            spinner.setVisibility(View.INVISIBLE);
            img_sendfail.setVisibility(View.VISIBLE);
        }
    }

    /**
     * 初始化相同的view
     */
    public void initAlickItemView() {
        //左右布局
        layout_left = itemView.findViewById(R.id.layout_left);
        layout_right = itemView.findViewById(R.id.layout_right);
        //左右头像
        img_head_left = itemView.findViewById(R.id.img_head_left);
        img_head_right = itemView.findViewById(R.id.img_head_right);
        //左用户名字
        tv_username_left = itemView.findViewById(R.id.tv_username_left);
        //右未读数
        tv_unread_right = itemView.findViewById(R.id.tv_unread_right);
        //右时间
        tv_date_right = itemView.findViewById(R.id.tv_date_right);
        //右发送失败标识
        img_sendfail = itemView.findViewById(R.id.img_sendfail);
        //发送动画
        spinner = itemView.findViewById(R.id.spinner);
    }

    /**
     * 设置显示左边还是右边
     *
     * @param message
     */
    public void setItemAlickData(MessageBean message) {
        layout_left.setVisibility(NewMessageUtils.isMySendMessage(message) ? View.GONE : View.VISIBLE);
        layout_right.setVisibility(NewMessageUtils.isMySendMessage(message) ? View.VISIBLE : View.GONE);
        if (!NewMessageUtils.isMySendMessage(message)) {
            tv_username_left.setText(message.getUser_info().getReal_name() + "  " + (message.getSend_time() == 0 ? "" : Utils.simpleMessageForDate(message.getSend_time())));
            img_head_left.setView(TextUtils.isEmpty(message.getHead_pic()) ? message.getUser_info().getHead_pic() : message.getHead_pic(), message.getUser_info().getReal_name(), position);
            img_head_left.setOnClickListener(onClickListener);
            img_head_left.setOnLongClickListener(onHeadLongClickListener);
        } else {
            tv_date_right.setText(message.getSend_time() == 0 ? "" : Utils.simpleMessageForDate(message.getSend_time()));
            img_head_right.setView(TextUtils.isEmpty(message.getHead_pic()) ? message.getUser_info().getHead_pic() : message.getHead_pic(), message.getUser_info().getReal_name(), position);
            img_head_right.setOnClickListener(onClickListener);
            tv_unread_right.setOnClickListener(onClickListener);
            if (!isSignChat && message.getUnread_members_num() > 0) {
                tv_unread_right.setVisibility(View.VISIBLE);
                tv_unread_right.setText(itemView.getResources().getString(R.string.message_unread, message.getUnread_members_num()));
            } else {
                tv_unread_right.setVisibility(View.GONE);
            }
            if (message.getMsg_type().equals(MessageType.MSG_TEXT_STRING) || message.getMsg_type().equals(MessageType.MSG_VOICE_STRING)
                    || message.getMsg_type().equals(MessageType.MSG_POSTCARD_STRING) || message.getMsg_type().equals(MessageType.MSG_LINK_STRING) ||
                    message.getMsg_type().equals(MessageType.RECTUITMENT_STRING)) {
                setMessageState(message);
            }

        }
    }

    /**
     * 点击事件
     */
    View.OnClickListener onClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            switch (v.getId()) {
                case R.id.rea_voice_right:
                case R.id.rea_voice_left:
                    messageBroadCastListener.clickVoice(position);
                    break;
                case R.id.img_head_left:
                case R.id.img_head_right:
                    if (null != messageBroadCastListener) {
                        messageBroadCastListener.clickHead(position);
                    }
                    break;
                case R.id.img_sendfail:
                    messageBroadCastListener.onLongClickListener(position);
                    break;
                case R.id.tv_unread_right:
                    messageBroadCastListener.toReadInfoList(position);
                    break;
                case R.id.rea_bg_left:
                case R.id.rea_bg_right:
                    messageBroadCastListener.toNoticeOrLogSafeQualityDetail(position);
                    break;
                case R.id.btn_send_postcard:
                    messageBroadCastListener.onSendPostCard(position, null, true);
                    break;
                case R.id.btn_send_findjob:
                    messageBroadCastListener.onSendFindJob(position, null);
                    break;
                case R.id.send_left:
                case R.id.send_right:
                    messageBroadCastListener.clickPostCard(position);
                    break;
            }
        }
    };
    /**
     * 长按事件
     */
    View.OnLongClickListener onLongClickListener = new View.OnLongClickListener() {
        @Override
        public boolean onLongClick(View v) {
            if (null != messageBroadCastListener) {
                messageBroadCastListener.onLongClickListener(position);
            }
            return true;
        }
    };
    /**
     * 长按头像
     */
    View.OnLongClickListener onHeadLongClickListener = new View.OnLongClickListener() {
        @Override
        public boolean onLongClick(View v) {
            if (null != messageBroadCastListener) {
                messageBroadCastListener.onHeadLongClickListener(position);
            }
            return true;
        }
    };
}
