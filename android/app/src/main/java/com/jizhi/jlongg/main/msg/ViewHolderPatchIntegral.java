package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.graphics.Color;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.QuickJoinGroupChatActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.network.NetWorkRequest;

import java.util.List;

public class ViewHolderPatchIntegral extends MessageRecycleViewHolder {
    private List<MessageBean> list;


    public ViewHolderPatchIntegral(View itemView, Activity activity) {
        super(itemView);
        this.activity = activity;
        initItemView();
    }

    @Override
    public void bindHolder(int position, List<MessageBean> list) {
        this.list = list;
        this.position = position;
        setItemData(list.get(position));
    }

    /**
     * 获取itemView
     */
    public void initItemView() {
        //左右内容
//        tv_text_left =itemView.findViewById(R.id.tv_text_left);
//        tv_text_right =  itemView.findViewById(R.id.tv_text_right);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(final MessageBean message) {
        String date = message.getSend_time() == 0 ? "" : Utils.simpleMessageForDate(message.getSend_time());
        ((TextView) itemView.findViewById(R.id.message_title)).setText(!TextUtils.isEmpty(message.getTitle()) ? message.getTitle() : "");
        ((TextView) itemView.findViewById(R.id.message_title)).setTextColor(Color.parseColor("#25a5ed"));
        ((TextView) itemView.findViewById(R.id.message_content)).setText(TextUtils.isEmpty(message.getDetail()) ? "" : Html.fromHtml(message.getDetail()));
        if (message.getMsg_type().equals(MessageType.MSG_PRESENT_STRING)) {
            //活动消息
            ((TextView) itemView.findViewById(R.id.detail_content)).setText("查看详情");
            itemView.findViewById(R.id.detail_content).setVisibility(View.VISIBLE);
        } else if (message.getMsg_type().equals(MessageType.LOCAL_GROUP_CHAT_STRING)) {
            //加入地方群
            ((TextView) itemView.findViewById(R.id.detail_content)).setText("快速加群");
            itemView.findViewById(R.id.detail_content).setVisibility(View.VISIBLE);
        } else if (message.getMsg_type().equals(MessageType.WORK_GROUP_CHAT_STRING)) {
            //加入工作群
            ((TextView) itemView.findViewById(R.id.detail_content)).setText("快速加群");
            itemView.findViewById(R.id.detail_content).setVisibility(View.VISIBLE);
        }else if (message.getMsg_type().equals(MessageType.MSG_POST_CENSOR_STRING)) {
            //加入工作群
//            ((TextView) itemView.findViewById(R.id.detail_content)).setText("快速加群");
            itemView.findViewById(R.id.detail_content).setVisibility(View.GONE);
        }

        ((TextView) itemView.findViewById(R.id.message_type_and_date)).setText("活动消息 " + date);
        ((ImageView) itemView.findViewById(R.id.message_type_icon)).setImageResource(R.drawable.activity_message_chat_state);
        setOnClickListener(itemView.findViewById(R.id.item_layout),message);

    }

    public void setOnClickListener(View view, final MessageBean message) {
        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (message.getMsg_type().equals(MessageType.MSG_PRESENT_STRING)) {
                    //活动消息
                    if (!TextUtils.isEmpty(message.getUrl())) {
                        if (message.getUrl().contains("http") || message.getUrl().contains("https")) {
                            X5WebViewActivity.actionStart(activity, message.getUrl(), true);
                        } else {
                            X5WebViewActivity.actionStart(activity, NetWorkRequest.WEBURLS + message.getUrl(), true);
                        }
                    }
                } else if (message.getMsg_type().equals(MessageType.LOCAL_GROUP_CHAT_STRING) || message.getMsg_type().equals(MessageType.WORK_GROUP_CHAT_STRING)) {
                    //加入地方群,工作群
                    QuickJoinGroupChatActivity.actionStart(activity);
                }
            }
        });
    }
}
