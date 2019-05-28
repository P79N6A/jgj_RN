package com.jizhi.jlongg.main.popwindow;


import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.SetRecorderActivity;
import com.jizhi.jlongg.main.activity.WeatherListActivity;


/**
 * 晴雨表弹出框
 *
 * @author xuj
 * @version 1.1.4
 * @time 2017年3月29日11:51:55
 */
public class WeatherPopWindow extends PopupWindow implements View.OnClickListener {

    /* popwindow */
    public View popView;
    /* 上下文 */
    public Activity activity;

    private boolean isClose;


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.weather_popwindow, null);
        setContentView(popView);
        setPopParameter();
    }

    public WeatherPopWindow(Activity activity, boolean isShowSetRecorder,boolean isClose) {
        super(activity);
        this.isClose = isClose;
        this.activity = activity;
        setPopView();
        setClick(isShowSetRecorder);
    }

    private void setClick(boolean isShowSetRecorder) {
        popView.findViewById(R.id.weather_detail_layout).setOnClickListener(this);
        View setRecorder = popView.findViewById(R.id.set_recoder_layout);
        if (isShowSetRecorder) {
            setRecorder.setOnClickListener(this);
        } else {
            setRecorder.setVisibility(View.GONE);
        }
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
        switch (v.getId()) {
            case R.id.set_recoder_layout: //设置记录员
                SetRecorderActivity.actionStart(activity,isClose);
                break;
            case R.id.weather_detail_layout: //天气详情
                WeatherListActivity.actionStart(activity);
                break;
        }
        dismiss();
    }
}
