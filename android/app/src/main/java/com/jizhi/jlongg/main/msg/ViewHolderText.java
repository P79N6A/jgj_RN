package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.view.View;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.NewMessageUtils;

import java.util.List;

public class ViewHolderText extends MessageRecycleViewHolder {


    public ViewHolderText(View itemView, Activity activity, boolean isSignChat, MessageBroadCastListener messageBroadCastListener) {
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
        //左右内容
        tv_text_left = itemView.findViewById(R.id.tv_text_left);
        tv_text_right = itemView.findViewById(R.id.tv_text_right);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(MessageBean message) {
        setItemAlickData(message);
        DataUtil.setHtmlClick(NewMessageUtils.isMySendMessage(message) ? tv_text_right : tv_text_left, activity);
        NewMessageUtils.settextStyle(activity, NewMessageUtils.isMySendMessage(message) ? tv_text_right : tv_text_left);
        if (!NewMessageUtils.isMySendMessage(message)) {
            tv_text_left.setText(message.getMsg_text());
            tv_text_left.setOnLongClickListener(onLongClickListener);
        } else {
            tv_text_right.setText(message.getMsg_text());
            tv_text_right.setOnLongClickListener(onLongClickListener);
        }
        img_sendfail.setOnClickListener(onClickListener);
    }
}
