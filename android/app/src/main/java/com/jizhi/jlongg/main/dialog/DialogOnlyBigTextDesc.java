package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;

/**
 * 功能:只显示文本的弹出框
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogOnlyBigTextDesc extends Dialog implements View.OnClickListener {


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final String desc) {
        setContentView(R.layout.dialog_only_big_title);
        TextView close = (TextView) findViewById(R.id.redBtn);
        TextView btn_asscess = (TextView) findViewById(R.id.btn_asscess);
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        tv_content.setText(desc);
        close.setOnClickListener(this);
        btn_asscess.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess: //确认
                break;
        }
        dismiss();
    }


    public DialogOnlyBigTextDesc(BaseActivity context, String desc) {
        super(context, R.style.Custom_Progress);
        createLayout(desc);
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
