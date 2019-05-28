package com.jizhi.jlongg.main.popwindow;


import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;

import com.google.zxing.client.android.scanner.CaptureActivity;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.main.activity.AddFriendMainctivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ContactsActivity;
import com.jizhi.jlongg.main.activity.FriendApplicationListActivity;
import com.jizhi.jlongg.main.activity.InitiateGroupChatActivity;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.MessageUtil;


/**
 * 聊聊 加号弹出框
 *
 * @author xuj
 * @version 1.0
 * @time 2016-12-19 15:18:46
 */
public class ChatAddPopWindow extends PopupWindow implements View.OnClickListener {

    /* popwindow */
    public View popView;
    /* 上下文 */
    public Activity activity;


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.chat_add_popwindow, null);
        setContentView(popView);
        setPopParameter();
    }

    public ChatAddPopWindow(Activity activity) {
        super(activity);
        this.activity = activity;
        setPopView();
        setClick();
    }

    private void setClick() {
        popView.findViewById(R.id.new_friend_layout).setOnClickListener(this);
        popView.findViewById(R.id.contact_layout).setOnClickListener(this);
        popView.findViewById(R.id.scan_layout).setOnClickListener(this);
        popView.findViewById(R.id.add_friend_layout).setOnClickListener(this);
        popView.findViewById(R.id.group_chat_layout).setOnClickListener(this);
    }

    private void setPopParameter() {
        //设置SelectPicPopupWindow弹出窗体的宽
        setWidth(ViewGroup.LayoutParams.WRAP_CONTENT);
        //设置SelectPicPopupWindow弹出窗体的高
        setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
        //设置SelectPicPopupWindow弹出窗体可点击
        setFocusable(true);
        //设置SelectPicPopupWindow弹出窗体动画效果
//        setAnimationStyle(R.style.AnimTools);
        //实例化一个ColorDrawable颜色为半透明
        ColorDrawable dw = new ColorDrawable(0X00000000);
        //设置SelectPicPopupWindow弹出窗体的背景
        setBackgroundDrawable(dw);
    }


    private void handlerOnClick(View v) {
        switch (v.getId()) {
            case R.id.new_friend_layout: //新朋友
                FriendApplicationListActivity.actionStart(activity);
                break;
            case R.id.contact_layout: //通讯录
                ContactsActivity.actionStart(activity);
                break;
            case R.id.scan_layout: //扫一扫
                CaptureActivity.actionStart(activity);
                break;
            case R.id.add_friend_layout: //添加朋友
                AddFriendMainctivity.actionStart(activity);
                break;
            case R.id.group_chat_layout: //发起群聊
                InitiateGroupChatActivity.actionStart(activity, MessageUtil.WAY_CREATE_GROUP_CHAT,
                        null, null, false, null, null, null, null);
                break;
        }
    }

    @Override
    public void onClick(final View v) {
        dismiss();
        IsSupplementary.isFillRealNameCallBackListener(activity, false, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() { //补充姓名成功后的回调
                //完善姓名成功
                Utils.sendBroadCastToUpdateInfo((BaseActivity) activity);
                handlerOnClick(v);
            }
        });
    }
}
