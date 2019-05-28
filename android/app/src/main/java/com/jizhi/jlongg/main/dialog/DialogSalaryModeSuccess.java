package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;


/**
 * 功能:添加班组成员
 * 时间:2016年9月14日 15:40:05
 * 作者:xuj
 */
public class DialogSalaryModeSuccess extends Dialog implements View.OnClickListener {
    /* 添加记账对象接口回调 */
    private SalarySuccessClickListenerClick listener;


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(true);
    }


    public DialogSalaryModeSuccess(Context context, SalarySuccessClickListenerClick listener, String text) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        createLayout(text);
        commendAttribute(false);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String text) {
        setContentView(R.layout.layout_salray_success_dialog);
        findViewById(R.id.redBtn).setOnClickListener(this);
        ((TextView) findViewById(R.id.tv_hint)).setText(text);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn:
                listener.Succes();
                dismiss();
                break;
        }
    }

    public interface SalarySuccessClickListenerClick {
        //确认
        void Succes();

    }

}
