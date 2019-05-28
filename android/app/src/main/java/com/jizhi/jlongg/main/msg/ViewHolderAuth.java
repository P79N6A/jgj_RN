package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 找工作
 */
public class ViewHolderAuth extends MessageRecycleViewHolder {
    private LinearLayout lin_findjob, lin_findhelper;//找工作布局，招聘(个人信息)布局
    private TextView tv_money;//金额


    public ViewHolderAuth(View itemView, Activity activity) {
        super(itemView);
        this.activity = activity;
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
        lin_findjob = itemView.findViewById(R.id.lin_findjob);
        lin_findhelper = itemView.findViewById(R.id.lin_findhelper);
        tv_money = itemView.findViewById(R.id.tv_money);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(final MessageBean message) {
        //只有接收方才显示发送者未实名信息
        if (!TextUtils.isEmpty(message.getMsg_sender()) && !NewMessageUtils.isMySendMessage(message)) {
            //显示对方未实名
            itemView.findViewById(R.id.lin_verify).setVisibility(View.VISIBLE);

            LUtils.e("显示对方未实名:" + new Gson().toJson(message));
            if (null != message.getUser_info() && !TextUtils.isEmpty(message.getUser_info().getFull_name())) {
                ((TextView) itemView.findViewById(R.id.tv_verifie_type)).setText(Html.fromHtml("<font color='#FF6600'>" + message.getUser_info().getFull_name() + "</font> 未实名认证"));
            } else if (!TextUtils.isEmpty(message.getMsg_text())) {
                ((TextView) itemView.findViewById(R.id.tv_verifie_type)).setText(Html.fromHtml("<font color='#FF6600'>" + message.getMsg_text() + "</font> 未实名认证"));

            } else {
                ((TextView) itemView.findViewById(R.id.tv_verifie_type)).setText(Html.fromHtml("<font color='#FF6600'>他</font> 未实名认证"));

            }
        } else {
            itemView.findViewById(R.id.lin_verify).setVisibility(View.GONE);
        }
    }

}
