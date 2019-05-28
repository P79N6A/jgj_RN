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
public class DiaLogRecordSuccess extends Dialog implements View.OnClickListener {
    /* 添加记账对象接口回调 */
    private AccountSuccessListenerClick listener;
    private String role_type;


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(true);
    }


    public DiaLogRecordSuccess(Context context, AccountSuccessListenerClick listener, String role_type) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        this.role_type = role_type;
        createLayout();
        commendAttribute(false);
    }

    public void setListener(AccountSuccessListenerClick listener) {
        this.listener = listener;
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.layout_add_recoedsuccess);
        TextView tv_left = (TextView) findViewById(R.id.redBtn);
        TextView tv_right = (TextView) findViewById(R.id.btn_asscess);
        tv_left.setOnClickListener(this);
        tv_right.setOnClickListener(this);
        if (role_type.equals("1")) {
            tv_left.setText("再记一笔");
            tv_right.setText("返回");
        } else {
            tv_left.setText("返回");
            tv_right.setText("再记一笔");
        }

    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn://左边
                if (role_type.equals("1")) {
                    listener.successAccountClick();
                } else {
                    listener.cancelAccountClick();
                }
                dismiss();
                break;
            case R.id.btn_asscess://右边
                if (role_type.equals("1")) {
                    listener.cancelAccountClick();
                } else {
                    listener.successAccountClick();
                }
                dismiss();
                break;
        }
    }

    public interface AccountSuccessListenerClick {
        //确认
        void successAccountClick();

        //取消
        void cancelAccountClick();
    }

}
