package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;


/**
 * 功能:班组管理数据来源人介绍
 * 时间:2016年9月28日 14:55:15
 * 作者:xuj
 */
public class DialogTeamManageSourceMemberTips extends Dialog implements View.OnClickListener {


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String title, String content) {
        setContentView(R.layout.dialog_bottom_red_title_content);
        TextView close = (TextView) findViewById(R.id.redBtn);
        TextView tvContent = (TextView) findViewById(R.id.tv_content);
        TextView tvTitle = (TextView) findViewById(R.id.title);
        tvContent.setTextSize(12);
        tvContent.setGravity(Gravity.LEFT);
        tvContent.setText(content);
        tvTitle.setText(title);
        close.setText("我知道了");
        close.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        dismiss();
    }


    public DialogTeamManageSourceMemberTips(BaseActivity context, String title, String content) {
        super(context, R.style.Custom_Progress);
        createLayout(title, content);
        commendAttribute(true);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


}
