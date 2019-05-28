package com.jizhi.jlongg.main.popwindow;


import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;

import com.google.zxing.client.android.scanner.CaptureActivity;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.CreateTeamGroupActivity;
import com.jizhi.jlongg.main.util.IsSupplementary;

/**
 * 项目右上角弹出框
 *
 * @author xuj
 * @version 1.1.4
 * @time 2017年4月19日11:11:42
 */
public class WorkCirclePopWindow extends PopupWindow implements View.OnClickListener {

    /* popwindow */
    public View popView;
    /* 上下文 */
    public Activity activity;


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.work_circle_popwindow, null);
        setContentView(popView);
        setPopParameter();
    }

    public WorkCirclePopWindow(Activity activity) {
        super(activity);
        this.activity = activity;
        setPopView();
        setClick();
    }

    private void setClick() {
        popView.findViewById(R.id.scan_layout).setOnClickListener(this);
        popView.findViewById(R.id.create_team_layout).setOnClickListener(this);
//        popView.findViewById(R.id.syncLayout).setOnClickListener(this);
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
            case R.id.scan_layout: //扫一扫
                CaptureActivity.actionStart(activity);
                break;
            case R.id.create_team_layout: //新建项目
                CreateTeamGroupActivity.actionStart(activity);
                break;
        }
    }


    @Override
    public void onClick(final View v) {
        dismiss();
        IsSupplementary.isFillRealNameCallBackListener(activity, false, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() { //补充姓名成功后的回调
                handlerOnClick(v);
            }
        });
    }

}
