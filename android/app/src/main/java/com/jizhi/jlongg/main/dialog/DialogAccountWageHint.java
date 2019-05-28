package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;

import com.jizhi.jlongg.R;


/**
 * 功能:删除质量、安全的详情
 * 时间:2016-65-11 11:55
 * 作者:hucs
 */
public class DialogAccountWageHint extends PopupWindow {
    private String plan_id;//计划id
    public View popView;
    private Activity activity;

    public DialogAccountWageHint(Activity activity, String plan_id) {
        super(activity);
        this.activity = activity;
        this.plan_id = plan_id;
        setPopView();
        updateContent();
    }


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.dialog_check_more, null);
        setContentView(popView);
        setPopParameter();
    }

    public void updateContent() {
//        popView.findViewById(R.id.tv_edit).setOnClickListener(this);
//        popView.findViewById(R.id.tv_del).setOnClickListener(this);
//        popView.findViewById(R.id.tv_cancel).setOnClickListener(this);
    }

    public void setPopParameter() {
        //设置SelectPicPopupWindow弹出窗体的宽
        setWidth(ViewGroup.LayoutParams.MATCH_PARENT);
        //设置SelectPicPopupWindow弹出窗体的高
        setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
        //设置SelectPicPopupWindow弹出窗体可点击
        setFocusable(true);
        //设置SelectPicPopupWindow弹出窗体动画效果
        setAnimationStyle(R.style.ActionSheetDialogAnimation);
        //实例化一个ColorDrawable颜色为半透明
        ColorDrawable dw = new ColorDrawable(0);
//        setOnDismissListener(this);
        //设置SelectPicPopupWindow弹出窗体的背景
        setBackgroundDrawable(dw);

    }

}