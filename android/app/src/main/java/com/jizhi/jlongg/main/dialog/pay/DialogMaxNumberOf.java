package com.jizhi.jlongg.main.dialog.pay;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;


/**
 * 功能:项目组人数已达上限
 * 时间:2017年7月18日15:18:14
 * 作者:xuj
 */
public class DialogMaxNumberOf extends Dialog implements View.OnClickListener {


    private BaseActivity activity;

    private DiaLogTitleListener listener;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DialogMaxNumberOf(BaseActivity activity, DiaLogTitleListener listener) {
        super(activity, R.style.network_dialog_style);
        this.activity = activity;
        this.listener = listener;
        createLayout(activity);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity) {
        setContentView(R.layout.max_number_dialog);
        findViewById(R.id.btn_asscess).setOnClickListener(this);
        findViewById(R.id.redBtn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        dismiss();
        switch (v.getId()) {
            case R.id.redBtn: //取消
                break;
            case R.id.btn_asscess: //确定
                if (listener != null) {
                    listener.clickAccess(-1);
                }
                break;
        }
    }


}
