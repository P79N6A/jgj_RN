package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;


/**
 * 功能:确认框
 * 时间:2017年4月6日14:39:53
 * 作者:xuj
 */
public class DiaLogBottomRed extends Dialog implements View.OnClickListener {

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    /**
     * 记账添加工人、工头
     */
    public DiaLogBottomRed(BaseActivity context, String redBtnText, String content) {
        super(context, R.style.network_dialog_style);
        createLayout(redBtnText, content);
        commendAttribute(true);
    }

    /**
     * 记账添加工人、工头
     */
    public DiaLogBottomRed(BaseActivity context, String content) {
        super(context, R.style.network_dialog_style);
        createLayout(null, content);
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String redBtnText, String content) {
        setContentView(R.layout.dialog_bottom_red);
        findViewById(R.id.closeIcon).setVisibility(View.GONE);
        TextView tv_content = findViewById(R.id.tv_content);
        tv_content.setText(content);
        TextView bottomRedBtn = findViewById(R.id.redBtn);
        if (!TextUtils.isEmpty(redBtnText)) {
            bottomRedBtn.setText(redBtnText);
        }
        bottomRedBtn.setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        dismiss();

    }


}
