package com.jizhi.jlongg.main.popwindow;


import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;

import com.jizhi.jlongg.R;


/**
 * 项目云盘弹出框
 *
 * @author xuj
 * @version 1.0
 * @time 2017年7月17日15:41:36
 */
public class ProCloudyPopWindow extends PopupWindow implements View.OnClickListener {


    /* popwindow */
    public View popView;
    /* 上下文 */
    public Activity activity;
    /* 操作更多回调 */
    private MoreActionsListener clickMoreActions;


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.pro_cloudy_popwindow, null);
        setContentView(popView);
        setPopParameter();
    }

    public ProCloudyPopWindow(Activity activity, MoreActionsListener moreActionsListener) {
        super(activity);
        this.activity = activity;
        this.clickMoreActions = moreActionsListener;
        setPopView();
        setClick();
    }

    private void setClick() {
        popView.findViewById(R.id.more_action_layout).setOnClickListener(this);
        popView.findViewById(R.id.recycle_bin_layout).setOnClickListener(this);
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
            case R.id.more_action_layout: //更多操作
                if (clickMoreActions != null) {
                    clickMoreActions.clickMoreActions();
                }
                break;
            case R.id.recycle_bin_layout: //回收站
                if (clickMoreActions != null) {
                    clickMoreActions.clickRecycleBin();
                }
                break;
        }
        dismiss();
    }

    /**
     * 更多操作
     */
    public interface MoreActionsListener {
        /**
         * 操作更多
         */
        public void clickMoreActions();

        /**
         * 点击回收站
         */
        public void clickRecycleBin();
    }
}
