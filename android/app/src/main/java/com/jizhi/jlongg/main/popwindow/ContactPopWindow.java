package com.jizhi.jlongg.main.popwindow;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.AddFriendMainctivity;
import com.jizhi.jlongg.main.activity.BlackListActivity;
import com.jizhi.jlongg.main.util.Constance;


/**
 * 通讯录弹出框
 *
 * @author xuj
 * @version 1.0
 * @time 2016-12-19 15:18:46
 */
public class ContactPopWindow extends PopupWindow implements View.OnClickListener {

    /* popwindow */
    public View popView;
    /* 上下文 */
    public Activity activity;


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.contact_popwindow, null);
        setContentView(popView);
        setPopParameter();
    }

    public ContactPopWindow(Activity activity) {
        super(activity);
        this.activity = activity;
        setPopView();
        setClick();
    }

    private void setClick() {
        popView.findViewById(R.id.black_list_layout).setOnClickListener(this);
        popView.findViewById(R.id.add_friend_layout).setOnClickListener(this);
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


    @Override
    public void onClick(View v) {
        Intent intent = new Intent();
        switch (v.getId()) {
            case R.id.black_list_layout: //黑名单
                intent.setClass(activity, BlackListActivity.class);
                break;
            case R.id.add_friend_layout: //添加朋友
                intent.setClass(activity, AddFriendMainctivity.class);
                break;
        }
        activity.startActivityForResult(intent, Constance.REQUEST);
        dismiss();
    }
}
