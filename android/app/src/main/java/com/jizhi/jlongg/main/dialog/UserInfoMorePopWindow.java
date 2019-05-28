package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.UserInfoClickListener;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.network.NetWorkRequest;


/**
 * WheelView 加入黑名单弹出框
 *
 * @author Xuj
 * @date 2016-12-20 16:35:38
 */
public class UserInfoMorePopWindow extends PopupWindowExpand implements View.OnClickListener {


    private String uid;
    private Activity activity;
    /* popwindow */
    public View popView;
    /**
     * 是否在黑名单
     */
    private int isVisibleBlack;
    /**
     * 是否是好友
     **/
    private int isVisibleDelete;
    private UserInfoClickListener userInfoClickListener;

    public UserInfoMorePopWindow(Activity activity, String uid, int isVisibleBlack, int isVisibleDelete, UserInfoClickListener userInfoClickListener) {
        super(activity);
        this.uid = uid;
        this.activity = activity;
        this.isVisibleBlack = isVisibleBlack;
        this.isVisibleDelete = isVisibleDelete;
        this.userInfoClickListener = userInfoClickListener;
        setPopView();
        initView();
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.blacklist_popwindow, null);
        setContentView(popView);
        setPopParameter();
    }

    private void initView() {
        popView.findViewById(R.id.btnJoinBlackList).setOnClickListener(this);
        popView.findViewById(R.id.lin_delete).setOnClickListener(this);
        popView.findViewById(R.id.lin_complaint).setOnClickListener(this);
//        popView.findViewById(R.id.btnCancel).setOnClickListener(this);
        LUtils.e(isVisibleDelete + "其他：" + isVisibleBlack);
        if (isVisibleDelete == 1 && isVisibleBlack != 1) {
            LUtils.e("是好友并且不在黑名单都显示");
            //如果是好友并且不在黑名单都显示
            popView.findViewById(R.id.btnJoinBlackList).setVisibility(View.VISIBLE);
            popView.findViewById(R.id.view).setVisibility(View.VISIBLE);
            popView.findViewById(R.id.lin_delete).setVisibility(View.VISIBLE);
        } else if (isVisibleBlack == 1 && isVisibleDelete == 1) {
            //如果在黑名单又是好友只显示删除按钮
            LUtils.e("在黑名单又是好友只显示删除按钮");
            popView.findViewById(R.id.btnJoinBlackList).setVisibility(View.GONE);
            popView.findViewById(R.id.view).setVisibility(View.VISIBLE);
            popView.findViewById(R.id.lin_delete).setVisibility(View.VISIBLE);
        } else if (isVisibleDelete != 1 && isVisibleBlack != 1) {
            //如果不是好友并且不在黑名单
            LUtils.e("如果不是好友并且不在黑名单");
            popView.findViewById(R.id.btnJoinBlackList).setVisibility(View.VISIBLE);
            popView.findViewById(R.id.lin_delete).setVisibility(View.GONE);
            popView.findViewById(R.id.view).setVisibility(View.GONE);
        } else if (isVisibleDelete != 1) {
            //如果不是好友只显示加入黑名单
            LUtils.e("不是好友只显示加入黑名单");
            popView.findViewById(R.id.btnJoinBlackList).setVisibility(View.VISIBLE);
            popView.findViewById(R.id.lin_delete).setVisibility(View.GONE);
            popView.findViewById(R.id.view).setVisibility(View.GONE);
        } else {
            LUtils.e(isVisibleDelete + "其他：" + isVisibleBlack);
        }
    }

    public void setPopParameter() {
        setWidth(ViewGroup.LayoutParams.WRAP_CONTENT);
        setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
        setFocusable(true);
        ColorDrawable dw = new ColorDrawable(0X00000000);
        setBackgroundDrawable(dw);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btnJoinBlackList: //加入黑名单
                new DialogAddBlackList(activity, uid, activity.getString(R.string.balcklist_hint), 1, userInfoClickListener).show();
                break;
            case R.id.lin_delete: //删除好友
                new DialogDeleteFriend(activity, uid, activity.getString(R.string.delete_friend_hint), userInfoClickListener
                ).show();
                break;
            case R.id.lin_complaint:
                String url= NetWorkRequest.WEBURLS+"report?key="+uid+"&mstype=person";
                X5WebViewActivity.actionStart(activity,url);
                break;
        }
        dismiss();
    }
}