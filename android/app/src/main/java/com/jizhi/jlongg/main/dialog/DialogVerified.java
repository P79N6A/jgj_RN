package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.network.NetWorkRequest;


/**
 * 功能:实名认证弹框
 * 时间:2018年12月17日15:34:36
 * 作者:xuj
 */
public class DialogVerified extends Dialog implements View.OnClickListener {

    private Activity activity;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(boolean isVerified) {
        setContentView(R.layout.dialog_verified);
        findViewById(R.id.left_btn).setOnClickListener(this);
        TextView rightBtn = findViewById(R.id.right_btn);
        if (isVerified) {
            rightBtn.setVisibility(View.GONE);
            findViewById(R.id.content1).setVisibility(View.GONE);
            findViewById(R.id.content2).setVisibility(View.GONE);
            findViewById(R.id.content3).setVisibility(View.GONE);
            findViewById(R.id.title2_layout).setVisibility(View.GONE);
        } else {
            rightBtn.setOnClickListener(this);
        }
    }

    @Override
    public void onClick(View v) {
        dismiss();
        switch (v.getId()) {
            case R.id.right_btn: //确认
                X5WebViewActivity.actionStart(activity, NetWorkRequest.WEBURLS + "my/idcard");
                break;
        }
    }

    public DialogVerified(Activity activity, boolean isVerified) {
        super(activity, R.style.network_dialog_style);
        this.activity = activity;
        setCanceledOnTouchOutside(true);
        setCancelable(true);
        createLayout(isVerified);
    }

}
